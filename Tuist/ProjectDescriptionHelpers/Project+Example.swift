import ProjectDescription

extension Project {
  /// `Projects/Feature/<Module>` 의 Example 앱 프로젝트입니다.
  /// 모듈 하나만 링크해 단독 실행합니다.
  /// 스킴은 다른 프로젝트의 테스트 타깃을 물어야 해서 `Workspace.swift` 가 선언합니다.
  public static func example(
    _ module: Module,
    dependencies: [String]
  ) -> Project {
    let modules: Path = "../../../Modules"

    return Project(
      name: "Feature\(module.rawValue)",
      options: .options(automaticSchemesOptions: .disabled),
      settings: .settings(base: Constant.appSettings),
      targets: [
        .target(
          name: module.exampleName,
          destinations: .iOS,
          product: .app,
          bundleId: "\(Constant.bundleIdPrefix).example.\(module.rawValue.lowercased())",
          deploymentTargets: Constant.deploymentTargets,
          infoPlist: .default,
          sources: ["Example/Sources/**"],
          dependencies: dependencies.map { .modules($0, at: modules) }
        )
      ]
    )
  }
}

extension Module {
  public var exampleName: String { "Feature\(rawValue)Example" }

  /// 워크스페이스 루트에서 본 Example 프로젝트 경로입니다.
  public var examplePath: Path { "Projects/Feature/\(rawValue)" }
}
