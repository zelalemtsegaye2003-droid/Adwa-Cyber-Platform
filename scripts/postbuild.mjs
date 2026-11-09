// Post-build step for `output: "standalone"`: copy static assets and /public
// next to the standalone server. Cross-platform replacement for `cp -r`.
import { cpSync, existsSync } from "node:fs";

const copies = [
  [".next/static", ".next/standalone/.next/static"],
  ["public", ".next/standalone/public"],
];

for (const [from, to] of copies) {
  if (!existsSync(from)) {
    console.error(`postbuild: missing ${from} — did \`next build\` succeed?`);
    process.exit(1);
  }
  cpSync(from, to, { recursive: true });
  console.log(`postbuild: copied ${from} -> ${to}`);
}
