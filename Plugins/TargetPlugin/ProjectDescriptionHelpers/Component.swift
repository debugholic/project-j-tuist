import Foundation
import ProjectDescription

/// 타깃 한 조각입니다.
///
/// 이름 · 경로 · 슬롯은 **디스크에서 옵니다**(`.generated/Modules.swift`).
/// 의존성만 손으로 적습니다(`Dependencies.swift`) — 디렉터리 구조로는
/// 무엇이 무엇에 기대는지 알 수 없기 때문입니다.
public struct Component {
  public let root: ModuleRoot
  public let layer: ModuleLayer
  public let module: Module
  public let slot: ModuleSlot

  public init(_ scanned: ScannedTarget) {
    self.root = scanned.root
    self.layer = scanned.layer
    self.module = scanned.module
    self.slot = scanned.slot
  }

  /// `DomainTripInterface`
  public var name: String {
    "\(layer.rawValue)\(module.rawValue)\(slot.suffix)"
  }

  /// `Domain/Trip` — 프로젝트 하나의 단위입니다.
  public var modulePath: String {
    "\(layer.rawValue)/\(module.rawValue)"
  }

  public var sourcePath: String { slot.sourcePath }
  public var isTest: Bool { slot.isTest }
  public var isApp: Bool { slot.isApp }

  public var dependencies: [ModuleDependency] {
    module.dependencies(layer, slot)
  }

  /// 이 조각이 패키지 product 를 쓰는지. 쓰면 프로젝트가 패키지를 참조해야 합니다.
  public var usesPackage: Bool {
    dependencies.contains(where: \.isPackage)
  }

  public var resources: ResourceFileElements? {
    exists(slot.resourceDirectory)
      ? ["\(slot.resourceDirectory)/**"] : nil
  }

  private func exists(_ directory: String) -> Bool {
    FileManager.default.fileExists(
      atPath: "\(Self.repositoryRoot)/\(root.rawValue)/\(modulePath)/\(directory)"
    )
  }

  /// 플러그인은 `<root>/Plugins/TargetPlugin/ProjectDescriptionHelpers` 에서
  /// 컴파일되므로 세 단계 올라가면 리포 루트입니다.
  private static let repositoryRoot: String = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // ProjectDescriptionHelpers
    .deletingLastPathComponent()  // TargetPlugin
    .deletingLastPathComponent()  // Plugins
    .deletingLastPathComponent()  // <root>
    .path
}

// MARK: - Lookup

extension Module {
  /// Tuist 가 만드는 타깃만. `Package/` 쪽은 SwiftPM 이 맡습니다.
  public static var allComponents: [Component] {
    scanned.filter { $0.root == .projects }.map(Component.init)
  }

  /// 워크스페이스에 올릴 모듈 프로젝트 경로입니다. 스캔 순서를 지킵니다.
  public static var modulePaths: [String] {
    var seen: Set<String> = []
    return allComponents.map(\.modulePath).filter { seen.insert($0).inserted }
  }

  public static func components(at modulePath: String) -> [Component] {
    allComponents.filter { $0.modulePath == modulePath }
  }

  /// `Package/` 에 있는지. 의존성을 `.package(product:)` 로 풀지 가릅니다.
  public static func isPackage(_ layer: ModuleLayer, _ module: Module) -> Bool {
    scanned.contains {
      $0.root == .package && $0.layer == layer && $0.module == module
    }
  }
}
