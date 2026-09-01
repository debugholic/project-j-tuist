import ProjectDescription
import ProjectDescriptionHelpers

/// I 단계의 `Package.swift` 와 같은 DSL 입니다.
/// `PackageDescription.Target` 대신 `ProjectDescription.Target` 을 만듭니다.
let project = Project(
  name: "Modules",
  targets: Module.allCases.flatMap(\.components).map(\.target)
)
