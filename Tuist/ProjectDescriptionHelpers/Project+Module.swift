import ConfigurationPlugin
import EnvironmentPlugin
import ProjectDescription
import TargetPlugin

extension Project {
  /// 모듈 하나 = 프로젝트 하나.
  /// `Projects/<Layer>/<Module>` 안의 Interface · Sources · Testing · Tests 를 담습니다.
  public static func module(
    _ modulePath: String,
    env: ProjectEnvironment = projectJ,
    usesPackage extraUsesPackage: Bool = false,
    extraTargets: [Target] = []
  ) -> Project {
    let components = Module.components(at: modulePath)

    return Project(
      name: modulePath.replacingOccurrences(of: "/", with: ""),
      options: .options(automaticSchemesOptions: .disabled),
      packages: (extraUsesPackage || components.contains(where: \.usesPackage)) ? [.package] : [],
      settings: .settings(base: env.baseSetting),
      targets: components.map { $0.target(env) } + extraTargets
    )
  }

  /// Feature 모듈은 Example 앱까지 같은 프로젝트에 담습니다.
  /// I 단계에서 Example 만 별도 `.xcodeproj` 로 떨어져 있던 것이 여기서 합쳐집니다.
  public static func feature(
    _ module: Module,
    env: ProjectEnvironment = projectJ,
    example dependencies: [ModuleDependency]
  ) -> Project {
    .module(
      "Feature/\(module.rawValue)",
      env: env,
      usesPackage: dependencies.contains(where: \.isPackage),
      extraTargets: [
        .target(
          name: module.exampleName,
          destinations: env.destinations,
          product: .app,
          bundleId: env.bundleId("example.\(module.rawValue.lowercased())"),
          deploymentTargets: env.deploymentTargets,
          infoPlist: .default,
          sources: ["Example/Sources/**"],
          dependencies: dependencies.map {
            $0.dependency(from: "Feature/\(module.rawValue)")
          },
          settings: .settings(
            base: env.appSetting,
            configurations: ConfigurationType.configurations()
          )
        )
      ]
    )
  }
}

extension Module {
  public var exampleName: String { "Feature\(rawValue)Example" }
  public var examplePath: Path { .relativeToRoot("Projects/Feature/\(rawValue)") }
}
