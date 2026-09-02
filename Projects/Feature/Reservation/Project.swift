import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "FeatureReservation",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .featureReservation,
    .featureReservationInterface,
    .featureReservationTests,
    .featureReservationTesting,
    .featureReservationExample,
  ],
  schemes: [
    .exampleReservationScheme
  ]
)
