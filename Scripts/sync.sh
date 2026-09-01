#!/bin/bash
# 디스크의 모듈과 매니페스트 선언이 어긋났는지 검사합니다.
#
# make module 은 디렉터리만 찍어냅니다. 의존성 선언(Module.swift)과
# Project.swift 는 손으로 추가해야 하고, 빠뜨리면 그 모듈은 조용히
# 빌드에서 빠집니다. 그 조용한 실패를 여기서 잡습니다.

set -uo pipefail
cd "$(dirname "$0")/.."

MODULE_MANIFEST="Plugins/TargetPlugin/ProjectDescriptionHelpers/Module.swift"
COMPONENT_MANIFEST="Plugins/TargetPlugin/ProjectDescriptionHelpers/Component.swift"
drift=0

for dir in Projects/*/*/; do
  layer=$(basename "$(dirname "$dir")")
  name=$(basename "$dir")
  [ "$layer" = "App" ] && continue

  # 1) 빌드에 올라가려면 Project.swift 가 있어야 합니다.
  if [ ! -f "$dir/Project.swift" ]; then
    echo "  ✗ $layer/$name — Project.swift 가 없습니다 (빌드에서 빠집니다)"
    drift=1
  fi

  # 2) 타깃이 생기려면 Module/Component 에 선언돼 있어야 합니다.
  if ! grep -q "= \"$name\"" "$MODULE_MANIFEST" "$COMPONENT_MANIFEST"; then
    echo "  ✗ $layer/$name — 매니페스트에 선언이 없습니다"
    echo "      $MODULE_MANIFEST 에 케이스와 의존성을 추가하세요"
    drift=1
  fi

  # 3) 소스가 없는 껍데기 디렉터리
  if [ -z "$(find "$dir" -name '*.swift' -not -name 'Project.swift' -print -quit)" ]; then
    echo "  ! $layer/$name — Swift 소스가 없습니다"
  fi
done

if [ "$drift" -eq 0 ]; then
  echo "  모듈 $(find Projects/*/*/ -maxdepth 0 -type d | grep -cv "Projects/App")개 — 디스크와 매니페스트가 일치합니다."
else
  echo
  echo "  선언이 어긋났습니다. 위 항목을 고치고 다시 도세요."
fi
exit $drift
