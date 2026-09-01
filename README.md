# Project J — Tuist

[Project A-Z](#project-a-z) 의 J 단계.

단계마다 새로운 기술 스택을 하나씩 더해가며, 조금씩 다른 기능을 구현해 나갑니다.
J 단계는 **Tuist**를 추가합니다 — 앱 기능은 I와 같습니다. **손으로 관리하던 `.xcodeproj` 4개와 `Package.swift` 를 매니페스트로 대체하는 순수 빌드 시스템 전환**입니다.

## 다루는 기술

- UIKit (Programmatic) · SwiftUI · MVVM · Diffable Data Source
- Combine (상태 바인딩) · async/await
- Clean Architecture (계층 분리 · 의존성 역전 · Use Case · DI 컨테이너)
- XCTest
- Swift Package Manager (I까지 — J에서 Tuist로 대체)
- Micro Feature Architecture (모듈 5종 세트 · Interface 의존 · Example 앱)
- **Tuist** (`Project.swift` · `Workspace.swift` · Plugin · `tuist scaffold`) ← 이번 단계 추가분

## 무엇이 달라졌나

I는 모듈 경계를 컴파일러에 맡기는 데는 성공했지만, 그 대가로 **손으로 관리할 파일이 5개** 남았습니다.

```
Modules/Package.swift                     36개 타깃          ← 코드로 선언 (좋음)
Projects/App/App.xcodeproj                             ┐
Projects/Feature/Trip/FeatureTrip.xcodeproj            │ 손편집
Projects/Feature/Itinerary/FeatureItinerary.xcodeproj  │ (24자리 hex ID)
Projects/Feature/Reservation/FeatureReservation.xcodeproj ┘
```

I의 README가 남긴 숙제 그대로입니다 — **Example 앱은 SPM으로 만들 수 없어서**(SPM에 iOS 앱 product 타입이 없음) 모듈을 하나 늘릴 때마다 `.xcodeproj` 를 하나씩 더 손으로 만들어야 했습니다.

J는 다섯 개를 전부 매니페스트로 바꿉니다.

```
Tuist.swift                               플러그인 4개 선언
Workspace.swift                           프로젝트 5개 + 스킴 4개
Configurations/                           Debug.xcconfig · Release.xcconfig

Plugins/                                  ← 서로를 모릅니다
├── EnvironmentPlugin/                    ProjectEnvironment (이름 · 배포 타깃 · 공통 설정)
├── ConfigurationPlugin/                  ConfigurationType (Debug · Release ↔ xcconfig)
├── TargetPlugin/                         Component · Module · 의존성/참조 DSL
└── TemplatePlugin/                       tuist scaffold Module

Tuist/ProjectDescriptionHelpers/          ← 플러그인을 import 해 조합하는 유일한 층
├── Environment.swift                     이 프로젝트의 ProjectEnvironment 값
├── Component+Target.swift                Component + 환경값 → Target
├── Project+Example.swift                 Example 앱 프로젝트 팩토리
└── Scheme+Workspace.swift                워크스페이스 스킴 팩토리

Modules/Project.swift                     36개 타깃 (Package.swift 자리)
Projects/App/Project.swift                앱
Projects/Feature/*/Project.swift          Example 앱 3개
```

`.xcodeproj` 와 `.xcworkspace` 는 이제 **커밋하지 않는 빌드 산출물**입니다. `tuist generate` 가 만듭니다.

## Package.swift 는 거의 그대로 옮겨진다

I의 `Package.swift` 는 이미 `Component`/`Product` enum 으로 36개 타깃을 선언하는 DSL이었습니다. J는 그 DSL을 **`PackageDescription` 에서 `ProjectDescription` 으로 옮기기만** 합니다.

| | I (SPM) | J (Tuist) |
|---|---|---|
| 선언 위치 | `Modules/Package.swift` | `Tuist/ProjectDescriptionHelpers/` |
| 타깃 한 조각 | `PackageDescription.Target` | `ProjectDescription.Target` |
| 의존성 | `.byName(name:)` | `.target(name:)` |
| 산출물 | `.library` product 6개 | `.staticFramework` 타깃 |
| 앱 타깃 | 만들 수 없음 → `.xcodeproj` | `product: .app` |
| 리소스 | `.process("Resources")` | `resources: [...]` |
| `Bundle.module` | SPM 생성 | Tuist 생성 |

`Product` enum 만 `Module` 로 이름을 바꿨습니다 — `ProjectDescription` 에 이미 `Product`(`.app`/`.staticFramework`/`.unitTests`)가 있어서 충돌합니다.

**앱 코드는 한 줄도 안 바뀝니다.** `Modules/` 아래 Swift 파일 140개가 I와 바이트 단위로 같습니다. `Bundle.module` 도 그대로 씁니다 — SPM이 만들어주던 접근자를 Tuist가 똑같이 만들어줍니다.

## 플러그인은 서로를 import 할 수 없다

매니페스트 헬퍼를 `Tuist/ProjectDescriptionHelpers` 한 곳에 두면 금방 뒤엉킵니다. 그래서 역할별로 플러그인 4개로 나눴는데, 여기서 Tuist의 제약 하나가 구조를 결정합니다 — **Tuist는 각 플러그인을 `ProjectDescription` 만 보이는 독립 모듈로 컴파일합니다.** 플러그인끼리는 서로를 import 할 수 없습니다.

그래서 3층이 됩니다.

```
Plugins/            서로를 모름. 각자 ProjectDescription 만 봄
      ↓
Tuist/ProjectDescriptionHelpers/    플러그인을 import 해 조합하는 유일한 층
      ↓
Project.swift · Workspace.swift
```

타깃을 만들려면 이름·경로(`TargetPlugin`)와 배포 타깃·번들 ID(`EnvironmentPlugin`)가 **둘 다** 필요한데, 플러그인 안에서는 반대편을 볼 수 없습니다. 그래서 `Component` 는 이름·경로·의존성까지만 알고, 환경값을 입혀 `Target` 으로 만드는 일은 조합 층의 `Component+Target.swift` 가 합니다.

```swift
// Plugins/TargetPlugin — 환경값을 모름
public var path: String { "Feature/\(module.rawValue)" }

// Tuist/ProjectDescriptionHelpers — 둘 다 import 해서 조합
public func target(_ env: ProjectEnvironment) -> Target { ... }
```

다음 단계로 넘어갈 때 바꿀 값은 `Tuist/ProjectDescriptionHelpers/Environment.swift` 의 `name` 과 `bundleIdPrefix` 두 줄입니다.

## 모듈 뼈대는 찍어낸다

I에서 모듈 하나를 늘리려면 `Interface`·`Sources`·`Testing`·`Tests` 네 폴더를 손으로 만들어야 했습니다. `TemplatePlugin` 이 대신합니다.

```
tuist scaffold Module --name Payment --layer Feature
```

```
Modules/Feature/Payment/Sources/Payment.swift
Modules/Feature/Payment/Interface/Sources/PaymentInterface.swift
Modules/Feature/Payment/Testing/Sources/PaymentTesting.swift
Modules/Feature/Payment/Tests/Sources/PaymentTests.swift
```

의존성 선언만 `Plugins/TargetPlugin/ProjectDescriptionHelpers/Module.swift` 에 손으로 추가하면 됩니다.

## 이번에 걸린 것

**1. 프로젝트 간 스킴은 워크스페이스만 선언할 수 있습니다.**

I의 스킴은 Example 앱(= `Projects/`)과 테스트 타깃(= `Modules/`)을 같이 물고 있었습니다. 이걸 `Projects/Feature/Trip/Project.swift` 의 `schemes:` 에 넣으면 린트에서 막힙니다.

```
The target 'DomainTripTests' specified in scheme 'FeatureTripExample'
is not defined in the project named 'FeatureTrip'.
```

스킴 4개를 전부 `Workspace.swift` 로 올려서 해결했습니다. 프로젝트 매니페스트는 타깃만 선언합니다.

**2. 자동 생성 스킴과 이름이 겹칩니다.**

Tuist는 타깃마다 스킴을 자동으로 만듭니다. 그래서 `App` 스킴이 워크스페이스 것 하나, `App` 프로젝트 것 하나 — 둘이 되어 `xcodebuild -scheme App` 이 모호해집니다. 앱 프로젝트 4개에 `automaticSchemesOptions: .disabled` 를 줘서 껐습니다. `Modules` 프로젝트는 켜 둡니다(모듈 하나만 빌드할 때 씁니다).

**3. `INFOPLIST_FILE` 은 이제 `Config.xcconfig` 가 아니라 매니페스트가 정합니다.**

I는 `Config.xcconfig` 에서 `INFOPLIST_FILE = Info.plist` 를 잡고 그 파일을 커밋했습니다. J는 `infoPlist:` 로 plist 내용을 선언하고 Tuist가 생성합니다. `Projects/App/Info.plist` 는 지웠고, xcconfig 는 `Configurations/{Debug,Release}.xcconfig` 로 올려 `ConfigurationPlugin` 이 관리합니다 — 시크릿 `#include?` 만 남습니다. UIKit 라이프사이클(`SceneDelegate`)을 쓰는 앱 타깃은 `UIApplicationSceneManifest` 를 매니페스트에 명시했습니다.

## 구조

```
ProjectJ.xcworkspace        ← tuist generate 산출물 (커밋 안 함)
Tuist.swift · Workspace.swift
Configurations/             Debug.xcconfig · Release.xcconfig
Plugins/                    Environment · Configuration · Target · Template
Tuist/ProjectDescriptionHelpers/
Modules/                    Project.swift + 36 타깃
Projects/
├── App/                    Project.swift · Sources (4 파일)
└── Feature/
    ├── Trip/               Project.swift · Example/Sources
    ├── Itinerary/          Project.swift · Example/Sources
    └── Reservation/        Project.swift · Example/Sources
```

## 테스트

I와 같습니다. `swift test` 는 애초에 쓸 수 없었고(UIKit 타깃이 macOS 빌드를 깨뜨림), 스킴이 시뮬레이터에서 실행합니다.

| 스킴 | 도는 테스트 | 개수 |
|---|---|---|
| `App` | `CoreTravelGuideTests` | 7 |
| `FeatureTripExample` | `DomainTripTests` · `FeatureTripTests` | 10 |
| `FeatureReservationExample` | `FeatureReservationTests` | 3 |
| `FeatureItineraryExample` | `DomainItineraryTests` · `FeatureItineraryTests` | 52 |
| | | **72** |

```
tuist generate
xcodebuild test -workspace ProjectJ.xcworkspace -scheme FeatureItineraryExample -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
```

## API 키 설정

AeroDataBox(RapidAPI) 키는 F부터 동일하게 주입합니다. 위치도 그대로 `Projects/App/Secrets.local.xcconfig` 입니다 — `Configurations/{Debug,Release}.xcconfig` 가 상대 경로로 `#include?` 합니다.

```
RAPIDAPI_KEY = your_rapidapi_key
```

## 빌드 · 실행

Xcode 16+ / iOS 16.0+ / Swift 5.9+ / Tuist 4.111.1.

```
tuist install
tuist generate
```

`tuist install` 이 로컬 플러그인 4개를 먼저 해석합니다.

`.xcworkspace` 는 커밋되지 않으므로 **clone 직후엔 없습니다.** `tuist generate` 가 만들고 열어줍니다.

`App` 은 전체 앱, `Feature*Example` 은 그 모듈만 링크한 단독 앱입니다.

## Project A-Z

실무에서 다뤄온 기술을 단계별로 정리하는 프로젝트입니다.

| | 추가 스택 |
|---|---|
| A | UIKit + MVVM |
| B | Diffable Data Source |
| C | Combine |
| D | async/await |
| E | Clean Architecture |
| F | XCTest |
| G | SwiftUI |
| H | SPM 모듈화 |
| I | Micro Feature Architecture |
| **J** | **Tuist** |
| K | Core Data |
| L | CloudKit |
| M | APNs |
| N | SwiftData |
| O | Objective-C + libexif |
| P | Swift Testing |
| Q | UI Test |
| R | CI/CD (GitHub Actions) |

각 단계는 별도 레포로 관리합니다.
