#!/bin/bash
# 생성기(SyncModules)가 만든 선언과 디스크가 맞는지 확인합니다.
#
# 모듈 목록과 타깃 목록은 디렉터리에서 생성됩니다. 생성되지 않는 것이 둘 있습니다.
#   - Project.swift  : 모듈 디렉터리마다 하나 있어야 빌드에 올라갑니다
#   - 의존성 그래프   : 무엇이 무엇에 기대는지는 디렉터리에 적혀 있지 않습니다
# 그 둘의 누락과, 패키지 경계가 무너지는 경우를 잡습니다.

set -uo pipefail
cd "$(dirname "$0")/.."

GENERATED="Plugins/TargetPlugin/ProjectDescriptionHelpers/.generated/Modules.swift"
DEPENDENCIES="Plugins/TargetPlugin/ProjectDescriptionHelpers/Dependencies.swift"
drift=0

if [ ! -f "$GENERATED" ]; then
  echo "  ✗ 생성된 선언이 없습니다 — 'cd Package && swift run SyncModules' 를 먼저 도세요"
  exit 1
fi

for dir in Projects/*/*/; do
  layer=$(basename "$(dirname "$dir")")
  name=$(basename "$dir")
  [ "$layer" = "App" ] && continue

  # 1) 빌드에 올라가려면 Project.swift 가 있어야 합니다.
  if [ ! -f "${dir}Project.swift" ]; then
    echo "  ✗ ${layer}/${name} — Project.swift 가 없습니다 (빌드에서 빠집니다)"
    drift=1
  fi

  # 2) 스캐너가 잡았는지. 못 잡았다면 슬롯 디렉터리(Sources 등)가 없는 것입니다.
  if ! grep -q "module: \.$(echo "${name:0:1}" | tr '[:upper:]' '[:lower:]')${name:1}," "$GENERATED"; then
    echo "  ✗ ${layer}/${name} — 스캐너가 못 찾았습니다 (Sources 디렉터리를 확인하세요)"
    drift=1
  fi

  # 3) 의존성은 생성되지 않습니다. 비어 있으면 알려만 줍니다.
  lower="$(echo "${name:0:1}" | tr '[:upper:]' '[:lower:]')${name:1}"
  if ! grep -q "case \.${lower}:" "$DEPENDENCIES"; then
    echo "  ! ${layer}/${name} — 의존성이 비어 있습니다 (${DEPENDENCIES})"
  fi

  # 4) 소스가 없는 껍데기 디렉터리
  if [ -z "$(find "$dir" -name '*.swift' -not -name 'Project.swift' -print -quit)" ]; then
    echo "  ! ${layer}/${name} — Swift 소스가 없습니다"
  fi
done

# Package/ 쪽 — Project.swift 대신 Package.swift 선언을 봅니다.
for dir in Package/*/*/; do
  layer=$(basename "$(dirname "$dir")")
  name=$(basename "$dir")

  if ! grep -q "\"${layer}/${name}\"" Package/Package.swift; then
    echo "  ✗ Package ${layer}/${name} — Package.swift 에 선언이 없습니다"
    drift=1
  fi
done

# UIKit 이 패키지에 섞이면 swift test 가 macOS 에서 깨집니다.
if grep -rq "^import UIKit" Package --include='*.swift'; then
  echo "  ✗ Package/ 에 UIKit import 가 있습니다 — swift test 가 깨집니다"
  grep -rl "^import UIKit" Package --include='*.swift' | sed 's/^/      /'
  drift=1
fi

if [ "$drift" -eq 0 ]; then
  target_count=$(grep -c "\.init(root:" "$GENERATED")
  module_count=$(grep -c "^  case " "$GENERATED")
  echo "  모듈 ${module_count}개 · 타깃 ${target_count}개 — 디스크에서 생성했습니다."
else
  echo
  echo "  선언이 어긋났습니다. 위 항목을 고치고 다시 도세요."
fi
exit $drift
