import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

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
