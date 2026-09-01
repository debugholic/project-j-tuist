import ConfigurationPlugin
import EnvironmentPlugin
import ProjectDescription
import TargetPlugin

extension Component {
  /// `TargetPlugin` 이 주는 이름·경로·의존성에 환경값을 입혀 타깃으로 만듭니다.
  /// 타깃 생성이 플러그인이 아니라 여기 있는 이유는, 환경값이 다른 플러그인 소관이라
  /// 플러그인 안에서는 볼 수 없기 때문입니다.
  public func target(_ env: ProjectEnvironment) -> Target {
    .target(
      name: name,
      destinations: env.destinations,
      product: isApp ? .app : (isTest ? .unitTests : .staticFramework),
      bundleId: env.bundleId(isApp ? "example.\(module.rawValue.lowercased())" : name),
      deploymentTargets: env.deploymentTargets,
      infoPlist: isApp ? env.infoPlist() : .default,
      sources: ["\(sourcePath)"],
      resources: resources,
      dependencies: dependencies.map { $0.dependency(from: modulePath) },
      settings: isApp
        ? .settings(base: env.appSetting, configurations: ConfigurationType.configurations())
        : .settings(base: env.baseSetting)
    )
  }
}
