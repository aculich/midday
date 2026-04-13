# Fork sync status — midday-ai/midday → aculich/midday

**Report generated:** 2026-04-13 (after rebasing local clone onto upstream and establishing fork remotes.)

## Summary

| Item | Value |
| ---- | ----- |
| **Previous local HEAD** | `c3fc95bc3` — 2026-02-12 (`Feature/invoice email (#764)`) |
| **Current upstream / local `main`** | `3af204ad4` — 2026-04-07 |
| **Commits integrated since previous HEAD** | **187** (`git rev-list --count c3fc95bc3..HEAD`) |
| **Diff scope (c3fc95bc3..HEAD)** | **1499 files**, ~90.7k insertions, ~69.9k deletions |

This catch-up closed roughly **two months** of upstream activity (Feb 12 → Apr 7 on `main`).

## Upstream themes (high level)

Not exhaustive; useful for orienting after a large fast-forward/rebase:

- **Assistant / chat** — tool selection, cache invalidation, Composio limits, persistence/UX, overview chat and reports.
- **MCP** — invoice template tools, MCP apps, download support, parameter/performance work.
- **Infra & data** — Upstash multi-region Redis for cache, pooling/DB-related updates, worker DB paths.
- **Security & correctness** — SSRF/logo URL validation, CodeQL-related fixes, transaction validation, nuqs scoping, runway calculation (median of 3 completed months).
- **Product** — trial cancellation flow, pricing, website agents/branding, matching pipeline (V2 deterministic inbox matching — see updated `docs/inbox-matching.md` description).
- **Integrations / enrichment** — CompanyEnrich API replacing prior AI enrichment pipeline in places; engine/API and OpenAPI/SDK-related fixes.
- **Tooling** — Biome in CLI package, Docker entrypoint script, dependency bumps.

## Conflict assessment (local fork work vs upstream)

During stash replay onto rebased `develop`, **`docs/README.md` auto-merged** successfully:

- Kept upstream’s updated **inbox-matching** blurb (V2 deterministic matching).
- Kept fork addition: **`local-development.md`** index line.

**`README.md`** — upstream had not diverged on the “Get started” section in a conflicting way; fork **local development** bullet merged cleanly.

**`scripts/`** — upstream added e.g. `scripts/docker-entrypoint.sh`; fork added **`setup-local-env.sh`** and **`run-migrations.sh`** (no filename collision).

## Fork-only artifacts (this workspace)

Committed on **`develop`** after sync (see git history):

- [docs/local-development.md](docs/local-development.md) — Option A/B local runbook.
- [scripts/setup-local-env.sh](scripts/setup-local-env.sh) — `.env` scaffolding from templates.
- [scripts/run-migrations.sh](scripts/run-migrations.sh) — Drizzle push via `packages/db`.
- [README.md](README.md) — pointer to local-development doc and scripts.
- [docs/README.md](docs/README.md) — index entry for `local-development.md`.
- [WORKFLOW.md](WORKFLOW.md) — fork/upstream/git procedure.
- [sync](sync) — daily `fetch` + mirror `main` + `rebase develop`.
- **STATUS.md** (this file) — snapshot of the catch-up.

## Remotes (reference)

| Remote | Purpose |
| ------ | ------- |
| `upstream` | `midday-ai/midday` — fetch only (`push` URL disabled locally) |
| `origin` | `aculich/midday` — your fork |

## Next steps

1. Run **`./sync`** periodically; then **`git push origin develop --force-with-lease`** when history was rewritten.
2. Keep **`origin/main`** a mirror of **`upstream/main`** via `./sync` (or the manual two-liner in [WORKFLOW.md](WORKFLOW.md)).
3. For upstream contributions, branch from **`upstream/main`**, cherry-pick or port commits from **`develop`**, push to **`origin`**, open PR with **`gh pr create --repo midday-ai/midday`**.
4. Refresh **STATUS.md** after the next large upstream gap (dates, counts, themes) if you want a paper trail.

## Commands used for this catch-up (replay)

```sh
gh repo fork midday-ai/midday --clone=false --remote=false
git remote rename origin upstream
git remote add origin https://github.com/aculich/midday.git
git remote set-url --push upstream DISABLED
git stash push -u -m "local-dev-docs-and-scripts" -- README.md docs/README.md docs/local-development.md scripts/run-migrations.sh scripts/setup-local-env.sh
git fetch upstream && git checkout main && git rebase upstream/main
git checkout -b develop && git stash pop
git push origin upstream/main:main --force-with-lease
git push -u origin develop
gh repo edit aculich/midday --default-branch develop
```

Then add `sync`, `WORKFLOW.md`, `STATUS.md`, commit, and **`git push origin develop`**.
