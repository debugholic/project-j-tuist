import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "FeatureItinerary",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .featureItinerary,
    .featureItineraryInterface,
    .featureItineraryTests,
    .featureItineraryTesting,
    .featureItineraryExample,
  ],
  schemes: [
    .exampleItineraryScheme
  ]
)
