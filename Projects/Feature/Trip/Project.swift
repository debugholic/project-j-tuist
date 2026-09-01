import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let project = Project.feature(
  .trip,
  example: [
    .core(.storage),
    .data(.trip),
    .domain(.trip),
    .domainInterface(.trip),
    .domainTesting(.trip),
    .feature(.trip),
    .featureInterface(.trip),
  ]
)
