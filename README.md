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
Workspace.swift                           프로젝트 13개 + 스킴 4개
Makefile                                  generate · sync · clean · test · module
mise.toml                                 Tuist 버전 고정
Configurations/                           Debug.xcconfig · Release.xcconfig

Package/Tool/SyncModules                  디렉터리 → 선언 생성기

Plugins/                                  ← 서로를 모릅니다
├── EnvironmentPlugin/                    ProjectEnvironment (이름 · 배포 타깃 · plist 기본값)
├── ConfigurationPlugin/                  ConfigurationType (Debug · Release ↔ xcconfig)
├── TargetPlugin/                         Component · ModuleDependency · Dependencies
│   └── .generated/Modules.swift          ← 생성물, 커밋 안 함
└── TemplatePlugin/                       tuist scaffold Module

Tuist/ProjectDescriptionHelpers/          ← 플러그인을 import 해 조합하는 유일한 층
├── Environment.swift                     이 프로젝트의 ProjectEnvironment 값
├── Component+Target.swift                Component + 환경값 → Target
├── Project+Module.swift                  모듈 프로젝트 팩토리
└── Scheme+Workspace.swift                워크스페이스 스킴 팩토리

Projects/<Layer>/<Module>/Project.swift   모듈마다 한 줄
Projects/App/Project.swift                앱
```

`.xcodeproj` 와 `.xcworkspace` 는 이제 **커밋하지 않는 빌드 산출물**입니다. `tuist generate` 가 만듭니다.

## Package.swift 는 거의 그대로 옮겨진다

I의 `Package.swift` 는 이미 `Component`/`Product` enum 으로 36개 타깃을 선언하는 DSL이었습니다. J는 그 DSL을 **`PackageDescription` 에서 `ProjectDescription` 으로 옮깁니다** — UIKit 을 안 쓰는 넷은 `PackageDescription` 쪽에 그대로 남습니다(아래 참조).

| | I (SPM) | J (Tuist) |
|---|---|---|
| 선언 위치 | `Modules/Package.swift` | `Plugins/TargetPlugin/` |
| 소스 위치 | `Modules/<Layer>/<Module>` | `Projects/<Layer>/<Module>` |
| 프로젝트 | 패키지 1개 + xcodeproj 4개 | 패키지 1개 + 프로젝트 13개 |
| 타깃 한 조각 | `PackageDescription.Target` | `ProjectDescription.Target` |
| 의존성 | `.byName(name:)` | `.target(name:)` |
| 산출물 | `.library` product 6개 | `.staticFramework` 타깃 |
| 앱 타깃 | 만들 수 없음 → `.xcodeproj` | `product: .app` |
| 리소스 | `.process("Resources")` | `resources: [...]` |
| `Bundle.module` | SPM 생성 | Tuist 생성 |

`Product` enum 만 `Module` 로 이름을 바꿨습니다 — `ProjectDescription` 에 이미 `Product`(`.app`/`.staticFramework`/`.unitTests`)가 있어서 충돌합니다.

**앱 코드는 한 줄도 안 바뀝니다.** `Projects/` 와 `Package/` 로 갈라진 Swift 파일 140개가 I의 `Modules/` 와 바이트 단위로 같습니다. `Bundle.module` 도 그대로 씁니다 — SPM이 만들어주던 접근자를 Tuist가 똑같이 만들어줍니다.

## 모듈 하나가 프로젝트 하나다

I는 소스를 `Modules/` 에, Example 앱을 `Projects/` 에 나눠 뒀습니다. 같은 모듈의 조각이 두 군데로 갈라져 있었던 셈입니다.

J는 `Projects/<Layer>/<Module>` 한 곳으로 모으고, **그 디렉터리 하나가 Tuist 프로젝트 하나**가 됩니다.

```
Projects/Feature/Trip/
├── Project.swift          FeatureTripInterface · FeatureTrip · …Testing · …Tests · …Example
├── Interface/Sources
├── Sources
├── Testing/Sources
├── Tests/Sources
└── Example/Sources        ← I 에서 별도 .xcodeproj 였던 것
```

`Project.swift` 는 한 줄입니다. 타깃 구성은 디렉터리 스캔 결과(`.generated/Modules.swift`)에서 나옵니다.

```swift
let project = Project.module("Domain/Trip")
```

**프로젝트가 갈라지면 의존성 표현이 달라집니다.** 같은 프로젝트 안이면 `.target(name:)`, 다른 프로젝트면 `.project(target:path:)` 여야 하는데, 어느 쪽인지는 *누가 의존하는지* 를 알아야 정해집니다. `DomainTrip → DomainTripInterface` 는 같은 프로젝트지만 `DataTrip → DomainTripInterface` 는 아닙니다.

그래서 의존성을 `TargetDependency` 로 바로 쓰지 않고 `ModuleDependency` 라는 값으로 들고 있다가, 타깃을 만드는 시점에 소유자와 비교해 풉니다.

```swift
// 선언 — 어느 쪽인지 아직 모름
.domainInterface(.trip)

// 타깃 생성 시점에 결정
owner == modulePath ? .target(name:) : .project(target:path:)
```

## UIKit 이 없는 모듈은 패키지에 남긴다

전부 Tuist로 옮길 이유는 없습니다. **UIKit 을 안 쓰는 모듈은 SPM 패키지에 두는 편이 낫습니다** — 시뮬레이터 없이 `swift test` 로 돌기 때문입니다.

I의 README는 이렇게 적어뒀습니다: "`swift test` 는 쓸 수 없습니다. 패키지에 UIKit 타깃이 있어서 macOS 빌드가 거기서 깨집니다." 그 UIKit 타깃이 `SharedDesignSystem`(`UIControl+Publisher`) 하나였습니다. 얘만 빼면 나머지는 macOS 에서 그대로 빌드됩니다.

| 모듈 | import | 자리 |
|---|---|---|
| `Core/Network` | Foundation | `Package/` |
| `Core/Storage` | Foundation · Combine | `Package/` |
| `Core/TravelGuide` | Foundation (+리소스) | `Package/` |
| `Shared/Common` | Foundation | `Package/` |
| `Shared/DesignSystem` | **UIKit** · ObjectiveC | `Projects/` |

이 넷은 `Dependencies.swift` 상 **바깥으로 나가는 의존성이 하나도 없습니다.** SPM 패키지는 Tuist 타깃을 볼 수 없지만 반대는 되므로, 닫힌 집합이라 그대로 떼어낼 수 있습니다.

```
Package/Package.swift    Core 3 + SharedCommon(+Testing) + CoreTravelGuideTests
Projects/                Domain 4 · Data 4 · Feature 3 · SharedDesignSystem · App
```

그 결과 `CoreTravelGuideTests` 7개가 시뮬레이터 없이 돕니다.

```
cd Package && swift test
Executed 7 tests, with 0 failures
```

**의존성 표현이 세 갈래가 됩니다.** 같은 프로젝트면 `.target`, 다른 프로젝트면 `.project`, 패키지면 `.package(product:)`. `ModuleDependency` 가 `Origin`(`.package` / `.project(경로)`)을 들고 있다가 타깃 생성 시점에 소유자와 비교해 셋 중 하나로 풉니다.

`Shared` 는 둘로 갈립니다 — `.shared(.common)` 은 패키지, `.shared(.designSystem)` 은 프로젝트입니다. 선언부 문법은 그대로입니다.

이 경계는 쉽게 무너집니다. 패키지 모듈에 `import UIKit` 이 하나 들어오면 `swift test` 가 macOS 에서 깨지는데, 그건 CI 에서야 드러납니다. `make sync` 가 그것도 봅니다.

```
✗ Package/ 에 UIKit import 가 있습니다 — swift test 가 깨집니다
    Package/Core/Storage/Sources/Oops.swift
```

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

## 선언은 디렉터리에서 생성한다

모듈을 하나 늘릴 때 손으로 고칠 곳이 많으면 어딘가는 빠집니다. **어떤 모듈이 있고 어떤 타깃이 있는지는 디스크에 이미 적혀 있으니, 읽어서 생성합니다.**

```
Package/Tool/SyncModules          디렉터리 스캐너 (swift run)
        ↓
Plugins/TargetPlugin/ProjectDescriptionHelpers/.generated/Modules.swift
        Module 열거형 · ScannedTarget 목록      ← AUTO-GENERATED, 커밋 안 함
```

`Interface/Sources` 가 있으면 Interface 타깃이 생기고, `Example/Sources` 가 있으면 Example 앱이 생깁니다. 디렉터리가 없으면 그 타깃도 없습니다 — `Domain/Reservation` 에 구현 타깃이 없는 것도 그래서입니다.

**생성되지 않는 것은 의존성 그래프 하나뿐입니다.** 무엇이 무엇에 기대는지는 디렉터리에 적혀 있지 않습니다. `Dependencies.swift` 에 손으로 남습니다.

```
make module NAME=Payment LAYER=Feature   # 디렉터리 + Project.swift
make sync                                # 스캔 → 타깃 4개 생성
  모듈 10개 · 타깃 43개 — 디스크에서 생성했습니다.
  ! Feature/Payment — 의존성이 비어 있습니다
```

선언은 한 줄도 손대지 않았는데 `FeaturePayment` · `…Interface` · `…Testing` · `…Tests` 가 생깁니다. 남은 일은 의존성을 채우는 것뿐이고, 그것도 비어 있으면 `sync` 가 알려줍니다.

`sync` 는 생성 뒤에 세 가지를 더 봅니다 — 모듈 디렉터리에 `Project.swift` 가 있는지, 의존성이 비어 있지 않은지, 그리고 `Package/` 에 `import UIKit` 이 섞이지 않았는지(섞이면 `swift test` 가 macOS 에서 깨집니다).

## 모듈 뼈대는 찍어낸다

I에서 모듈 하나를 늘리려면 `Interface`·`Sources`·`Testing`·`Tests` 네 폴더를 손으로 만들어야 했습니다. `TemplatePlugin` 이 `Project.swift` 까지 같이 찍어냅니다.

```
make module NAME=Payment LAYER=Feature
```

템플릿 이름은 디렉터리명을 따라 대문자 `Module` 입니다 — `tuist scaffold Module --name …` 을 그대로 부릅니다.

```
Projects/Feature/Payment/Project.swift
Projects/Feature/Payment/Sources/Payment.swift
Projects/Feature/Payment/Interface/Sources/PaymentInterface.swift
Projects/Feature/Payment/Testing/Sources/PaymentTesting.swift
Projects/Feature/Payment/Tests/Sources/PaymentTests.swift
```

타깃은 `make sync` 가 스캔해서 잡습니다. 남는 일은 `Dependencies.swift` 에 의존성을 채우는 것뿐입니다.

## 이번에 걸린 것

**1. 프로젝트 간 스킴은 워크스페이스만 선언할 수 있습니다.**

`App` 스킴은 앱 타깃(`Projects/App`)과 테스트 타깃(`Projects/Core/TravelGuide`)을 같이 뭅니다. 이걸 프로젝트 매니페스트의 `schemes:` 에 넣으면 린트에서 막힙니다.

```
The target 'CoreTravelGuideTests' specified in scheme 'App'
is not defined in the project named 'App'.
```

스킴 4개를 전부 `Workspace.swift` 로 올려서 해결했습니다. 프로젝트 매니페스트는 타깃만 선언합니다. (Example 스킴은 모듈을 합치면서 같은 프로젝트가 됐지만, 일관성을 위해 넷 다 워크스페이스에 둡니다.)

**2. 자동 생성 스킴과 이름이 겹칩니다.**

Tuist는 타깃마다 스킴을 자동으로 만듭니다. 그래서 `App` 스킴이 워크스페이스 것 하나, `App` 프로젝트 것 하나 — 둘이 되어 `xcodebuild -scheme App` 이 모호해집니다. 프로젝트 13개 전부에 `automaticSchemesOptions: .disabled` 를 줘서 껐습니다. 워크스페이스에도 같은 뜻으로 `autogeneratedWorkspaceSchemes: .disabled` 를 뒀지만, Tuist 4.166.0 에서는 이 옵션이 `ProjectJ-Workspace` 와 `Generate Project` 를 없애지 못합니다(`.enabled()` 로 뒤집어도 결과가 같습니다). 선언한 4개와 이름이 겹치지 않아 `xcodebuild -scheme` 의 모호함은 사라졌습니다.

**3. `INFOPLIST_FILE` 은 이제 `Config.xcconfig` 가 아니라 매니페스트가 정합니다.**

I는 `Config.xcconfig` 에서 `INFOPLIST_FILE = Info.plist` 를 잡고 그 파일을 커밋했습니다. J는 `infoPlist:` 로 plist 내용을 선언하고 Tuist가 생성합니다. `Projects/App/Info.plist` 는 지웠고, xcconfig 는 `Configurations/{Debug,Release}.xcconfig` 로 올려 `ConfigurationPlugin` 이 관리합니다 — 시크릿 `#include?` 만 남습니다. UIKit 라이프사이클(`SceneDelegate`)을 쓰는 앱 타깃은 `UIApplicationSceneManifest` 를 매니페스트에 명시했습니다.

## 구조

```
ProjectJ.xcworkspace        ← make generate 산출물 (커밋 안 함)
Makefile                    진입점
Configurations/             Debug.xcconfig · Release.xcconfig
Scripts/sync.sh             생성 후 남은 어긋남 검사
Plugins/                    Environment · Configuration · Target · Template
Tuist/ProjectDescriptionHelpers/
Package/                    UIKit 없는 모듈 — swift test 로 검증
├── Core/                   Network · Storage · TravelGuide
└── Shared/Common
Projects/                   Tuist 프로젝트 13개
├── App/                    Sources (4 파일)
├── Shared/DesignSystem     UIKit
├── Domain/                 Trip · Itinerary · Reservation · Recommendation
├── Data/                   Trip · Itinerary · Reservation · Recommendation
└── Feature/                Trip · Itinerary · Reservation
```

## 테스트

I는 `swift test` 를 쓸 수 없었습니다. J는 UIKit 이 없는 모듈을 패키지로 갈라내 절반을 되찾았습니다.

| 도는 곳 | 테스트 | 개수 | 시뮬레이터 |
|---|---|---|---|
| `swift test` | `CoreTravelGuideTests` | 7 | 불필요 |
| `FeatureTripExample` | `DomainTripTests` · `FeatureTripTests` | 10 | 필요 |
| `FeatureReservationExample` | `FeatureReservationTests` | 3 | 필요 |
| `FeatureItineraryExample` | `DomainItineraryTests` · `FeatureItineraryTests` | 52 | 필요 |
| | | **72** | |

```
make test           # 패키지 + 스킴 전부
make test-package   # swift test 만
make test-app       # 스킴만
```

`App` 스킴은 이제 테스트를 물지 않습니다 — 물고 있던 `CoreTravelGuideTests` 가 패키지로 갔고, Tuist 스킴은 SPM 테스트 타깃을 참조할 수 없습니다.

## API 키 설정

AeroDataBox(RapidAPI) 키는 F부터 동일하게 주입합니다. 위치도 그대로 `Projects/App/Secrets.local.xcconfig` 입니다 — `Configurations/{Debug,Release}.xcconfig` 가 상대 경로로 `#include?` 합니다.

```
RAPIDAPI_KEY = your_rapidapi_key
```

## 빌드 · 실행

Xcode 16+ / iOS 16.0+ / Swift 5.9+ / Tuist 4.166.0 (`mise.toml` 에 고정).

```
make generate
```

`.xcworkspace` 는 커밋되지 않으므로 **clone 직후엔 없습니다.** `make generate` 가
`tuist install`(로컬 플러그인 4개 해석) → `tuist generate` 를 순서대로 돌립니다.
플러그인을 먼저 해석하지 않으면 매니페스트가 컴파일되지 않습니다.

| | |
|---|---|
| `make generate` | 플러그인 해석 → `sync` → 프로젝트 생성 |
| `make sync` | 디렉터리에서 모듈·타깃 선언을 생성하고 검사 |
| `make open` | 생성 후 Xcode 로 열기 |
| `make clean` | 생성물(`.xcodeproj` · `.xcworkspace` · `Derived`)만 삭제 |
| `make test` | 패키지(`swift test`) + 앱 스킴 테스트 |
| `make module NAME=Payment LAYER=Feature` | 모듈 뼈대 생성 |


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
