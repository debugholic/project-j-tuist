import ProjectDescription

// 손으로 적는 유일한 곳입니다.
//
// 모듈 목록과 타깃 목록은 `.generated/Modules.swift` 가 디렉터리에서 만들어 줍니다.
// 하지만 무엇이 무엇에 기대는지는 디렉터리에 적혀 있지 않습니다 — 여기 남습니다.
//
// 모듈을 추가하면 `make sync` 가 타깃은 알아서 잡고, 의존성만 여기 채우면 됩니다.

extension Module {
  public func dependencies(_ layer: ModuleLayer, _ slot: ModuleSlot) -> [ModuleDependency] {
    switch self {
    case .itinerary: itinerary(layer, slot)
    case .recommendation: recommendation(layer, slot)
    case .reservation: reservation(layer, slot)
    case .trip: trip(layer, slot)

    // UIKit 을 감싸기만 해서 다른 모듈에 기대지 않습니다.
    case .designSystem: []

    // Core 와 Common 은 Package/ 소관이라 Tuist 타깃이 없습니다.
    default: []
    }
  }
}

// MARK: - Itinerary

extension Module {
  private func itinerary(_ layer: ModuleLayer, _ slot: ModuleSlot) -> [ModuleDependency] {
    switch (layer, slot) {
    case (.domain, .interface):
      [
        .domainInterface(.recommendation),
        .domainInterface(.trip),
        .shared(.common),
      ]

    case (.domain, .implementation):
      [
        .domainInterface(.itinerary),
        .domainInterface(.reservation),
        .domainInterface(.trip),
      ]

    case (.domain, .testing):
      [
        .domainInterface(.itinerary),
        .domainInterface(.recommendation),
        .domainInterface(.reservation),
        .domainTesting(.reservation),
        .sharedTesting(.common),
      ]

    case (.domain, .tests):
      [
        .domain(.itinerary),
        .domainTesting(.itinerary),
        .domainTesting(.reservation),
        .domainTesting(.trip),
        .sharedTesting(.common),
      ]

    case (.data, .implementation):
      [
        .core(.storage),
        .domainInterface(.itinerary),
      ]

    case (.feature, .interface):
      [
        .domainInterface(.trip),
      ]

    case (.feature, .implementation):
      [
        .domainInterface(.itinerary),
        .domainInterface(.recommendation),
        .domainInterface(.reservation),
        .domainInterface(.trip),
        .featureInterface(.itinerary),
        .featureInterface(.reservation),
        .shared(.common),
        .shared(.designSystem),
      ]

    case (.feature, .testing):
      [
        .domainInterface(.trip),
        .featureInterface(.itinerary),
      ]

    case (.feature, .tests):
      [
        .domainTesting(.itinerary),
        .domainTesting(.recommendation),
        .domainTesting(.reservation),
        .domainTesting(.trip),
        .feature(.itinerary),
        .featureTesting(.itinerary),
        .sharedTesting(.common),
      ]

    case (.feature, .example):
      [
        .core(.storage),
        .data(.itinerary),
        .data(.recommendation),
        .domain(.itinerary),
        .domainInterface(.itinerary),
        .domain(.recommendation),
        .domainInterface(.recommendation),
        .domainInterface(.trip),
        .domainTesting(.trip),
        .feature(.itinerary),
        .featureInterface(.itinerary),
      ]

    default: []
    }
  }
}

// MARK: - Recommendation

extension Module {
  private func recommendation(_ layer: ModuleLayer, _ slot: ModuleSlot) -> [ModuleDependency] {
    switch (layer, slot) {
    case (.domain, .interface):
      [
        .shared(.common),
      ]

    case (.domain, .implementation):
      [
        .domainInterface(.recommendation),
      ]

    case (.domain, .testing):
      [
        .domainInterface(.recommendation),
        .sharedTesting(.common),
      ]

    case (.data, .implementation):
      [
        .core(.travelGuide),
        .domainInterface(.recommendation),
      ]

    default: []
    }
  }
}

// MARK: - Reservation

extension Module {
  private func reservation(_ layer: ModuleLayer, _ slot: ModuleSlot) -> [ModuleDependency] {
    switch (layer, slot) {
    case (.domain, .interface):
      [
        .shared(.common),
      ]

    case (.domain, .testing):
      [
        .domainInterface(.reservation),
        .sharedTesting(.common),
      ]

    case (.data, .implementation):
      [
        .core(.network),
        .domainInterface(.reservation),
        .shared(.common),
      ]

    case (.feature, .interface):
      [
        .domainInterface(.reservation),
        .shared(.common),
      ]

    case (.feature, .implementation):
      [
        .domainInterface(.reservation),
        .domainInterface(.trip),
        .featureInterface(.reservation),
        .shared(.common),
        .shared(.designSystem),
      ]

    case (.feature, .testing):
      [
        .domainInterface(.trip),
        .featureInterface(.reservation),
      ]

    case (.feature, .tests):
      [
        .domainInterface(.reservation),
        .domainTesting(.reservation),
        .domainTesting(.trip),
        .feature(.reservation),
        .featureTesting(.reservation),
      ]

    case (.feature, .example):
      [
        .core(.storage),
        .data(.trip),
        .domainInterface(.reservation),
        .domainTesting(.reservation),
        .domain(.trip),
        .domainInterface(.trip),
        .feature(.reservation),
        .featureInterface(.reservation),
      ]

    default: []
    }
  }
}

// MARK: - Trip

extension Module {
  private func trip(_ layer: ModuleLayer, _ slot: ModuleSlot) -> [ModuleDependency] {
    switch (layer, slot) {
    case (.domain, .interface):
      [
        .domainInterface(.reservation),
        .shared(.common),
      ]

    case (.domain, .implementation):
      [
        .domainInterface(.trip),
        .domainInterface(.reservation),
      ]

    case (.domain, .testing):
      [
        .domainInterface(.trip),
        .domainTesting(.reservation),
        .sharedTesting(.common),
      ]

    case (.domain, .tests):
      [
        .domain(.trip),
        .domainTesting(.trip),
      ]

    case (.data, .implementation):
      [
        .core(.storage),
        .domainInterface(.trip),
      ]

    case (.feature, .interface):
      [
        .domainInterface(.trip),
        .shared(.common),
      ]

    case (.feature, .implementation):
      [
        .domainInterface(.trip),
        .domainInterface(.reservation),
        .featureInterface(.trip),
        .featureInterface(.itinerary),
        .featureInterface(.reservation),
        .shared(.common),
        .shared(.designSystem),
      ]

    case (.feature, .testing):
      [
        .domainInterface(.trip),
        .featureInterface(.trip),
      ]

    case (.feature, .tests):
      [
        .domainTesting(.trip),
        .feature(.trip),
        .featureTesting(.trip),
      ]

    case (.feature, .example):
      [
        .core(.storage),
        .data(.trip),
        .domain(.trip),
        .domainInterface(.trip),
        .domainTesting(.trip),
        .feature(.trip),
        .featureInterface(.trip),
      ]

    default: []
    }
  }
}
