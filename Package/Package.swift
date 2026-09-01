// swift-tools-version: 5.9
import Foundation
import PackageDescription

// UIKit 을 안 쓰는 모듈만 여기 남습니다.
// 덕분에 이 패키지는 시뮬레이터 없이 `swift test` 로 돕니다 —
// I 단계에서 SharedDesignSystem(UIKit) 때문에 막혀 있던 것입니다.
// UIKit 을 쓰는 모듈은 Projects/ 의 Tuist 프로젝트가 맡습니다.

enum Component: CaseIterable {
  case coreNetwork
  case coreStorage
  case coreTravelGuide
  case coreTravelGuideTests
  case sharedCommon
  case sharedCommonTesting

  var name: String {
    switch self {
    case .coreNetwork: "CoreNetwork"
    case .coreStorage: "CoreStorage"
    case .coreTravelGuide: "CoreTravelGuide"
    case .coreTravelGuideTests: "CoreTravelGuideTests"
    case .sharedCommon: "SharedCommon"
    case .sharedCommonTesting: "SharedCommonTesting"
    }
  }

  var path: String {
    switch self {
    case .coreNetwork: "Core/Network"
    case .coreStorage: "Core/Storage"
    case .coreTravelGuide: "Core/TravelGuide"
    case .coreTravelGuideTests: "Core/TravelGuide/Tests"
    case .sharedCommon: "Shared/Common"
    case .sharedCommonTesting: "Shared/Common/Testing"
    }
  }

  var dependencies: [Target.Dependency] {
    switch self {
    case .coreTravelGuideTests: [.byName(name: Component.coreTravelGuide.name)]
    case .sharedCommonTesting: [.byName(name: Component.sharedCommon.name)]
    default: []
    }
  }

  var isTest: Bool {
    switch self {
    case .coreTravelGuideTests: true
    default: false
    }
  }

  /// 이 모듈이 product 로 나가는지. 테스트 타깃은 안 나갑니다.
  var isProduct: Bool { !isTest }

  var resources: [Resource] {
    let full = URL(fileURLWithPath: #filePath)
      .deletingLastPathComponent()
      .appendingPathComponent("\(path)/Resources").path
    return FileManager.default.fileExists(atPath: full) ? [.process("Resources")] : []
  }

  /// 구현 디렉터리 안에 있는 하위 타깃 폴더는 소스에서 뺍니다.
  var excludes: [String] {
    switch self {
    case .coreTravelGuide: ["Tests"]
    case .sharedCommon: ["Testing"]
    default: []
    }
  }

  var target: Target {
    isTest
      ? .testTarget(
        name: name,
        dependencies: dependencies,
        path: path,
        sources: ["Sources"],
        resources: resources
      )
      : .target(
        name: name,
        dependencies: dependencies,
        path: path,
        exclude: excludes,
        sources: ["Sources"],
        resources: resources
      )
  }
}

let package = Package(
  name: "ProjectJPackage",
  platforms: [.iOS(.v16), .macOS(.v13)],
  products: Component.allCases
    .filter(\.isProduct)
    .map { .library(name: $0.name, targets: [$0.name]) },
  targets: Component.allCases.map(\.target)
)
