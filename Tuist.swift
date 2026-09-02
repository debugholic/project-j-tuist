import ProjectDescription

let tuist = Tuist(
  project: .tuist(
    plugins: [
      .local(path: "../Plugins/ConfigurationPlugin"),
      .local(path: "../Plugins/TargetPlugin"),
      .local(path: "../Plugins/EnvironmentPlugin"),
      .local(path: "../Plugins/TemplatePlugin"),
    ]
  )
)
