import ProjectDescription

/// 의존 대상을 "타깃 이름 + 그 타깃이 사는 모듈 경로" 로 들고 있습니다.
///
/// 모듈 하나가 프로젝트 하나이므로, 같은 프로젝트 안이면 `.target`,
/// 다른 프로젝트면 `.project` 로 풀어야 합니다. 그 판단은 의존성을 선언하는
/// 시점이 아니라 타깃을 만드는 시점에만 할 수 있어서 — 누가 의존하는지 알아야
/// 하므로 — 여기서는 정보만 담고 변환은 `Component.target(_:)` 이 합니다.
public struct ModuleDependency {
  public let targetName: String
  public let modulePath: String

  init(_ targetName: String, _ modulePath: String) {
    self.targetName = targetName
    self.modulePath = modulePath
  }
}

// MARK: - Core · Shared

extension ModuleDependency {
  public static func core(_ component: Component.Core) -> Self {
    .init("Core\(component.rawValue)", "Core/\(component.rawValue)")
  }

  public static func coreTests(_ component: Component.Core) -> Self {
    .init("Core\(component.rawValue)Tests", "Core/\(component.rawValue)")
  }

  public static func shared(_ component: Component.Shared) -> Self {
    .init("Shared\(component.rawValue)", "Shared/\(component.rawValue)")
  }

  public static func sharedTesting(_ component: Component.Shared) -> Self {
    .init("Shared\(component.rawValue)Testing", "Shared/\(component.rawValue)")
  }
}

// MARK: - Domain

extension ModuleDependency {
  public static func domain(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)", "Domain/\(module.rawValue)")
  }

  public static func domainInterface(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Interface", "Domain/\(module.rawValue)")
  }

  public static func domainTesting(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Testing", "Domain/\(module.rawValue)")
  }

  public static func domainTests(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Tests", "Domain/\(module.rawValue)")
  }
}

// MARK: - Data

extension ModuleDependency {
  public static func data(_ module: Module) -> Self {
    .init("Data\(module.rawValue)", "Data/\(module.rawValue)")
  }

  public static func dataInterface(_ module: Module) -> Self {
    .init("Data\(module.rawValue)Interface", "Data/\(module.rawValue)")
  }
}

// MARK: - Feature

extension ModuleDependency {
  public static func feature(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)", "Feature/\(module.rawValue)")
  }

  public static func featureInterface(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Interface", "Feature/\(module.rawValue)")
  }

  public static func featureTesting(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Testing", "Feature/\(module.rawValue)")
  }

  public static func featureTests(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Tests", "Feature/\(module.rawValue)")
  }

  public static func featureExample(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Example", "Feature/\(module.rawValue)")
  }
}

// MARK: - Resolve

extension ModuleDependency {
  public var path: Path { .relativeToRoot("Projects/\(modulePath)") }

  /// `owner` 와 같은 모듈이면 같은 프로젝트이므로 `.target` 입니다.
  public func dependency(from owner: String) -> TargetDependency {
    owner == modulePath
      ? .target(name: targetName)
      : .project(target: targetName, path: path)
  }

  public var reference: TargetReference {
    .project(path: path, target: targetName)
  }
}
