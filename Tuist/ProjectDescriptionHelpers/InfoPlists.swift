// AUTO-GENERATED File (first generation). You may edit.
// Provide custom InfoPlist definitions per target.
import ProjectDescription

extension InfoPlist: InfoPlists {
  public static var appInfoPlist: InfoPlist {
    .extendingDefault(
      with: [
        "CFBundleDisplayName": .string("ProjectJ"),
        "UILaunchScreen": .dictionary([:]),
        "UIApplicationSupportsIndirectInputEvents": .boolean(true),
        "RapidAPIKey": .string("$(RAPIDAPI_KEY)"),
        "UIApplicationSceneManifest": .dictionary([
          "UIApplicationSupportsMultipleScenes": .boolean(false),
          "UISceneConfigurations": .dictionary([
            "UIWindowSceneSessionRoleApplication": .array([
              .dictionary([
                "UISceneConfigurationName": .string("Default"),
                "UISceneDelegateClassName": .string("$(PRODUCT_MODULE_NAME).SceneDelegate"),
              ])
            ])
          ]),
        ]),
      ]
    )
  }
}
