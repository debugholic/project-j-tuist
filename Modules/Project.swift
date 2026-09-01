import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

/// I 단계의 `Package.swift` 와 같은 DSL 입니다.
/// 타깃 이름·경로·의존성은 `TargetPlugin` 이, 환경값은 `EnvironmentPlugin` 이 압니다.
let project = Project(
  name: "Modules",
  targets: Module.allCases.flatMap(\.components).map { $0.target(projectJ) }
)
