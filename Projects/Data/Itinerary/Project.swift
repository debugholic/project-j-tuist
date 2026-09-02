import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DataItinerary",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .dataItinerary
  ]
)
