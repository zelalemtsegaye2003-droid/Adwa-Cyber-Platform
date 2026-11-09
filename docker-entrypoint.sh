#!/bin/sh
set -e

# Apply the schema. `prisma db push` WITHOUT --accept-data-loss refuses any
# change that would drop data, so a bad deploy fails loudly instead of
# silently deleting columns. (Replace with `prisma migrate deploy` once the
# project moves to committed migrations.)
echo "[entrypoint] syncing database schema..."
bun run db:push

echo "[entrypoint] starting server on ${HOSTNAME:-0.0.0.0}:${PORT:-3000}"
exec bun .next/standalone/server.js
