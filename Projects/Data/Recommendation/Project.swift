import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DataRecommendation",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .dataRecommendation
  ]
)
