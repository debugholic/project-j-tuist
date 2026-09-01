import Foundation
import ProjectDescription

public enum Constant {
  public static let name = "ProjectJ"
  public static let bundleIdPrefix = "com.debugholic.ProjectJ"
  public static let deploymentTargets: DeploymentTargets = .iOS("16.0")

  /// SPM 시절 `swiftSettings` 의 `unsafeFlags` 와 같은 플래그입니다.
  /// iOS 16 배포 타깃에서 SwiftUICore 를 자동 링크하지 않게 막습니다.
  public static let disableSwiftUICoreAutolink =
    "$(inherited) -Xfrontend -disable-autolink-framework -Xfrontend SwiftUICore"

  public static let moduleSettings: SettingsDictionary = [
    "OTHER_SWIFT_FLAGS": .string(disableSwiftUICoreAutolink)
  ]

  public static let appSettings: SettingsDictionary = [
    "OTHER_SWIFT_FLAGS": .string(disableSwiftUICoreAutolink),
    "DEVELOPMENT_TEAM": "82P75Q2F2K",
    "CODE_SIGN_STYLE": "Automatic",
    "TARGETED_DEVICE_FAMILY": "1,2",
    "ENABLE_PREVIEWS": "YES",
  ]
}

// MARK: - Root

extension Path {
  /// 매니페스트 헬퍼는 `Tuist/ProjectDescriptionHelpers` 에서 컴파일되므로
  /// 두 단계 올라가면 리포 루트입니다. 리소스 디렉터리 존재 확인에 씁니다.
  static let modulesRoot: String = URL(fileURLWithPath: #filePath)
    .deletingLastPathComponent()  // ProjectDescriptionHelpers
    .deletingLastPathComponent()  // Tuist
    .deletingLastPathComponent()  // <root>
    .appendingPathComponent("Modules")
    .path
}
