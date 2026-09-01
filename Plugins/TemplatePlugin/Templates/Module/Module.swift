import ProjectDescription

private let name = Template.Attribute.required("name")
private let layer = Template.Attribute.optional("layer", default: "Feature")

/// `tuist scaffold module --name Payment --layer Feature`
/// I 단계에서 손으로 만들던 모듈 5종 세트의 뼈대를 찍어냅니다.
/// 의존성 선언과 Project.swift 는 손으로 추가해야 합니다 — `make sync` 가 누락을 잡습니다.
let template = Template(
  description: "Micro Feature Architecture 모듈 한 벌",
  attributes: [name, layer],
  items: [
    .file(
      path: "Projects/\(layer)/\(name)/Sources/\(name).swift",
      templatePath: "Sources.stencil"
    ),
    .file(
      path: "Projects/\(layer)/\(name)/Interface/Sources/\(name)Interface.swift",
      templatePath: "Interface.stencil"
    ),
    .file(
      path: "Projects/\(layer)/\(name)/Testing/Sources/\(name)Testing.swift",
      templatePath: "Testing.stencil"
    ),
    .file(
      path: "Projects/\(layer)/\(name)/Tests/Sources/\(name)Tests.swift",
      templatePath: "Tests.stencil"
    ),
    .file(
      path: "Projects/\(layer)/\(name)/Project.swift",
      templatePath: "Project.stencil"
    ),
  ]
)
