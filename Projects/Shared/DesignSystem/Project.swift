import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "SharedDesignSystem",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .sharedDesignSystem
  ]
)
