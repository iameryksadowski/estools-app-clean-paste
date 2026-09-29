#!/bin/sh
# ES Tools Clean Paste app: build the CLI and check JavaScriptCore against the TypeScript converter.
set -eu
cd "$(dirname "$0")/.."
swift build --product cleanpaste >/dev/null
exec node --disable-warning=MODULE_TYPELESS_PACKAGE_JSON --disable-warning=ExperimentalWarning --test tests/*.test.ts
