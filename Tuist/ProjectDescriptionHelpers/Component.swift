import Foundation
import ProjectDescription

// MARK: - Dependency

extension TargetDependency {
  public static func core(_ component: Component.Core) -> Self {
    .target(name: "Core\(component.rawValue)")
  }

  public static func shared(_ component: Component.Shared) -> Self {
    .target(name: "Shared\(component.rawValue)")
  }

  public static func sharedTesting(_ component: Component.Shared) -> Self {
    .target(name: "Shared\(component.rawValue)Testing")
  }

  public static func domain(_ module: Module) -> Self {
    .target(name: "Domain\(module.rawValue)")
  }

  public static func domainInterface(_ module: Module) -> Self {
    .target(name: "Domain\(module.rawValue)Interface")
  }

  public static func domainTesting(_ module: Module) -> Self {
    .target(name: "Domain\(module.rawValue)Testing")
  }

  public static func data(_ module: Module) -> Self {
    .target(name: "Data\(module.rawValue)")
  }

  public static func dataInterface(_ module: Module) -> Self {
    .target(name: "Data\(module.rawValue)Interface")
  }

  public static func feature(_ module: Module) -> Self {
    .target(name: "Feature\(module.rawValue)")
  }

  public static func featureInterface(_ module: Module) -> Self {
    .target(name: "Feature\(module.rawValue)Interface")
  }

  public static func featureTesting(_ module: Module) -> Self {
    .target(name: "Feature\(module.rawValue)Testing")
  }
}

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

  case core(_ component: Core, dependencies: [TargetDependency] = [])
  case coreTests(_ component: Core, dependencies: [TargetDependency] = [])
  case shared(_ component: Shared, dependencies: [TargetDependency] = [])
  case sharedTesting(_ component: Shared, dependencies: [TargetDependency] = [])

  case domainInterface(_ module: Module, dependencies: [TargetDependency] = [])
  case domain(_ module: Module, dependencies: [TargetDependency] = [])
  case domainTesting(_ module: Module, dependencies: [TargetDependency] = [])
  case domainTests(_ module: Module, dependencies: [TargetDependency] = [])

  case dataInterface(_ module: Module, dependencies: [TargetDependency] = [])
  case data(_ module: Module, dependencies: [TargetDependency] = [])
  case dataTests(_ module: Module, dependencies: [TargetDependency] = [])

  case featureInterface(_ module: Module, dependencies: [TargetDependency] = [])
  case feature(_ module: Module, dependencies: [TargetDependency] = [])
  case featureTesting(_ module: Module, dependencies: [TargetDependency] = [])
  case featureTests(_ module: Module, dependencies: [TargetDependency] = [])

  public var name: String {
    switch self {
    case .core(let component, _): "Core\(component.rawValue)"
    case .coreTests(let component, _): "Core\(component.rawValue)Tests"
    case .shared(let component, _): "Shared\(component.rawValue)"
    case .sharedTesting(let component, _): "Shared\(component.rawValue)Testing"
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

  public var path: String {
    switch self {
    case .core(let component, _): "Core/\(component.rawValue)"
    case .coreTests(let component, _): "Core/\(component.rawValue)/Tests"
    case .shared(let component, _): "Shared/\(component.rawValue)"
    case .sharedTesting(let component, _): "Shared/\(component.rawValue)/Testing"
    case .domainInterface(let module, _): "Domain/\(module.rawValue)/Interface"
    case .domain(let module, _): "Domain/\(module.rawValue)"
    case .domainTesting(let module, _): "Domain/\(module.rawValue)/Testing"
    case .domainTests(let module, _): "Domain/\(module.rawValue)/Tests"
    case .dataInterface(let module, _): "Data/\(module.rawValue)/Interface"
    case .data(let module, _): "Data/\(module.rawValue)"
    case .dataTests(let module, _): "Data/\(module.rawValue)/Tests"
    case .featureInterface(let module, _): "Feature/\(module.rawValue)/Interface"
    case .feature(let module, _): "Feature/\(module.rawValue)"
    case .featureTesting(let module, _): "Feature/\(module.rawValue)/Testing"
    case .featureTests(let module, _): "Feature/\(module.rawValue)/Tests"
    }
  }

  public var dependencies: [TargetDependency] {
    switch self {
    case .core(_, let dependencies),
      .coreTests(_, let dependencies),
      .shared(_, let dependencies),
      .sharedTesting(_, let dependencies),
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
    case .coreTests, .domainTests, .dataTests, .featureTests: true
    default: false
    }
  }

  var resources: ResourceFileElements? {
    exists("Resources") ? ["\(path)/Resources/**"] : nil
  }

  private func exists(_ directory: String) -> Bool {
    FileManager.default.fileExists(
      atPath: Path.modulesRoot.appending("/\(path)/\(directory)")
    )
  }

  // MARK: - Target

  public var target: Target {
    .target(
      name: name,
      destinations: .iOS,
      product: isTest ? .unitTests : .staticFramework,
      bundleId: "\(Constant.bundleIdPrefix).\(name)",
      deploymentTargets: Constant.deploymentTargets,
      infoPlist: .default,
      sources: ["\(path)/Sources/**"],
      resources: resources,
      dependencies: dependencies,
      settings: .settings(base: Constant.moduleSettings)
    )
  }
}
