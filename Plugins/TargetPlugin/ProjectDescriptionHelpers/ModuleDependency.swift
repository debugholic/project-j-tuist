import ProjectDescription

/// 의존 대상이 어디서 오는지를 담습니다.
///
/// 두 가지가 섞여 있습니다.
/// - `Package/` 의 SPM product — UIKit 을 안 쓰는 Core · SharedCommon
/// - `Projects/` 의 Tuist 타깃 — 나머지
///
/// Tuist 타깃끼리도 같은 프로젝트면 `.target`, 다른 프로젝트면 `.project` 여야
/// 하는데 그 판단은 *누가 의존하는지* 를 알아야 가능합니다. 그래서 선언 시점에는
/// 정보만 담고, 변환은 `Component.target(_:)` 이 소유자를 알 때 합니다.
public struct ModuleDependency {
  public enum Origin {
    /// `Package/Package.swift` 의 product
    case package
    /// `Projects/<modulePath>/Project.swift` 의 타깃
    case project(String)
  }

  public let targetName: String
  public let origin: Origin

  init(_ targetName: String, _ origin: Origin) {
    self.targetName = targetName
    self.origin = origin
  }
}

// MARK: - Package (Core · SharedCommon)

extension ModuleDependency {
  public static func core(_ component: Component.Core) -> Self {
    .init("Core\(component.rawValue)", .package)
  }

  public static func shared(_ component: Component.Shared) -> Self {
    switch component {
    case .common: .init("SharedCommon", .package)
    case .designSystem: .init("SharedDesignSystem", .project("Shared/DesignSystem"))
    }
  }

  public static func sharedTesting(_ component: Component.Shared) -> Self {
    switch component {
    case .common: .init("SharedCommonTesting", .package)
    case .designSystem: .init("SharedDesignSystemTesting", .project("Shared/DesignSystem"))
    }
  }
}

// MARK: - Domain

extension ModuleDependency {
  public static func domain(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)", .project("Domain/\(module.rawValue)"))
  }

  public static func domainInterface(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Interface", .project("Domain/\(module.rawValue)"))
  }

  public static func domainTesting(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Testing", .project("Domain/\(module.rawValue)"))
  }

  public static func domainTests(_ module: Module) -> Self {
    .init("Domain\(module.rawValue)Tests", .project("Domain/\(module.rawValue)"))
  }
}

// MARK: - Data

extension ModuleDependency {
  public static func data(_ module: Module) -> Self {
    .init("Data\(module.rawValue)", .project("Data/\(module.rawValue)"))
  }

  public static func dataInterface(_ module: Module) -> Self {
    .init("Data\(module.rawValue)Interface", .project("Data/\(module.rawValue)"))
  }
}

// MARK: - Feature

extension ModuleDependency {
  public static func feature(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)", .project("Feature/\(module.rawValue)"))
  }

  public static func featureInterface(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Interface", .project("Feature/\(module.rawValue)"))
  }

  public static func featureTesting(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Testing", .project("Feature/\(module.rawValue)"))
  }

  public static func featureTests(_ module: Module) -> Self {
    .init("Feature\(module.rawValue)Tests", .project("Feature/\(module.rawValue)"))
  }
}

// MARK: - Resolve

extension ModuleDependency {
  public var isPackage: Bool {
    if case .package = origin { return true }
    return false
  }

  public var modulePath: String? {
    if case .project(let path) = origin { return path }
    return nil
  }

  /// `owner` 와 같은 모듈이면 같은 프로젝트이므로 `.target` 입니다.
  public func dependency(from owner: String) -> TargetDependency {
    switch origin {
    case .package:
      .package(product: targetName)
    case .project(let path):
      path == owner
        ? .target(name: targetName)
        : .project(target: targetName, path: .relativeToRoot("Projects/\(path)"))
    }
  }

  /// 스킴에서 쓰는 참조입니다. 패키지 타깃은 스킴에 물릴 수 없습니다.
  public var reference: TargetReference? {
    guard case .project(let path) = origin else { return nil }
    return .project(path: .relativeToRoot("Projects/\(path)"), target: targetName)
  }
}
