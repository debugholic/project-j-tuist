import ProjectDescription

extension TargetDependency {
  /// `Modules` 프로젝트의 타깃을 가리킵니다. `path` 는 각 앱 프로젝트에서 본 상대 경로입니다.
  public static func modules(_ name: String, at path: Path) -> Self {
    .project(target: name, path: path)
  }
}

extension TargetReference {
  /// 스킴에서 `Modules` 프로젝트의 테스트 타깃을 참조합니다.
  public static func modules(_ name: String, at path: Path) -> Self {
    .project(path: path, target: name)
  }
}
