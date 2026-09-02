// AUTO-GENERATED File (first generation). You may edit.
// Customize target dependency arrays per target variable name.
import ProjectDescription
import TargetPlugin

extension [TargetDependency]: TargetDependencies {

  // MARK: - App

  public static var appDependencies: [TargetDependency] {
    [
      .package(product: "CoreNetwork", type: .runtime, condition: .none),
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xData(.Itinerary),
      .xData(.Recommendation),
      .xData(.Reservation),
      .xData(.Trip),
      .xDomain(.Itinerary),
      .xDomain(.Itinerary, "Interface"),
      .xDomain(.Recommendation),
      .xDomain(.Recommendation, "Interface"),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Trip),
      .xDomain(.Trip, "Interface"),
      .xFeature(.Itinerary),
      .xFeature(.Itinerary, "Interface"),
      .xFeature(.Reservation),
      .xFeature(.Reservation, "Interface"),
      .xFeature(.Trip),
      .xFeature(.Trip, "Interface"),
    ]
  }

  // MARK: - Domain / Itinerary

  public static var domainItineraryInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xDomain(.Recommendation, "Interface"),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var domainItineraryDependencies: [TargetDependency] {
    [
      .domain(interface: .itinerary),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var domainItineraryTestingDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .domain(interface: .itinerary),
      .xDomain(.Recommendation, "Interface"),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Reservation, "Testing"),
    ]
  }

  public static var domainItineraryTestsDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .domain(implements: .itinerary),
      .domain(testing: .itinerary),
      .xDomain(.Reservation, "Testing"),
      .xDomain(.Trip, "Testing"),
    ]
  }

  // MARK: - Domain / Recommendation

  public static var domainRecommendationInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none)
    ]
  }

  public static var domainRecommendationDependencies: [TargetDependency] {
    [
      .domain(interface: .recommendation)
    ]
  }

  public static var domainRecommendationTestingDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .domain(interface: .recommendation),
    ]
  }

  // MARK: - Domain / Reservation

  public static var domainReservationInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none)
    ]
  }

  public static var domainReservationTestingDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .domain(interface: .reservation),
    ]
  }

  // MARK: - Domain / Trip

  public static var domainTripInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xDomain(.Reservation, "Interface"),
    ]
  }

  public static var domainTripDependencies: [TargetDependency] {
    [
      .domain(interface: .trip),
      .xDomain(.Reservation, "Interface"),
    ]
  }

  public static var domainTripTestingDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .domain(interface: .trip),
      .xDomain(.Reservation, "Testing"),
    ]
  }

  public static var domainTripTestsDependencies: [TargetDependency] {
    [
      .domain(implements: .trip),
      .domain(testing: .trip),
    ]
  }

  // MARK: - Data

  public static var dataItineraryDependencies: [TargetDependency] {
    [
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .xDomain(.Itinerary, "Interface"),
    ]
  }

  public static var dataRecommendationDependencies: [TargetDependency] {
    [
      .package(product: "CoreTravelGuide", type: .runtime, condition: .none),
      .xDomain(.Recommendation, "Interface"),
    ]
  }

  public static var dataReservationDependencies: [TargetDependency] {
    [
      .package(product: "CoreNetwork", type: .runtime, condition: .none),
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xDomain(.Reservation, "Interface"),
    ]
  }

  public static var dataTripDependencies: [TargetDependency] {
    [
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .xDomain(.Trip, "Interface"),
    ]
  }

  // MARK: - Feature / Itinerary

  public static var featureItineraryInterfaceDependencies: [TargetDependency] {
    [
      .xDomain(.Trip, "Interface")
    ]
  }

  public static var featureItineraryDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .feature(interface: .itinerary),
      .xDomain(.Itinerary, "Interface"),
      .xDomain(.Recommendation, "Interface"),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Trip, "Interface"),
      .xFeature(.Reservation, "Interface"),
      .xShared(.DesignSystem),
    ]
  }

  public static var featureItineraryTestingDependencies: [TargetDependency] {
    [
      .feature(interface: .itinerary),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var featureItineraryTestsDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommonTesting", type: .runtime, condition: .none),
      .feature(implements: .itinerary),
      .feature(testing: .itinerary),
      .xDomain(.Itinerary, "Testing"),
      .xDomain(.Recommendation, "Testing"),
      .xDomain(.Reservation, "Testing"),
      .xDomain(.Trip, "Testing"),
    ]
  }

  public static var featureItineraryExampleDependencies: [TargetDependency] {
    [
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .feature(implements: .itinerary),
      .feature(interface: .itinerary),
      .xData(.Itinerary),
      .xData(.Recommendation),
      .xDomain(.Itinerary),
      .xDomain(.Itinerary, "Interface"),
      .xDomain(.Recommendation),
      .xDomain(.Recommendation, "Interface"),
      .xDomain(.Trip, "Interface"),
      .xDomain(.Trip, "Testing"),
    ]
  }

  // MARK: - Feature / Reservation

  public static var featureReservationInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xDomain(.Reservation, "Interface"),
    ]
  }

  public static var featureReservationDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .feature(interface: .reservation),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Trip, "Interface"),
      .xShared(.DesignSystem),
    ]
  }

  public static var featureReservationTestingDependencies: [TargetDependency] {
    [
      .feature(interface: .reservation),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var featureReservationTestsDependencies: [TargetDependency] {
    [
      .feature(implements: .reservation),
      .feature(testing: .reservation),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Reservation, "Testing"),
      .xDomain(.Trip, "Testing"),
    ]
  }

  public static var featureReservationExampleDependencies: [TargetDependency] {
    [
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .feature(implements: .reservation),
      .feature(interface: .reservation),
      .xData(.Trip),
      .xDomain(.Reservation, "Interface"),
      .xDomain(.Reservation, "Testing"),
      .xDomain(.Trip),
      .xDomain(.Trip, "Interface"),
    ]
  }

  // MARK: - Feature / Trip

  public static var featureTripInterfaceDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var featureTripDependencies: [TargetDependency] {
    [
      .package(product: "SharedCommon", type: .runtime, condition: .none),
      .feature(interface: .trip),
      .xDomain(.Trip, "Interface"),
      .xDomain(.Reservation, "Interface"),
      .xFeature(.Itinerary, "Interface"),
      .xFeature(.Reservation, "Interface"),
      .xShared(.DesignSystem),
    ]
  }

  public static var featureTripTestingDependencies: [TargetDependency] {
    [
      .feature(interface: .trip),
      .xDomain(.Trip, "Interface"),
    ]
  }

  public static var featureTripTestsDependencies: [TargetDependency] {
    [
      .feature(implements: .trip),
      .feature(testing: .trip),
      .xDomain(.Trip, "Testing"),
    ]
  }

  public static var featureTripExampleDependencies: [TargetDependency] {
    [
      .package(product: "CoreStorage", type: .runtime, condition: .none),
      .feature(implements: .trip),
      .feature(interface: .trip),
      .xData(.Trip),
      .xDomain(.Trip),
      .xDomain(.Trip, "Interface"),
      .xDomain(.Trip, "Testing"),
    ]
  }
}
extension TargetDependency {
  fileprivate static func xDomain(_ m: Module.Domain, _ suffix: String = "") -> Self {
    .project(target: "Domain\(m.name)\(suffix)", path: .domain(implementation: m))
  }

  fileprivate static func xData(_ m: Module.Data, _ suffix: String = "") -> Self {
    .project(target: "Data\(m.name)\(suffix)", path: .data(implementation: m))
  }

  fileprivate static func xFeature(_ m: Module.Feature, _ suffix: String = "") -> Self {
    .project(target: "Feature\(m.name)\(suffix)", path: .feature(implementation: m))
  }

  fileprivate static func xShared(_ m: Module.Shared, _ suffix: String = "") -> Self {
    .project(target: "Shared\(m.name)\(suffix)", path: .shared(implementation: m))
  }
}
