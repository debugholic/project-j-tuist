import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DomainItinerary",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .domainItinerary,
    .domainItineraryInterface,
    .domainItineraryTests,
    .domainItineraryTesting,
  ],
  schemes: [
    .scheme(
      name: "DomainItinerary",
      shared: true,
      buildAction: .buildAction(targets: [.domainItinerary]),
      testAction: .targets([.testableTarget(target: .domainItineraryTests)])
    )
  ]
)
