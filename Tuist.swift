import ProjectDescription

let tuist = Tuist(
  project: .tuist(
    plugins: [
      .local(path: .relativeToRoot("Plugins/ConfigurationPlugin")),
      .local(path: .relativeToRoot("Plugins/EnvironmentPlugin")),
      .local(path: .relativeToRoot("Plugins/TargetPlugin")),
      .local(path: .relativeToRoot("Plugins/TemplatePlugin")),
    ]
  )
)
