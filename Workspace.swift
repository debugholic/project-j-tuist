import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let workspace = Workspace(
  name: "ProjectJ",
  projects: ["Projects/App"]
    + Module.modulePaths.map { "Projects/\($0)" },
  schemes: [
    .app(
      name: "App",
      project: .relativeToRoot("Projects/App"),
      target: "App",
      tests: [.coreTests(.travelGuide)]
    ),
    .example(.itinerary, tests: [.domainTests(.itinerary), .featureTests(.itinerary)]),
    .example(.reservation, tests: [.featureTests(.reservation)]),
    .example(.trip, tests: [.domainTests(.trip), .featureTests(.trip)]),
  ]
)
