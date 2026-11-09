// Local development PostgreSQL — no Docker or system install required.
//
//   bun run db:dev          # starts Postgres on 127.0.0.1:54329 (Ctrl+C to stop)
//
// Data persists in .data/pg (git-ignored). Matches DATABASE_URL in .env.example:
//   postgresql://postgres:postgres@127.0.0.1:54329/adwa?schema=public
//
// For development ONLY — production uses a real PostgreSQL service
// (see docker-compose.yml).
import EmbeddedPostgres from "embedded-postgres";
import { existsSync } from "node:fs";
import path from "node:path";

const PORT = Number(process.env.DEV_DB_PORT || 54329);
const DB_NAME = "adwa";
const databaseDir = path.join(process.cwd(), ".data", "pg");

const pg = new EmbeddedPostgres({
  databaseDir,
  user: "postgres",
  password: "postgres",
  port: PORT,
  persistent: true,
  autoRehydrateSymlinks: true,
  // The platform stores Amharic (Ethiopic script): the cluster MUST be UTF-8.
  // On Windows initdb otherwise defaults to WIN1252 and inserts fail.
  initdbFlags: ["--encoding=UTF8", "--locale=C"],
  onLog: () => {},
  onError: (e) => console.error("[postgres]", e),
});

if (!existsSync(path.join(databaseDir, "PG_VERSION"))) {
  console.log("Initialising new development cluster in .data/pg …");
  await pg.initialise();
}

await pg.start();
try {
  await pg.createDatabase(DB_NAME);
  console.log(`Created database "${DB_NAME}".`);
} catch {
  // already exists
}

console.log(`PostgreSQL ready: postgresql://postgres:postgres@127.0.0.1:${PORT}/${DB_NAME}`);
console.log("Press Ctrl+C to stop.");

let stopping = false;
async function shutdown() {
  if (stopping) return;
  stopping = true;
  console.log("\nStopping PostgreSQL …");
  try {
    await pg.stop();
  } finally {
    process.exit(0);
  }
}
process.on("SIGINT", shutdown);
process.on("SIGTERM", shutdown);

// Keep the process alive.
setInterval(() => {}, 1 << 30);
