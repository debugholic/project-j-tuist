import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.example(
  .reservation,
  dependencies: [
    "CoreStorage",
    "DataTrip",
    "DomainReservationInterface",
    "DomainReservationTesting",
    "DomainTrip",
    "DomainTripInterface",
    "FeatureReservation",
    "FeatureReservationInterface",
  ]
)
