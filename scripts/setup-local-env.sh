#!/usr/bin/env sh
# Setup local .env files from templates and set minimal local defaults.
# Run from repo root. Then fill Supabase/DB URLs and keys in apps/dashboard/.env and apps/api/.env.

set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Dashboard: copy template to .env (template already has local URLs and optional vars empty)
if [ -f apps/dashboard/.env-example ]; then
  cp apps/dashboard/.env-example apps/dashboard/.env
  echo "Created apps/dashboard/.env from .env-example"
else
  echo "Missing apps/dashboard/.env-example" >&2
  exit 1
fi

# API: copy template to .env
if [ -f apps/api/.env-template ]; then
  cp apps/api/.env-template apps/api/.env
  echo "Created apps/api/.env from .env-template"
else
  echo "Missing apps/api/.env-template" >&2
  exit 1
fi

# Set local-only defaults in API .env (so user only needs to add Supabase/DB)
# INVOICE_JWT_SECRET and FILE_KEY_SECRET are already in template; ensure INVOICE_JWT_SECRET is set
# Generate MIDDAY_ENCRYPTION_KEY (32-byte hex)
if command -v openssl >/dev/null 2>&1; then
  ENC_KEY=$(openssl rand -hex 32)
  # Portable sed: write to temp then move (works on macOS and Linux)
  sed "s/^INVOICE_JWT_SECRET=$/INVOICE_JWT_SECRET=secret/" apps/api/.env | \
  sed "s/^MIDDAY_ENCRYPTION_KEY=$/MIDDAY_ENCRYPTION_KEY=$ENC_KEY/" > apps/api/.env.tmp
  mv apps/api/.env.tmp apps/api/.env
  echo "Set INVOICE_JWT_SECRET and MIDDAY_ENCRYPTION_KEY in apps/api/.env"
else
  echo "Warning: openssl not found; set MIDDAY_ENCRYPTION_KEY manually (e.g. openssl rand -hex 32)" >&2
fi

echo ""
echo "Next steps:"
echo "  1. Edit apps/dashboard/.env and set: NEXT_PUBLIC_SUPABASE_URL, NEXT_PUBLIC_SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY"
echo "  2. Edit apps/api/.env and set: SUPABASE_URL, SUPABASE_SERVICE_KEY, SUPABASE_JWT_SECRET, DATABASE_PRIMARY_URL, DATABASE_SESSION_POOLER"
echo "  3. Start Redis: docker run -d --name redis -p 6379:6379 redis:alpine"
echo "  4. Run migrations: ./scripts/run-migrations.sh (after setting DATABASE_SESSION_POOLER in apps/api/.env)"
echo "  5. Configure Supabase Auth redirect URLs for http://localhost:3001"
echo "  6. Run: bun run dev:api (terminal 1) and bun run dev:dashboard (terminal 2)"
echo ""
echo "See docs/local-development.md for full details."
