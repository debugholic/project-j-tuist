import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DomainReservation",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .domainReservationInterface,
    .domainReservationTesting,
  ]
)
