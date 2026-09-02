import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "DomainRecommendation",
  options: .options(
    automaticSchemesOptions: .disabled
  ),
  settings: .settings(
    base: baseSettings,
    configurations: configurations
  ),
  targets: [
    .domainRecommendation,
    .domainRecommendationInterface,
    .domainRecommendationTesting,
  ]
)
