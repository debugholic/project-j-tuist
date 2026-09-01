DESTINATION ?= platform=iOS Simulator,name=iPhone 17 Pro
SCHEMES = FeatureTripExample FeatureReservationExample FeatureItineraryExample

.PHONY: generate sync open clean test test-package test-app module help

# clone 직후 진입점. 로컬 플러그인 4개를 먼저 해석해야 매니페스트가 컴파일됩니다.
generate:
	tuist install
	$(MAKE) sync
	tuist generate --no-open

# 디렉터리 구조를 읽어 모듈·타깃 선언을 생성하고, 남은 어긋남을 검사합니다.
# 진실의 원천은 디스크입니다 — 손으로 적는 것은 의존성 그래프뿐입니다.
sync:
	@cd Package && swift run -q SyncModules
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
	rm -rf Package/.build
	rm -rf Plugins/TargetPlugin/ProjectDescriptionHelpers/.generated

# Package/ 는 UIKit 이 없어 시뮬레이터 없이 돕니다. 나머지는 스킴으로 돌립니다.
test: test-package test-app

test-package:
	@echo "──────── Package (swift test) ────────"
	@cd Package && swift test

test-app:
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
	@echo "sync      디렉터리에서 모듈·타깃 선언을 생성하고 검사"
	@echo "open      generate 후 Xcode 로 엽니다"
	@echo "clean     생성물(.xcodeproj · .xcworkspace · Derived)만 삭제"
	@echo "test      패키지(swift test) + 앱 스킴 테스트"
	@echo "module    모듈 뼈대 생성 — make module NAME=Payment LAYER=Feature"
