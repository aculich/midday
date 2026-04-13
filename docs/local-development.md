# Local development

Minimal ways to run Midday locally after `bun i`.

---

## Option A: Fastest — marketing website only (no backend)

**Goal:** See the site and UI with zero external services.

1. **Start the website app**
   - From repo root: `bun run dev:website`
   - App runs at **http://localhost:3000** ([apps/website/package.json](../apps/website/package.json) uses port 3000).

2. **Env (optional)**  
   [apps/website/.env-template](../apps/website/.env-template) lists Upstash Redis, OpenPanel, Resend — all optional for just viewing the site. You can run without a `.env` or with an empty one; some features (e.g. docs chat, support form) may be no-ops without keys.

**Result:** Marketing/landing site only; no app dashboard, no auth, no API.

---

## Option B: Minimal app — dashboard + API (recommended minimal full stack)

**Goal:** Run the main app (dashboard) and its API locally with the fewest moving parts. Auth and data live in Supabase; background jobs/worker and engine are skipped for now.

### 1. External services (one-time)

- **Supabase (free):** [supabase.com](https://supabase.com) → New project. You will need:
  - **Project URL** and **anon key** (Settings → API)
  - **service_role key** (Settings → API)
  - **JWT secret** (Settings → API → JWT Settings)
  - **Database URL** (Settings → Database): use the **Session pooler** (or Transaction) connection string for Drizzle; the same or “Direct” for the API primary connection.
- **Redis:** Local is enough. From [apps/api/README.md](../apps/api/README.md):
  ```bash
  docker run -d --name redis -p 6379:6379 redis:alpine
  ```

### 2. Environment setup

Run the setup script from the repo root to create `.env` files from templates and set local defaults (you will still need to add your Supabase and DB URLs/keys):

```bash
./scripts/setup-local-env.sh
```

Then edit (use your Supabase project settings):

- **apps/dashboard/.env** — set `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_KEY` (and optionally `NEXT_PUBLIC_SUPABASE_ID`).
- **apps/api/.env** — set `SUPABASE_URL`, `SUPABASE_SERVICE_KEY`, `SUPABASE_JWT_SECRET`, `DATABASE_PRIMARY_URL`, and `DATABASE_SESSION_POOLER` (Supabase Database → Connection string, e.g. Session pooler).

Leave optional vars (Plaid, Teller, Resend, OpenPanel, Engine, etc.) empty for minimal; the app will start and many features will be disabled.

### 3. Database migrations

In **packages/db**, Drizzle uses `DATABASE_SESSION_POOLER` ([packages/db/drizzle.config.ts](../packages/db/drizzle.config.ts)). After setting it in `apps/api/.env`, run from the repo root:

```bash
./scripts/run-migrations.sh
```

Or manually (load API .env then run Drizzle):

```bash
set -a && . apps/api/.env && set +a
cd packages/db && bunx drizzle-kit push
```

(Alternatively use `drizzle-kit migrate` if you prefer migration files; the repo has migrations in `packages/db/migrations/`.)

### 4. Supabase Auth (so login works)

- In Supabase: **Authentication → URL Configuration**
  - **Site URL:** `http://localhost:3001`
  - **Redirect URLs:** add `http://localhost:3001/**`
- Enable at least one provider (e.g. Email) so you can sign up / log in.

### 5. Run the stack

- **Terminal 1 — API:** `bun run dev:api` (port 3003)
- **Terminal 2 — Dashboard:** `bun run dev:dashboard` (port 3001)

Then open **http://localhost:3001**. You should see the login page and, after sign-up/login, the dashboard (with some features disabled until you add keys).

**Not started for minimal:** Engine (port 3002), worker, jobs, desktop app. Add those when you need bank connections, background jobs, etc.

---

## Commands reference (from root)

| Command                 | What runs               | Port     |
| ----------------------- | ----------------------- | -------- |
| `bun run dev:website`   | Marketing site          | 3000     |
| `bun run dev:dashboard` | Next.js app (dashboard) | 3001     |
| `bun run dev:api`       | Hono API (tRPC)         | 3003     |
| `bun run dev:engine`    | Engine (Wrangler)       | 3002     |
| `bun run dev`           | All apps (Turbo)        | multiple |

---

## Summary

- **Fastest path:** `bun run dev:website` → http://localhost:3000 (no env or backend).
- **Minimal app path:** Supabase project + local Redis → run `./scripts/setup-local-env.sh` → fill Supabase/DB vars in dashboard and API `.env` → run migrations → set Supabase Auth URLs → `bun run dev:api` + `bun run dev:dashboard` → http://localhost:3001.
