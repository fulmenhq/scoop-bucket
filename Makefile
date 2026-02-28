SHELL := /usr/bin/env bash

APP ?= goneat
VERSION ?=
SOURCE ?= --github

.PHONY: update update-goneat release

update:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "ERROR: VERSION is required"; \
		echo "Usage: make update APP=goneat VERSION=0.5.7 [SOURCE=--github|--local]"; \
		exit 1; \
	fi
	@./scripts/update-manifest.sh "$(APP)" "$(VERSION)" "$(SOURCE)"

update-goneat:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "ERROR: VERSION is required"; \
		echo "Usage: make update-goneat VERSION=0.5.7 [SOURCE=--github|--local]"; \
		exit 1; \
	fi
	@./scripts/update-manifest.sh goneat "$(VERSION)" "$(SOURCE)"

release:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "ERROR: VERSION is required"; \
		echo "Usage: make release APP=goneat VERSION=0.5.7 [SOURCE=--github|--local]"; \
		exit 1; \
	fi
	@$(MAKE) update APP="$(APP)" VERSION="$(VERSION)" SOURCE="$(SOURCE)"
	@git add "bucket/$(APP).json"
	@git commit -m "chore(bucket): update $(APP) to v$(VERSION)"
	@git push origin main
