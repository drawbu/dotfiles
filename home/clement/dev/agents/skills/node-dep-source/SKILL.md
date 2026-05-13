---
name: node-dep-source
description: "Clone a JS/TS dependency's original source at the pinned version into /tmp for richer inspection than node_modules. Use when: (1) Reading the source of an installed npm/pnpm/yarn dependency, (2) Tracing how a package actually works behind its bundled API, (3) Looking at tests, examples, in-source typedoc comments, or files stripped from the published tarball, (4) Wanting to grep a dependency without going through the bundled/minified node_modules copy"
---

# node-dep-source

Pulls the *original source repository* of a JS/TS dependency at the version pinned in this project, into a `/tmp` cache. Prefer this over grepping `node_modules` — published packages are usually bundled, minified, comment-stripped, and missing tests/examples.

## When to reach for this

- Investigating a bug or understanding behavior of an npm dependency.
- Looking for examples or tests that the bundler removed.
- Reading TSDoc/JSDoc comments dropped during build.
- Confirming what an internal helper does inside a monorepo dependency (e.g. `@tanstack/router` lives in `packages/router` of `tanstack/router`).

## Usage

From the project root (the directory whose `node_modules` contains the package), run:

```bash
~/.agents/skills/node-dep-source/clone-dep.ts <package-name> [version]
```

- The script prints the directory to inspect on **stdout**.
- All progress logging goes to **stderr**.
- For monorepo packages, the printed path descends into `repository.directory` automatically.

Examples:

```bash
~/.agents/skills/node-dep-source/clone-dep.ts @tanstack/solid-router
# → /tmp/claude-deps/@tanstack__solid-router@1.x.y/packages/solid-router

~/.agents/skills/node-dep-source/clone-dep.ts prisma 6.0.1
# → /tmp/claude-deps/prisma@6.0.1
```

After it returns, grep / read freely under that path. The cache is keyed by `<pkg>@<version>`, so re-runs in the same session (or across sessions) are instant.

## Resolution pipeline

1. **Version**: from `node_modules/<pkg>/package.json#version`. Falls back to `pnpm view <pkg> version` if not installed.
2. **Repository URL**: same `package.json#repository.url`, fallback `pnpm view <pkg>@<version> repository.url`. Normalizes `git+`, `git://`, `git@github.com:`, `github:` shorthands, strips trailing `.git`.
3. **Tag matching**: `git ls-remote --tags <url>` and intersect with candidate patterns:
   - `vX.Y.Z`, `X.Y.Z`
   - `<pkg>@X.Y.Z`, `<pkg-base>@X.Y.Z` (for monorepos using changesets-style tags)
   - `<pkg-base>-vX.Y.Z`, `<pkg-base>-X.Y.Z`
   - `release-X.Y.Z`, `release/X.Y.Z`
4. **Clone**: `git clone --depth=1 --single-branch --branch <tag> <url> <cache-dir>`.
5. **Tarball fallback**: if no tag matches (or no `repository` at all), `pnpm pack <pkg>@<version>` and unpack. A marker file `.from-tarball` is dropped so subsequent calls hit the cache. Note: the tarball is the *published* artifact — same caveats as node_modules — but it's at least pinned and won't get nuked by `pnpm install`.

## Cache layout

```
/tmp/claude-deps/
  @tanstack__solid-router@1.50.0/   (full clone)
  prisma@6.0.1/                     (.from-tarball marker)
```

Override location with `CLAUDE_DEPS_CACHE=/some/path`.

## What NOT to do

- Don't modify the cache. Treat it as read-only reference material.
- Don't commit anything from `/tmp/claude-deps/` into the project.
- Don't `cd` into it for shell tasks; just use it as a read target.
- Don't reach for this for trivial lookups where `node_modules/<pkg>/dist/...` is enough — clone has a one-time network cost.

## Out of scope

- Private packages / non-public registries (skill assumes the repo is publicly clonable).
- Packages that genuinely have no published source repo (very rare; will fall back to tarball).
