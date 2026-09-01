import ConfigurationPlugin
import ProjectDescription
import ProjectDescriptionHelpers
import TargetPlugin

private let env = projectJ

let project = Project(
  name: "App",
  options: .options(automaticSchemesOptions: .disabled),
  settings: .settings(
    base: env.appSetting,
    configurations: ConfigurationType.configurations()
  ),
  targets: [
    .target(
      name: "App",
      destinations: env.destinations,
      product: .app,
      bundleId: env.bundleId("app"),
      deploymentTargets: env.deploymentTargets,
      infoPlist: .extendingDefault(with: [
        "RapidAPIKey": "$(RAPIDAPI_KEY)",
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false,
          "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
              [
                "UISceneConfigurationName": "Default",
                "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate",
              ]
            ]
          ],
        ],
      ]),
      sources: ["Sources/**"],
      resources: ["Sources/Assets.xcassets"],
      dependencies: [
        .modules("CoreNetwork"),
        .modules("CoreStorage"),
        .modules("DataItinerary"),
        .modules("DataRecommendation"),
        .modules("DataReservation"),
        .modules("DataTrip"),
        .modules("DomainItinerary"),
        .modules("DomainItineraryInterface"),
        .modules("DomainRecommendation"),
        .modules("DomainRecommendationInterface"),
        .modules("DomainReservationInterface"),
        .modules("DomainTrip"),
        .modules("DomainTripInterface"),
        .modules("FeatureItinerary"),
        .modules("FeatureItineraryInterface"),
        .modules("FeatureReservation"),
        .modules("FeatureReservationInterface"),
        .modules("FeatureTrip"),
        .modules("FeatureTripInterface"),
        .modules("SharedCommon"),
      ]
    )
  ]
)
