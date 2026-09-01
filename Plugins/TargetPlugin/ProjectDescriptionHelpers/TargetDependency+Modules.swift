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

// MARK: - Cross-project

extension TargetDependency {
  /// 앱 프로젝트에서 `Modules` 프로젝트의 타깃을 가리킵니다.
  public static func modules(_ name: String) -> Self {
    .project(target: name, path: .relativeToRoot("Modules"))
  }
}
