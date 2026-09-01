DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro
SCHEMES = App FeatureTripExample FeatureReservationExample FeatureItineraryExample

.PHONY: generate sync open clean test module help

# clone 직후 진입점. 로컬 플러그인 4개를 먼저 해석해야 매니페스트가 컴파일됩니다.
generate:
	tuist install
	$(MAKE) sync
	tuist generate --no-open

# 디스크의 모듈과 매니페스트 선언이 어긋났는지 검사합니다.
# make module 이 디렉터리만 찍고 선언은 손으로 넣어야 해서, 그 누락을 잡습니다.
sync:
	@./Scripts/sync.sh

open:
	tuist install
	$(MAKE) sync
	tuist generate

# 생성물만 지웁니다. 소스와 매니페스트는 건드리지 않습니다.
clean:
	tuist clean
	find . -name '*.xcodeproj' -maxdepth 3 -exec rm -rf {} +
	find . -name 'Derived' -maxdepth 3 -type d -exec rm -rf {} +
	rm -rf ProjectJ.xcworkspace Tuist/Plugins

test:
	@for scheme in $(SCHEMES); do \
		echo "──────── $$scheme ────────"; \
		xcodebuild test -workspace ProjectJ.xcworkspace \
			-scheme $$scheme -destination '$(DESTINATION)' \
			| grep -E "error:|Executed .* tests|TEST (SUCCEEDED|FAILED)" || exit 1; \
	done

# make module NAME=Payment LAYER=Feature
module:
	@test -n "$(NAME)" || (echo "NAME 이 필요합니다 — 예: make module NAME=Payment LAYER=Feature"; exit 1)
	tuist scaffold Module --name $(NAME) --layer $(or $(LAYER),Feature)
	@echo "의존성은 Plugins/TargetPlugin/ProjectDescriptionHelpers/Module.swift 에 추가하세요."

help:
	@echo "generate  플러그인 해석 + sync + 프로젝트 생성 (clone 직후 이것부터)"
	@echo "sync      디스크의 모듈과 매니페스트 선언이 맞는지 검사"
	@echo "open      generate 후 Xcode 로 엽니다"
	@echo "clean     생성물(.xcodeproj · .xcworkspace · Derived)만 삭제"
	@echo "test      스킴 4개 테스트 실행"
	@echo "module    모듈 뼈대 생성 — make module NAME=Payment LAYER=Feature"
