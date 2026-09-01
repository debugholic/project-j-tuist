import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
  name: "ProjectJ",
  projects: [
    "Modules",
    "Projects/App",
    "Projects/Feature/Itinerary",
    "Projects/Feature/Reservation",
    "Projects/Feature/Trip",
  ],
  schemes: [
    .app(
      name: "App",
      project: "Projects/App",
      target: "App",
      tests: ["CoreTravelGuideTests"]
    ),
    .example(.itinerary, tests: ["DomainItineraryTests", "FeatureItineraryTests"]),
    .example(.reservation, tests: ["FeatureReservationTests"]),
    .example(.trip, tests: ["DomainTripTests", "FeatureTripTests"]),
  ]
)
