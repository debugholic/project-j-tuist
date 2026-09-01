import Foundation
import ProjectDescription

// MARK: - Component

public enum Component {
  public enum Core: String, CaseIterable {
    case network = "Network"
    case storage = "Storage"
    case travelGuide = "TravelGuide"
  }

  public enum Shared: String, CaseIterable {
    case common = "Common"
    case designSystem = "DesignSystem"
  }

  /// Core 와 SharedCommon 은 `Package/` 로 갔습니다. 여기 남는 Shared 는
  /// UIKit 을 쓰는 DesignSystem 뿐입니다.
  case shared(_ component: Shared, dependencies: [ModuleDependency] = [])

  case domainInterface(_ module: Module, dependencies: [ModuleDependency] = [])
  case domain(_ module: Module, dependencies: [ModuleDependency] = [])
  case domainTesting(_ module: Module, dependencies: [ModuleDependency] = [])
  case domainTests(_ module: Module, dependencies: [ModuleDependency] = [])

  case dataInterface(_ module: Module, dependencies: [ModuleDependency] = [])
  case data(_ module: Module, dependencies: [ModuleDependency] = [])
  case dataTests(_ module: Module, dependencies: [ModuleDependency] = [])

  case featureInterface(_ module: Module, dependencies: [ModuleDependency] = [])
  case feature(_ module: Module, dependencies: [ModuleDependency] = [])
  case featureTesting(_ module: Module, dependencies: [ModuleDependency] = [])
  case featureTests(_ module: Module, dependencies: [ModuleDependency] = [])

  public var name: String {
    switch self {
    case .shared(let component, _): "Shared\(component.rawValue)"
    case .domainInterface(let module, _): "Domain\(module.rawValue)Interface"
    case .domain(let module, _): "Domain\(module.rawValue)"
    case .domainTesting(let module, _): "Domain\(module.rawValue)Testing"
    case .domainTests(let module, _): "Domain\(module.rawValue)Tests"
    case .dataInterface(let module, _): "Data\(module.rawValue)Interface"
    case .data(let module, _): "Data\(module.rawValue)"
    case .dataTests(let module, _): "Data\(module.rawValue)Tests"
    case .featureInterface(let module, _): "Feature\(module.rawValue)Interface"
    case .feature(let module, _): "Feature\(module.rawValue)"
    case .featureTesting(let module, _): "Feature\(module.rawValue)Testing"
    case .featureTests(let module, _): "Feature\(module.rawValue)Tests"
    }
  }

  /// 모듈 디렉터리. 프로젝트 하나의 단위입니다. 예: `Domain/Trip`
  public var modulePath: String {
    switch self {
    case .shared(let c, _): "Shared/\(c.rawValue)"
    case .domainInterface(let m, _), .domain(let m, _),
      .domainTesting(let m, _), .domainTests(let m, _):
      "Domain/\(m.rawValue)"
    case .dataInterface(let m, _), .data(let m, _), .dataTests(let m, _):
      "Data/\(m.rawValue)"
    case .featureInterface(let m, _), .feature(let m, _),
      .featureTesting(let m, _), .featureTests(let m, _):
      "Feature/\(m.rawValue)"
    }
  }

  /// 모듈 디렉터리 안에서 이 조각이 앉는 자리.
  public var slot: String {
    switch self {
    case .shared, .domain, .data, .feature: ""
    case .domainInterface, .dataInterface, .featureInterface: "Interface"
    case .domainTesting, .featureTesting: "Testing"
    case .domainTests, .dataTests, .featureTests: "Tests"
    }
  }

  /// 프로젝트 디렉터리 기준 소스 경로.
  public var sourcePath: String {
    slot.isEmpty ? "Sources/**" : "\(slot)/Sources/**"
  }

  public var resourcePath: String {
    slot.isEmpty ? "Resources/**" : "\(slot)/Resources/**"
  }

  public var dependencies: [ModuleDependency] {
    switch self {
    case .shared(_, let dependencies),
      .domainInterface(_, let dependencies),
      .domain(_, let dependencies),
      .domainTesting(_, let dependencies),
      .domainTests(_, let dependencies),
      .dataInterface(_, let dependencies),
      .data(_, let dependencies),
      .dataTests(_, let dependencies),
      .featureInterface(_, let dependencies),
      .feature(_, let dependencies),
      .featureTesting(_, let dependencies),
      .featureTests(_, let dependencies):
      dependencies
    }
  }

  public var isTest: Bool {
    switch self {
    case .domainTests, .dataTests, .featureTests: true
    default: false
    }
  }

  public var resources: ResourceFileElements? {
    exists(slot.isEmpty ? "Resources" : "\(slot)/Resources")
      ? ["\(resourcePath)"] : nil
  }

  private func exists(_ directory: String) -> Bool {
    FileManager.default.fileExists(
      atPath: Self.projectsRoot.appending("/\(modulePath)/\(directory)")
    )
  }

  /// 플러그인은 `<root>/Plugins/TargetPlugin/ProjectDescriptionHelpers` 에서
  /// 컴파일되므로 세 단계 올라가면 리포 루트입니다.
  private static let projectsRoot: String = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // ProjectDescriptionHelpers
    .deletingLastPathComponent()  // TargetPlugin
    .deletingLastPathComponent()  // Plugins
    .deletingLastPathComponent()  // <root>
    .appendingPathComponent("Projects")
    .path
}
