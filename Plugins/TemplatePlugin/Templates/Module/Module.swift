import ProjectDescription

private let name = Template.Attribute.required("name")
private let layer = Template.Attribute.optional("layer", default: "Feature")

/// `tuist scaffold module --name Payment --layer Feature`
/// I 단계에서 손으로 만들던 모듈 5종 세트의 뼈대를 찍어냅니다.
let template = Template(
  description: "Micro Feature Architecture 모듈 한 벌",
  attributes: [name, layer],
  items: [
    .file(
      path: "Modules/\(layer)/\(name)/Sources/\(name).swift",
      templatePath: "Sources.stencil"
    ),
    .file(
      path: "Modules/\(layer)/\(name)/Interface/Sources/\(name)Interface.swift",
      templatePath: "Interface.stencil"
    ),
    .file(
      path: "Modules/\(layer)/\(name)/Testing/Sources/\(name)Testing.swift",
      templatePath: "Testing.stencil"
    ),
    .file(
      path: "Modules/\(layer)/\(name)/Tests/Sources/\(name)Tests.swift",
      templatePath: "Tests.stencil"
    ),
  ]
)
