# fulmenhq/scoop-bucket

[![checks](https://github.com/fulmenhq/scoop-bucket/actions/workflows/ci.yml/badge.svg)](https://github.com/fulmenhq/scoop-bucket/actions/workflows/ci.yml)

Scoop bucket for FulmenHQ CLI tools.

## Usage

```powershell
scoop bucket add fulmenhq https://github.com/fulmenhq/scoop-bucket
scoop install goneat
scoop install dimlox
scoop install refbolt
scoop install sumpter
```

## Available tools

| Tool | Description |
| --- | --- |
| [dimlox](https://github.com/fulmenhq/dimlox) | Moving and shaping structured data across the clouds |
| [goneat](https://github.com/fulmenhq/goneat) | One CLI to orchestrate code quality across your polyglot codebase |
| [refbolt](https://github.com/fulmenhq/refbolt) | Archive web documentation into date-versioned Markdown trees |
| [sumpter](https://github.com/fulmenhq/sumpter) | Streaming XML extraction engine for large, variant-heavy inputs |

## Update

```powershell
scoop update goneat
scoop update dimlox
scoop update refbolt
scoop update sumpter
```

## Maintainers

Manifests live in `bucket/`. Update one from a published GitHub release and validate before committing:

```bash
make update-sumpter VERSION=0.1.10   # or: make update APP=<tool> VERSION=<x.y.z>
make check                           # validate manifests + shellcheck/shfmt scripts
```

`make check` runs in CI (`.github/workflows/ci.yml`) on every push and pull request; `scripts/validate-manifests.sh` asserts each manifest is well-formed JSON with required fields, sha256-shaped hashes, and version-matching download URLs.

## License

Apache-2.0
