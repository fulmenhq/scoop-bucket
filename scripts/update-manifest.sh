#!/usr/bin/env bash
set -euo pipefail

usage() {
	echo "Usage: $0 <app-name> <version> [--github|--local]" >&2
	echo "Example: $0 goneat 0.5.7" >&2
}

require_cmd() {
	local command_name="$1"
	if ! command -v "$command_name" >/dev/null 2>&1; then
		echo "ERROR: required command not found: $command_name" >&2
		exit 1
	fi
}

if [[ $# -lt 2 || $# -gt 3 ]]; then
	usage
	exit 1
fi

APP_NAME="$1"
VERSION="${2#v}"
SOURCE="${3:---github}"

case "$SOURCE" in
--github | --local) ;;
*)
	echo "ERROR: invalid source '$SOURCE' (expected --github or --local)" >&2
	usage
	exit 1
	;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST_PATH="${REPO_ROOT}/bucket/${APP_NAME}.json"

if [[ ! -f "$MANIFEST_PATH" ]]; then
	echo "ERROR: manifest not found: $MANIFEST_PATH" >&2
	exit 1
fi

require_cmd jq
if [[ "$SOURCE" == "--github" ]]; then
	require_cmd gh
fi

TEMP_SUMS="$(mktemp -t "${APP_NAME}-sha256.XXXXXX")"
TEMP_MANIFEST="$(mktemp -t "${APP_NAME}-manifest.XXXXXX")"
trap 'rm -f "$TEMP_SUMS" "$TEMP_MANIFEST"' EXIT

if [[ "$SOURCE" == "--local" ]]; then
	LOCAL_SUMS_PATH="${REPO_ROOT}/../${APP_NAME}/dist/release/SHA256SUMS"
	if [[ ! -f "$LOCAL_SUMS_PATH" ]]; then
		echo "ERROR: local SHA256SUMS not found: $LOCAL_SUMS_PATH" >&2
		exit 1
	fi
	cp "$LOCAL_SUMS_PATH" "$TEMP_SUMS"
else
	gh release download "v${VERSION}" \
		--repo "fulmenhq/${APP_NAME}" \
		--pattern SHA256SUMS \
		--output "$TEMP_SUMS" \
		--clobber
fi

TARGET_ARCHIVE="${APP_NAME}_v${VERSION}_windows_amd64.zip"
WIN_HASH="$(awk -v target="$TARGET_ARCHIVE" '$2 == target {print $1}' "$TEMP_SUMS")"

if [[ -z "$WIN_HASH" ]]; then
	echo "ERROR: could not find ${TARGET_ARCHIVE} hash in SHA256SUMS" >&2
	exit 1
fi

DOWNLOAD_URL="https://github.com/fulmenhq/${APP_NAME}/releases/download/v${VERSION}/${TARGET_ARCHIVE}"

jq \
	--arg version "$VERSION" \
	--arg url "$DOWNLOAD_URL" \
	--arg hash "$WIN_HASH" \
	'.version = $version
	| .architecture."64bit".url = $url
	| .architecture."64bit".hash = $hash' \
	"$MANIFEST_PATH" >"$TEMP_MANIFEST"

mv "$TEMP_MANIFEST" "$MANIFEST_PATH"

echo "Updated ${MANIFEST_PATH}"
echo "  version: ${VERSION}"
echo "  windows_amd64 hash: ${WIN_HASH}"
