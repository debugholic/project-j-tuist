import ProjectDescription

/// 의존 대상이 어디서 오는지를 담습니다.
///
/// 세 갈래로 풀립니다 — 같은 프로젝트면 `.target`, 다른 프로젝트면 `.project`,
/// `Package/` 면 `.package(product:)`. 어느 쪽인지는 *누가 의존하는지* 를
/// 알아야 정해지므로, 선언 시점에는 정보만 담고 변환은 타깃을 만들 때 합니다.
public struct ModuleDependency {
  public let layer: ModuleLayer
  public let module: Module
  public let slot: ModuleSlot

  init(_ layer: ModuleLayer, _ module: Module, _ slot: ModuleSlot) {
    self.layer = layer
    self.module = module
    self.slot = slot
  }

  public var targetName: String {
    "\(layer.rawValue)\(module.rawValue)\(slot.suffix)"
  }

  public var modulePath: String {
    "\(layer.rawValue)/\(module.rawValue)"
  }

  public var isPackage: Bool {
    Module.isPackage(layer, module)
  }
}

// MARK: - Core · Shared

extension ModuleDependency {
  public static func core(_ module: Module) -> Self { .init(.core, module, .implementation) }
  public static func coreTests(_ module: Module) -> Self { .init(.core, module, .tests) }
  public static func shared(_ module: Module) -> Self { .init(.shared, module, .implementation) }
  public static func sharedTesting(_ module: Module) -> Self { .init(.shared, module, .testing) }
}

// MARK: - Domain

extension ModuleDependency {
  public static func domain(_ module: Module) -> Self { .init(.domain, module, .implementation) }
  public static func domainInterface(_ module: Module) -> Self { .init(.domain, module, .interface) }
  public static func domainTesting(_ module: Module) -> Self { .init(.domain, module, .testing) }
  public static func domainTests(_ module: Module) -> Self { .init(.domain, module, .tests) }
}

// MARK: - Data

extension ModuleDependency {
  public static func data(_ module: Module) -> Self { .init(.data, module, .implementation) }
  public static func dataInterface(_ module: Module) -> Self { .init(.data, module, .interface) }
}

// MARK: - Feature

extension ModuleDependency {
  public static func feature(_ module: Module) -> Self { .init(.feature, module, .implementation) }
  public static func featureInterface(_ module: Module) -> Self { .init(.feature, module, .interface) }
  public static func featureTesting(_ module: Module) -> Self { .init(.feature, module, .testing) }
  public static func featureTests(_ module: Module) -> Self { .init(.feature, module, .tests) }
}

// MARK: - Resolve

extension ModuleDependency {
  /// `owner` 와 같은 모듈이면 같은 프로젝트이므로 `.target` 입니다.
  public func dependency(from owner: String) -> TargetDependency {
    if isPackage { return .package(product: targetName) }
    return modulePath == owner
      ? .target(name: targetName)
      : .project(target: targetName, path: .relativeToRoot("Projects/\(modulePath)"))
  }

  /// 스킴에서 쓰는 참조입니다. 패키지 타깃은 스킴에 물릴 수 없습니다.
  public var reference: TargetReference? {
    guard !isPackage else { return nil }
    return .project(path: .relativeToRoot("Projects/\(modulePath)"), target: targetName)
  }
}

// MARK: - Package

extension Package {
  /// `Package/Package.swift` — UIKit 을 안 쓰는 모듈들이 사는 로컬 SPM 패키지입니다.
  public static var local: Package { .local(path: .relativeToRoot("Package")) }
}
