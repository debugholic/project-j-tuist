import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "App",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  packages: [
    .local(path: "../../Package")
  ],
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .app
  ],
  schemes: [
    .appScheme
  ]
)
