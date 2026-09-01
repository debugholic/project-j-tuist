import ProjectDescription
import ProjectDescriptionHelpers

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
