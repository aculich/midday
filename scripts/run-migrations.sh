#!/usr/bin/env sh
# Run Drizzle migrations for local dev. Requires DATABASE_SESSION_POOLER in apps/api/.env.
# Run from repo root after ./scripts/setup-local-env.sh and after setting Supabase DB URL.

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ ! -f apps/api/.env ]; then
  echo "Run ./scripts/setup-local-env.sh first and set DATABASE_SESSION_POOLER in apps/api/.env" >&2
  exit 1
fi

# Load API .env so DATABASE_SESSION_POOLER is available for drizzle.config.ts
set -a
# shellcheck source=/dev/null
. ./apps/api/.env
set +a

if [ -z "$DATABASE_SESSION_POOLER" ]; then
  echo "Set DATABASE_SESSION_POOLER in apps/api/.env (Supabase Session pooler URL)" >&2
  exit 1
fi

cd packages/db && bunx drizzle-kit push
echo "Migrations done."
