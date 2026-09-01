import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

let workspace = Workspace(
  name: "ProjectJ",
  projects: ["Projects/App"]
    + Module.modulePaths.map { "Projects/\($0)" },
  schemes: [
    // Core 테스트는 Package/ 로 갔습니다. `swift test` 또는 `make test` 가 돕니다.
    .app(
      name: "App",
      project: .relativeToRoot("Projects/App"),
      target: "App",
      tests: []
    ),
    .example(.itinerary, tests: [.domainTests(.itinerary), .featureTests(.itinerary)]),
    .example(.reservation, tests: [.featureTests(.reservation)]),
    .example(.trip, tests: [.domainTests(.trip), .featureTests(.trip)]),
  ]
)
