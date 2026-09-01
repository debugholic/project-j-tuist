import ProjectDescription

/// 프로젝트 전체가 공유하는 값입니다.
/// 다음 단계로 넘어갈 때 바꿀 것은 `name` 과 `bundleIdPrefix` 뿐입니다.
public struct ProjectEnvironment {
  public let name: String
  public let bundleIdPrefix: String
  public let destinations: Destinations
  public let deploymentTargets: DeploymentTargets
  public let baseSetting: SettingsDictionary

  public init(
    name: String,
    bundleIdPrefix: String,
    destinations: Destinations = [.iPhone, .iPad],
    deploymentTargets: DeploymentTargets = .iOS("16.0"),
    baseSetting: SettingsDictionary = [:]
  ) {
    self.name = name
    self.bundleIdPrefix = bundleIdPrefix
    self.destinations = destinations
    self.deploymentTargets = deploymentTargets
    self.baseSetting = baseSetting
  }

  public func bundleId(_ suffix: String) -> String {
    "\(bundleIdPrefix).\(suffix)"
  }
}
