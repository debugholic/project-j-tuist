import ProjectDescription
import TargetPlugin

extension Scheme {
  /// 앱 타깃 하나를 빌드·실행하고, 관련 테스트 타깃을 물리는 스킴입니다.
  /// 타깃이 여러 프로젝트에 걸쳐 있어 워크스페이스에서만 선언할 수 있습니다.
  public static func app(
    name: String,
    project: Path,
    target: String,
    tests: [ModuleDependency]
  ) -> Scheme {
    let app: TargetReference = .project(path: project, target: target)

    return .scheme(
      name: name,
      shared: true,
      buildAction: .buildAction(targets: [app]),
      testAction: .targets(tests.map { .testableTarget(target: $0.reference) }),
      runAction: .runAction(executable: app)
    )
  }

  public static func example(_ module: Module, tests: [ModuleDependency]) -> Scheme {
    .app(
      name: module.exampleName,
      project: module.examplePath,
      target: module.exampleName,
      tests: tests
    )
  }
}
