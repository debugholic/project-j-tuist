import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.example(
  .itinerary,
  dependencies: [
    "CoreStorage",
    "DataItinerary",
    "DataRecommendation",
    "DomainItinerary",
    "DomainItineraryInterface",
    "DomainRecommendation",
    "DomainRecommendationInterface",
    "DomainTripInterface",
    "DomainTripTesting",
    "FeatureItinerary",
    "FeatureItineraryInterface",
  ]
)
