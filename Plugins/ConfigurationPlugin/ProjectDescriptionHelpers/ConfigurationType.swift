import ProjectDescription

public enum ConfigurationType: CaseIterable {
  case debug
  case release

  public var name: ConfigurationName {
    switch self {
    case .debug: "Debug"
    case .release: "Release"
    }
  }

  public var xcconfig: Path {
    switch self {
    case .debug: .relativeToRoot("Configurations/Debug.xcconfig")
    case .release: .relativeToRoot("Configurations/Release.xcconfig")
    }
  }

  public static func configurations() -> [Configuration] {
    allCases.map {
      switch $0 {
      case .debug: .debug(name: $0.name, xcconfig: $0.xcconfig)
      case .release: .release(name: $0.name, xcconfig: $0.xcconfig)
      }
    }
  }
}
