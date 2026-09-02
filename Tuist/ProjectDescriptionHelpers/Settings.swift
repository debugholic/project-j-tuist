// AUTO-GENERATED File (first generation). You may edit.
// Provide Settings overrides (e.g. compiler flags) per target.
import ProjectDescription
import ConfigurationPlugin

public let baseSettings: SettingsDictionary = [
  "CODE_SIGN_STYLE": "Automatic",
  "DEVELOPMENT_TEAM": "82P75Q2F2K",
  "CLANG_ENABLE_MODULES": "YES",
  "CLANG_ENABLE_MODULE_VERIFIER": "YES",
  "CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES": "YES",
  "ENABLE_USER_SCRIPT_SANDBOXING": "YES",
  "ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS": "YES",
  "OTHER_SWIFT_FLAGS":
    "$(inherited) -Xfrontend -disable-autolink-framework -Xfrontend SwiftUICore",
]

extension Settings: TargetSettings {
  // public static var appSettings: Settings? {
  //   .settings(base: ["SWIFT_OPTIMIZATION_LEVEL": "-Onone"], configurations: [])
  // }
}
