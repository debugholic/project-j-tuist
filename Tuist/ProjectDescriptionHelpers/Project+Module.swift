import ConfigurationPlugin
import EnvironmentPlugin
import ProjectDescription
import TargetPlugin

extension Project {
  /// 모듈 하나 = 프로젝트 하나.
  ///
  /// 어떤 타깃이 들어갈지는 디스크가 정합니다 — `Interface/Sources` 가 있으면
  /// Interface 타깃이 생기고, `Example/Sources` 가 있으면 Example 앱이 생깁니다.
  /// `make sync` 가 그 스캔 결과를 `.generated/Modules.swift` 로 만들어 둡니다.
  public static func module(
    _ modulePath: String,
    env: ProjectEnvironment = projectJ
  ) -> Project {
    let components = Module.components(at: modulePath)

    return Project(
      name: modulePath.replacingOccurrences(of: "/", with: ""),
      options: .options(automaticSchemesOptions: .disabled),
      packages: components.contains(where: \.usesPackage) ? [.local] : [],
      settings: .settings(
        base: env.baseSetting,
        configurations: ConfigurationType.configurations()
      ),
      targets: components.map { $0.target(env) }
    )
  }
}

extension Module {
  public var exampleName: String { "Feature\(rawValue)Example" }
  public var examplePath: Path { .relativeToRoot("Projects/Feature/\(rawValue)") }
}
