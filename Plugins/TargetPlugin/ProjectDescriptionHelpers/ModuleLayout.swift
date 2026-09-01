import ProjectDescription

/// 모듈이 사는 곳. 스캐너가 디렉터리에서 읽습니다.
public enum ModuleRoot: String {
  /// `Package/` — UIKit 을 안 쓰는 모듈. `swift test` 로 검증합니다.
  case package = "Package"
  /// `Projects/` — Tuist 프로젝트.
  case projects = "Projects"
}

/// 레이어. 나열 순서가 의존 방향입니다.
public enum ModuleLayer: String, CaseIterable {
  case core = "Core"
  case shared = "Shared"
  case domain = "Domain"
  case data = "Data"
  case feature = "Feature"
}

/// 모듈 디렉터리 안에서 한 조각이 앉는 자리.
/// 디렉터리가 있으면 그 타깃이 있는 것이고, 없으면 없는 것입니다.
public enum ModuleSlot: String, CaseIterable {
  case implementation
  case interface
  case testing
  case tests
  case example

  /// 타깃 이름 접미사. `DomainTrip` · `DomainTripInterface` …
  public var suffix: String {
    switch self {
    case .implementation: ""
    case .interface: "Interface"
    case .testing: "Testing"
    case .tests: "Tests"
    case .example: "Example"
    }
  }

  /// 모듈 디렉터리 기준 소스 경로.
  public var sourcePath: String {
    switch self {
    case .implementation: "Sources/**"
    default: "\(suffix)/Sources/**"
    }
  }

  public var resourceDirectory: String {
    switch self {
    case .implementation: "Resources"
    default: "\(suffix)/Resources"
    }
  }

  public var isTest: Bool { self == .tests }

  /// Example 만 실행 가능한 앱이고 나머지는 라이브러리입니다.
  public var isApp: Bool { self == .example }
}
