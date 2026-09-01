import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let project = Project.feature(
  .itinerary,
  example: [
    .core(.storage),
    .data(.itinerary),
    .data(.recommendation),
    .domain(.itinerary),
    .domainInterface(.itinerary),
    .domain(.recommendation),
    .domainInterface(.recommendation),
    .domainInterface(.trip),
    .domainTesting(.trip),
    .feature(.itinerary),
    .featureInterface(.itinerary),
  ]
)
