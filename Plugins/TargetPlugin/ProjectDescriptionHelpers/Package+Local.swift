import ProjectDescription

extension Package {
  /// `Package/Package.swift` — UIKit 을 안 쓰는 모듈들이 사는 로컬 SPM 패키지입니다.
  public static var package: Package { .local(path: .relativeToRoot("Package")) }
}

extension Component {
  /// 이 조각이 패키지 product 를 하나라도 쓰는지.
  /// 쓰면 그 타깃이 속한 프로젝트가 패키지를 참조해야 합니다.
  public var usesPackage: Bool {
    dependencies.contains(where: \.isPackage)
  }
}
