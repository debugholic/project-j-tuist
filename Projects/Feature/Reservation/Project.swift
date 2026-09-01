import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let project = Project.feature(
  .reservation,
  example: [
    .core(.storage),
    .data(.trip),
    .domainInterface(.reservation),
    .domainTesting(.reservation),
    .domain(.trip),
    .domainInterface(.trip),
    .feature(.reservation),
    .featureInterface(.reservation),
  ]
)
