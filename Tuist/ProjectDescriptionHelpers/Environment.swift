import EnvironmentPlugin
import ProjectDescription

/// 플러그인끼리는 서로 import 할 수 없습니다.
/// 플러그인을 조합해 이 프로젝트의 값으로 굳히는 곳이 여기입니다.
public let projectJ = ProjectEnvironment(
  name: "ProjectJ",
  bundleIdPrefix: "com.debugholic.ProjectJ",
  deploymentTargets: .iOS("16.0"),
  baseSetting: [
    // SPM 시절 swiftSettings 의 unsafeFlags 와 같은 플래그입니다.
    // iOS 16 배포 타깃에서 SwiftUICore 를 자동 링크하지 않게 막습니다.
    "OTHER_SWIFT_FLAGS":
      "$(inherited) -Xfrontend -disable-autolink-framework -Xfrontend SwiftUICore"
  ]
)

extension ProjectEnvironment {
  /// 앱 타깃에만 필요한 서명·디바이스 설정입니다.
  public var appSetting: SettingsDictionary {
    baseSetting.merging([
      "DEVELOPMENT_TEAM": "82P75Q2F2K",
      "CODE_SIGN_STYLE": "Automatic",
      "TARGETED_DEVICE_FAMILY": "1,2",
      "ENABLE_PREVIEWS": "YES",
    ]) { _, new in new }
  }
}
