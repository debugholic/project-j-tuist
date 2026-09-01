import ProjectDescription

/// 프로젝트 전체가 공유하는 값입니다.
/// 다음 단계로 넘어갈 때 바꿀 것은 `name` 과 `bundleIdPrefix` 뿐입니다.
public struct ProjectEnvironment {
  public let name: String
  public let bundleIdPrefix: String
  public let destinations: Destinations
  public let deploymentTargets: DeploymentTargets
  public let baseSetting: SettingsDictionary

  /// 앱 타깃(`.app`) plist 의 기본값입니다.
  ///
  /// `UILaunchScreen` 이 없으면 iOS 가 앱을 레거시 크기(320×480 계열)로 띄우고
  /// 확대해 보여줍니다 — 화면이 작게 나오고 레터박스가 생깁니다.
  /// `.extendingDefault` 의 기본값에는 방향과 `UIApplicationSceneManifest` 는
  /// 있지만 런치 스크린은 없어서, 여기서 채워 넣습니다.
  public let basePlist: [String: Plist.Value]

  public init(
    name: String,
    bundleIdPrefix: String,
    destinations: Destinations = [.iPhone, .iPad],
    deploymentTargets: DeploymentTargets = .iOS("16.0"),
    baseSetting: SettingsDictionary = [:],
    basePlist: [String: Plist.Value] = [
      "UILaunchScreen": .dictionary([:]),
      "UIApplicationSupportsIndirectInputEvents": true,
    ]
  ) {
    self.name = name
    self.bundleIdPrefix = bundleIdPrefix
    self.destinations = destinations
    self.deploymentTargets = deploymentTargets
    self.baseSetting = baseSetting
    self.basePlist = basePlist
  }

  public func bundleId(_ suffix: String) -> String {
    "\(bundleIdPrefix).\(suffix)"
  }

  /// 앱 타깃 plist. 기본값 위에 타깃별 값만 얹습니다.
  public func infoPlist(_ extra: [String: Plist.Value] = [:]) -> InfoPlist {
    var values = basePlist
    for (key, value) in extra { values[key] = value }
    return .extendingDefault(with: values)
  }
}
