import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "FeatureTrip",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .featureTrip,
    .featureTripInterface,
    .featureTripTests,
    .featureTripTesting,
    .featureTripExample,
  ],
  schemes: [
    .exampleTripScheme
  ]
)
