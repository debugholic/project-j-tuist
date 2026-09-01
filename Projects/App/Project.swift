import ProjectDescription
import ProjectDescriptionHelpers

private let modules: Path = "../../Modules"

let project = Project(
  name: "App",
  options: .options(automaticSchemesOptions: .disabled),
  settings: .settings(
    base: Constant.appSettings,
    configurations: [
      .debug(name: "Debug", xcconfig: "Config.xcconfig"),
      .release(name: "Release", xcconfig: "Config.xcconfig"),
    ]
  ),
  targets: [
    .target(
      name: "App",
      destinations: .iOS,
      product: .app,
      bundleId: "\(Constant.bundleIdPrefix).app",
      deploymentTargets: Constant.deploymentTargets,
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
        .modules("CoreNetwork", at: modules),
        .modules("CoreStorage", at: modules),
        .modules("DataItinerary", at: modules),
        .modules("DataRecommendation", at: modules),
        .modules("DataReservation", at: modules),
        .modules("DataTrip", at: modules),
        .modules("DomainItinerary", at: modules),
        .modules("DomainItineraryInterface", at: modules),
        .modules("DomainRecommendation", at: modules),
        .modules("DomainRecommendationInterface", at: modules),
        .modules("DomainReservationInterface", at: modules),
        .modules("DomainTrip", at: modules),
        .modules("DomainTripInterface", at: modules),
        .modules("FeatureItinerary", at: modules),
        .modules("FeatureItineraryInterface", at: modules),
        .modules("FeatureReservation", at: modules),
        .modules("FeatureReservationInterface", at: modules),
        .modules("FeatureTrip", at: modules),
        .modules("FeatureTripInterface", at: modules),
        .modules("SharedCommon", at: modules),
      ]
    )
  ]
)
