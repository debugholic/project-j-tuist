import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

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
