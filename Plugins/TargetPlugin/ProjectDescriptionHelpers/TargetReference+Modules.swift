import ProjectDescription

extension TargetReference {
  /// 스킴에서 `Modules` 프로젝트의 테스트 타깃을 참조합니다.
  public static func modules(_ name: String) -> Self {
    .project(path: .relativeToRoot("Modules"), target: name)
  }
}
