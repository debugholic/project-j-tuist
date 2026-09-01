import ProjectDescription

public enum Module: String, CaseIterable {
  // Module
  case itinerary = "Itinerary"
  case recommendation = "Recommendation"
  case reservation = "Reservation"
  case trip = "Trip"

  // Kit
  case core = "Core"
  case shared = "Shared"

  public var targets: [Component] {
    components.filter { !$0.isTest }
  }

  public var components: [Component] {
    switch self {
    // MARK: - Module: Itinerary
    case .itinerary:
      [
        .domainInterface(
          self,
          dependencies: [
            .domainInterface(.recommendation),
            .domainInterface(.trip),
            .shared(.common),
          ]
        ),
        .domain(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.reservation),
            .domainInterface(.trip),
          ]
        ),
        .domainTesting(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.recommendation),
            .domainInterface(.reservation),
            .domainTesting(.reservation),
            .sharedTesting(.common),
          ]
        ),
        .domainTests(
          self,
          dependencies: [
            .domain(self),
            .domainTesting(self),
            .domainTesting(.reservation),
            .domainTesting(.trip),
            .sharedTesting(.common),
          ]
        ),
        .data(
          self,
          dependencies: [
            .core(.storage),
            .domainInterface(self),
          ]
        ),
        .featureInterface(
          self,
          dependencies: [
            .domainInterface(.trip)
          ]
        ),
        .feature(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.recommendation),
            .domainInterface(.reservation),
            .domainInterface(.trip),
            .featureInterface(self),
            .featureInterface(.reservation),
            .shared(.common),
            .shared(.designSystem),
          ]
        ),
        .featureTesting(
          self,
          dependencies: [
            .domainInterface(.trip),
            .featureInterface(self),
          ]
        ),
        .featureTests(
          self,
          dependencies: [
            .domainTesting(self),
            .domainTesting(.recommendation),
            .domainTesting(.reservation),
            .domainTesting(.trip),
            .feature(self),
            .featureTesting(self),
            .sharedTesting(.common),
          ]
        ),
      ]

    // MARK: - Module: Recommendation
    case .recommendation:
      [
        .domainInterface(
          self,
          dependencies: [
            .shared(.common)
          ]
        ),
        .domain(
          self,
          dependencies: [
            .domainInterface(self)
          ]
        ),
        .domainTesting(
          self,
          dependencies: [
            .domainInterface(self),
            .sharedTesting(.common),
          ]
        ),
        .data(
          self,
          dependencies: [
            .core(.travelGuide),
            .domainInterface(self),
          ]
        ),
      ]

    // MARK: - Module: Reservation
    case .reservation:
      [
        .domainInterface(
          self,
          dependencies: [
            .shared(.common)
          ]
        ),
        .domainTesting(
          self,
          dependencies: [
            .domainInterface(self),
            .sharedTesting(.common),
          ]
        ),
        .data(
          self,
          dependencies: [
            .core(.network),
            .domainInterface(self),
            .shared(.common),
          ]
        ),
        .featureInterface(
          self,
          dependencies: [
            .domainInterface(self),
            .shared(.common),
          ]
        ),
        .feature(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.trip),
            .featureInterface(self),
            .shared(.common),
            .shared(.designSystem),
          ]
        ),
        .featureTesting(
          self,
          dependencies: [
            .domainInterface(.trip),
            .featureInterface(self),
          ]
        ),
        .featureTests(
          self,
          dependencies: [
            .domainInterface(self),
            .domainTesting(self),
            .domainTesting(.trip),
            .feature(self),
            .featureTesting(self),
          ]
        ),
      ]

    // MARK: - Module: Trip
    case .trip:
      [
        .domainInterface(
          self,
          dependencies: [
            .domainInterface(.reservation),
            .shared(.common),
          ]
        ),
        .domain(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.reservation),
          ]
        ),
        .domainTesting(
          self,
          dependencies: [
            .domainInterface(self),
            .domainTesting(.reservation),
            .sharedTesting(.common),
          ]
        ),
        .domainTests(
          self,
          dependencies: [
            .domain(self),
            .domainTesting(self),
          ]
        ),
        .data(
          self,
          dependencies: [
            .core(.storage),
            .domainInterface(self),
          ]
        ),
        .featureInterface(
          self,
          dependencies: [
            .domainInterface(self),
            .shared(.common),
          ]
        ),
        .feature(
          self,
          dependencies: [
            .domainInterface(self),
            .domainInterface(.reservation),
            .featureInterface(self),
            .featureInterface(.itinerary),
            .featureInterface(.reservation),
            .shared(.common),
            .shared(.designSystem),
          ]
        ),
        .featureTesting(
          self,
          dependencies: [
            .domainInterface(.trip),
            .featureInterface(self),
          ]
        ),
        .featureTests(
          self,
          dependencies: [
            .domainTesting(self),
            .feature(self),
            .featureTesting(self),
          ]
        ),
      ]

    // MARK: - Kit: Core
    case .core:
      Component.Core.allCases.flatMap { component -> [Component] in
        switch component {
        case .travelGuide:
          [
            .core(component),
            .coreTests(
              component,
              dependencies: [.core(component)]
            ),
          ]
        default:
          [.core(component)]
        }
      }

    // MARK: - Kit: Shared
    case .shared:
      Component.Shared.allCases.flatMap { component -> [Component] in
        switch component {
        case .common:
          [
            .shared(component),
            .sharedTesting(
              component,
              dependencies: [.shared(component)]
            ),
          ]
        default:
          [.shared(component)]
        }
      }
    }
  }
}
