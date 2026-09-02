import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DataReservation",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .dataReservation
  ]
)
