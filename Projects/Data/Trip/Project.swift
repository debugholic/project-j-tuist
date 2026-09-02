import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DataTrip",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .dataTrip
  ]
)
