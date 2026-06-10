SHELL := /usr/bin/env bash

APP ?= goneat
VERSION ?=
SOURCE ?= --github

.PHONY: check update update-goneat update-dimlox update-sumpter release

check:
	@./scripts/validate-manifests.sh
	@shellcheck scripts/*.sh
	@shfmt -d scripts/*.sh
	@echo "All checks passed"

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

update-dimlox:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "ERROR: VERSION is required"; \
		echo "Usage: make update-dimlox VERSION=0.1.0 [SOURCE=--github|--local]"; \
		exit 1; \
	fi
	@./scripts/update-manifest.sh dimlox "$(VERSION)" "$(SOURCE)"

update-sumpter:
	@if [[ -z "$(VERSION)" ]]; then \
		echo "ERROR: VERSION is required"; \
		echo "Usage: make update-sumpter VERSION=0.1.10 [SOURCE=--github|--local]"; \
		exit 1; \
	fi
	@./scripts/update-manifest.sh sumpter "$(VERSION)" "$(SOURCE)"

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
