# syntax=docker/dockerfile:1
#
# Production image for the Adwa Cyber platform (Next.js standalone + Bun).
# NOTE: written without a local Docker daemon to test against — build it once in
# CI / on the target host and fix anything environment-specific before relying on it.

ARG BUN_VERSION=1

# ── 1. dependencies ──────────────────────────────────────────────────────────
FROM oven/bun:${BUN_VERSION} AS deps
WORKDIR /app
COPY package.json bun.lock ./
RUN bun install --frozen-lockfile

# ── 2. build ─────────────────────────────────────────────────────────────────
FROM oven/bun:${BUN_VERSION} AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
# The build never touches a real database; this only satisfies Prisma's env check.
ENV DATABASE_URL="file:/tmp/build.db" \
    NEXT_TELEMETRY_DISABLED=1
RUN bunx prisma generate && bun run build

# ── 3. runtime ───────────────────────────────────────────────────────────────
FROM oven/bun:${BUN_VERSION} AS runtime
WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production \
    NEXT_TELEMETRY_DISABLED=1 \
    HOSTNAME=0.0.0.0 \
    PORT=3000 \
    DATABASE_URL="file:/data/adwa.db" \
    DATA_DIR=/data

# Full tree (not just .next/standalone): the entrypoint needs the Prisma CLI and
# schema, and operators run prisma/seed.ts + scripts/bootstrap-admin.ts via
# `docker compose exec`.
COPY --from=build /app /app
# PDF reports read fonts relative to the standalone server's working directory.
COPY --from=build /app/src/assets /app/.next/standalone/src/assets

RUN chmod +x /app/docker-entrypoint.sh \
    && mkdir -p /data \
    && chown -R bun:bun /data /app
USER bun

VOLUME ["/data"]
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD bun -e "fetch('http://127.0.0.1:3000/api/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

ENTRYPOINT ["/app/docker-entrypoint.sh"]
