import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let project = Project.example(
  .trip,
  dependencies: [
    "CoreStorage",
    "DataTrip",
    "DomainTrip",
    "DomainTripInterface",
    "DomainTripTesting",
    "FeatureTrip",
    "FeatureTripInterface",
  ]
)
