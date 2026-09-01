import Foundation

// Projects/ 와 Package/ 의 디렉터리 구조를 읽어 모듈 선언을 생성합니다.
// 진실의 원천은 디스크입니다 — 손으로 적는 것은 의존성 그래프뿐입니다.

let root = URL(fileURLWithPath: #filePath)
  .deletingLastPathComponent()  // Sources
  .deletingLastPathComponent()  // SyncModules
  .deletingLastPathComponent()  // Tool
  .deletingLastPathComponent()  // Package
  .deletingLastPathComponent()  // <repo>

let fm = FileManager.default

enum Root: String {
  case package = "Package"
  case projects = "Projects"
}

/// 레이어 순서는 의존 방향을 따릅니다.
let layers = ["Core", "Shared", "Domain", "Data", "Feature"]

/// 디렉터리 이름 → 슬롯. 없으면 그 타깃은 존재하지 않습니다.
let slots: [(directory: String, slot: String)] = [
  ("Sources", "implementation"),
  ("Interface/Sources", "interface"),
  ("Testing/Sources", "testing"),
  ("Tests/Sources", "tests"),
  ("Example/Sources", "example"),
]

struct Scanned {
  let root: Root
  let layer: String
  let module: String
  let slot: String
}

func directories(at url: URL) -> [String] {
  ((try? fm.contentsOfDirectory(atPath: url.path)) ?? [])
    .filter { !$0.hasPrefix(".") }
    .filter { var d: ObjCBool = false
      fm.fileExists(atPath: url.appendingPathComponent($0).path, isDirectory: &d)
      return d.boolValue
    }
    .sorted()
}

var scanned: [Scanned] = []
var modules: Set<String> = []

for r in [Root.package, .projects] {
  for layer in layers {
    let layerURL = root.appendingPathComponent("\(r.rawValue)/\(layer)")
    guard fm.fileExists(atPath: layerURL.path) else { continue }

    for module in directories(at: layerURL) {
      let moduleURL = layerURL.appendingPathComponent(module)
      var found = false

      for (directory, slot) in slots
      where fm.fileExists(atPath: moduleURL.appendingPathComponent(directory).path) {
        scanned.append(Scanned(root: r, layer: layer, module: module, slot: slot))
        found = true
      }

      if found { modules.insert(module) }
    }
  }
}

// MARK: - 출력

func lowerCamel(_ s: String) -> String {
  guard let first = s.first else { return s }
  return String(first).lowercased() + s.dropFirst()
}

let sortedModules = modules.sorted()
let stamp = ISO8601DateFormatter().string(from: Date())

var out = """
// AUTO-GENERATED. DO NOT EDIT.
// Generated at: \(stamp)
// Source of truth: Projects/<Layer>/<Module> · Package/<Layer>/<Module>
// 생성기: Package/Tool/SyncModules — `make sync`

import ProjectDescription

/// 디스크에 있는 모듈 이름입니다. 레이어를 가로질러 같은 이름이 쓰입니다
/// (Itinerary 는 Domain · Data · Feature 셋 다에 있습니다).
public enum Module: String, CaseIterable {

"""
for m in sortedModules {
  out += "  case \(lowerCamel(m)) = \"\(m)\"\n"
}
out += """
}

/// 디스크에서 찾은 타깃 한 조각입니다.
public struct ScannedTarget {
  public let root: ModuleRoot
  public let layer: ModuleLayer
  public let module: Module
  public let slot: ModuleSlot
}

extension Module {
  /// 디렉터리 스캔 결과. 이 목록에 없는 타깃은 만들어지지 않습니다.
  public static let scanned: [ScannedTarget] = [

"""
for s in scanned {
  out += "    .init(root: .\(s.root == .package ? "package" : "projects"), "
  out += "layer: .\(lowerCamel(s.layer)), module: .\(lowerCamel(s.module)), slot: .\(s.slot)),\n"
}
out += """
  ]
}

"""

let destination = root.appendingPathComponent(
  "Plugins/TargetPlugin/ProjectDescriptionHelpers/.generated"
)
try? fm.createDirectory(at: destination, withIntermediateDirectories: true)
try out.write(
  to: destination.appendingPathComponent("Modules.swift"),
  atomically: true,
  encoding: .utf8
)

print("  모듈 \(sortedModules.count)개 · 타깃 \(scanned.count)개 → Plugins/TargetPlugin/ProjectDescriptionHelpers/.generated/Modules.swift")
