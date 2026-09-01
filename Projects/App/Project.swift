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
      // 앱은 어느 모듈에도 속하지 않으므로 전부 다른 프로젝트입니다.
      dependencies: ([
        .core(.network),
        .core(.storage),
        .data(.itinerary),
        .data(.recommendation),
        .data(.reservation),
        .data(.trip),
        .domain(.itinerary),
        .domainInterface(.itinerary),
        .domain(.recommendation),
        .domainInterface(.recommendation),
        .domainInterface(.reservation),
        .domain(.trip),
        .domainInterface(.trip),
        .feature(.itinerary),
        .featureInterface(.itinerary),
        .feature(.reservation),
        .featureInterface(.reservation),
        .feature(.trip),
        .featureInterface(.trip),
        .shared(.common),
      ] as [ModuleDependency]).map { $0.dependency(from: "App") }
    )
  ]
)
