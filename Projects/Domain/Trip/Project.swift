import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DomainTrip",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .domainTrip,
    .domainTripInterface,
    .domainTripTests,
    .domainTripTesting,
  ],
  schemes: [
    .scheme(
      name: "DomainTrip",
      shared: true,
      buildAction: .buildAction(targets: [.domainTrip]),
      testAction: .targets([.testableTarget(target: .domainTripTests)])
    )
  ]
)
