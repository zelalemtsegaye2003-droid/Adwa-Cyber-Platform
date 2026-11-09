/**
 * Adwa Cyber — production bootstrap: create the first platform SUPER_ADMIN.
 *
 * Use this INSTEAD of scripts/seed-users.ts on any real deployment. The demo
 * seed creates accounts with passwords that are published in the README.
 *
 *   ADMIN_EMAIL=you@example.org ADMIN_PASSWORD='<strong passphrase>' \
 *   ADMIN_NAME='Jane Doe' bun scripts/bootstrap-admin.ts
 *
 * Behaviour:
 *  - Refuses weak passwords (>=14 chars, mixed case, digit, symbol, not a
 *    common password, not one of the published demo passwords).
 *  - Idempotent: if a SUPER_ADMIN already exists, it changes nothing.
 *  - Disables any leftover demo accounts (known demo emails) and revokes their
 *    sessions. Pass --keep-demo to skip that.
 *  - Never prints the password.
 */
import { PrismaClient } from "@prisma/client";
import { hashPassword } from "../src/lib/auth/crypto";
import { isCommonPassword } from "../src/lib/auth/passwords";

const db = new PrismaClient();

// Credentials published in the repo README / seed-users.ts — never acceptable.
const PUBLISHED_PASSWORDS = new Set(["Adwa#Admin2026!", "Adwa#Demo2026!"]);

const DEMO_EMAILS = [
  "admin@adwacyber.et",
  "admin@cbe.com.et",
  "officer@cbe.com.et",
  "auditor@dashen.com.et",
  "viewer@ethiotelecom.et",
  "admin@wasasa.et",
];

function fail(message: string): never {
  console.error(`✗ ${message}`);
  process.exit(1);
}

function validatePassword(password: string): string | null {
  if (password.length < 14) return "ADMIN_PASSWORD must be at least 14 characters.";
  if (password.length > 200) return "ADMIN_PASSWORD must be at most 200 characters.";
  if (!/[a-z]/.test(password)) return "ADMIN_PASSWORD must contain a lowercase letter.";
  if (!/[A-Z]/.test(password)) return "ADMIN_PASSWORD must contain an uppercase letter.";
  if (!/[0-9]/.test(password)) return "ADMIN_PASSWORD must contain a digit.";
  if (!/[^a-zA-Z0-9]/.test(password)) return "ADMIN_PASSWORD must contain a symbol.";
  if (isCommonPassword(password) || PUBLISHED_PASSWORDS.has(password)) {
    return "ADMIN_PASSWORD is a common or published password.";
  }
  return null;
}

async function disableDemoAccounts() {
  const now = new Date();
  const res = await db.user.updateMany({
    where: { email: { in: DEMO_EMAILS }, status: { not: "DISABLED" } },
    data: { status: "DISABLED", sessionsRevokedAt: now },
  });
  if (res.count > 0) {
    await db.refreshToken.updateMany({
      where: { user: { email: { in: DEMO_EMAILS } }, revokedAt: null },
      data: { revokedAt: now },
    });
    console.log(`✓ Disabled ${res.count} leftover demo account(s) and revoked their sessions.`);
  }
}

async function main() {
  const keepDemo = process.argv.includes("--keep-demo");

  const existing = await db.user.findFirst({ where: { role: "SUPER_ADMIN", status: "ACTIVE" } });
  if (existing && !DEMO_EMAILS.includes(existing.email)) {
    console.log(`• A SUPER_ADMIN already exists (${existing.email}). Nothing to do.`);
    if (!keepDemo) await disableDemoAccounts();
    return;
  }

  const email = (process.env.ADMIN_EMAIL ?? "").trim().toLowerCase();
  const password = process.env.ADMIN_PASSWORD ?? "";
  const name = (process.env.ADMIN_NAME ?? "Platform Administrator").trim();

  if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email) || email.length > 254) {
    fail("ADMIN_EMAIL is missing or not a valid email address.");
  }
  if (DEMO_EMAILS.includes(email)) fail("ADMIN_EMAIL must not be one of the demo account emails.");
  if (name.length < 2 || name.length > 100) fail("ADMIN_NAME must be 2–100 characters.");
  const problem = validatePassword(password);
  if (problem) fail(problem);

  const taken = await db.user.findUnique({ where: { email } });
  if (taken) fail(`A user with email ${email} already exists. Choose a different ADMIN_EMAIL.`);

  const user = await db.user.create({
    data: {
      email,
      name,
      passwordHash: hashPassword(password),
      role: "SUPER_ADMIN",
      organizationId: null,
      authProvider: "LOCAL",
    },
  });

  await db.authEvent.create({
    data: {
      type: "USER_CREATED",
      userId: user.id,
      email: user.email,
      detail: "SUPER_ADMIN created by scripts/bootstrap-admin.ts.",
    },
  });

  console.log(`✓ Created SUPER_ADMIN ${email}`);
  console.log("  Next: sign in and enable MFA for this account immediately.");

  if (!keepDemo) await disableDemoAccounts();
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => db.$disconnect());
