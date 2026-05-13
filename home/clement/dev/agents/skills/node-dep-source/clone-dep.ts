#!/usr/bin/env -S deno run --allow-all

import { join, resolve } from "jsr:@std/path";

const USAGE = "usage: clone-dep.ts <package-name> [version]";

const [pkg, explicitVersion] = Deno.args;
if (!pkg) {
  console.error(USAGE);
  Deno.exit(64);
}

const cacheRoot = Deno.env.get("CLAUDE_DEPS_CACHE") ?? "/tmp/claude-deps";
Deno.mkdirSync(cacheRoot, { recursive: true });

const log = (...args: unknown[]) => console.error("[dep-source]", ...args);

const GIT_ENV = { GIT_CONFIG_NOSYSTEM: "1", GIT_CONFIG_GLOBAL: "/dev/null" };

interface PackageJson {
  version: string;
  repository?: string | { url?: string; directory?: string };
}

interface Metadata {
  version: string;
  repoUrl: string;
  repoDir: string;
}

function fileExists(path: string): boolean {
  try {
    Deno.statSync(path);
    return true;
  } catch {
    return false;
  }
}

function capture(
  cmd: string,
  args: string[],
  extraEnv?: Record<string, string>,
): { code: number; out: string } {
  const { code, stdout } = new Deno.Command(cmd, {
    args,
    stdin: "null",
    stdout: "piped",
    stderr: "inherit",
    env: extraEnv,
  }).outputSync();
  return { code, out: new TextDecoder().decode(stdout).trim() };
}

function run(
  cmd: string,
  args: string[],
  extraEnv?: Record<string, string>,
): number {
  return new Deno.Command(cmd, {
    args,
    stdin: "null",
    stdout: "inherit",
    stderr: "inherit",
    env: extraEnv,
  }).outputSync().code;
}

function pnpmView(spec: string, field: string): string {
  const { code, out } = capture("pnpm", ["view", spec, field]);
  return code === 0 ? out : "";
}

function readLocalPkgJson(name: string): PackageJson | null {
  const path = resolve("node_modules", name, "package.json");
  if (!fileExists(path)) return null;
  try {
    return JSON.parse(Deno.readTextFileSync(path)) as PackageJson;
  } catch {
    return null;
  }
}

function normalizeRepoUrl(raw: string): string {
  let url = raw;
  if (url.startsWith("github:")) url = `https://github.com/${url.slice(7)}`;
  return url
    .replace(/^git\+/, "")
    .replace(/^git:\/\//, "https://")
    .replace(/^ssh:\/\/git@github\.com\//, "https://github.com/")
    .replace(/^git@github\.com:/, "https://github.com/")
    .replace(/\.git$/, "");
}

function resolveMetadata(): Metadata {
  if (!explicitVersion) {
    const local = readLocalPkgJson(pkg);
    if (local) {
      const r = local.repository;
      return {
        version: local.version,
        repoUrl: typeof r === "string" ? r : (r?.url ?? ""),
        repoDir: typeof r === "object" && r !== null ? (r.directory ?? "") : "",
      };
    }
    log(`no node_modules/${pkg}/package.json; falling back to pnpm view`);
  }
  const version = explicitVersion ?? pnpmView(pkg, "version");
  if (!version) {
    log(`could not determine version of ${pkg}`);
    Deno.exit(2);
  }
  const spec = `${pkg}@${version}`;
  return {
    version,
    repoUrl: pnpmView(spec, "repository.url") || pnpmView(spec, "repository"),
    repoDir: pnpmView(spec, "repository.directory"),
  };
}

function tarballFallback(dest: string, version: string): void {
  try {
    Deno.removeSync(dest, { recursive: true });
  } catch (e) {
    if (!(e instanceof Deno.errors.NotFound)) throw e;
  }
  Deno.mkdirSync(dest, { recursive: true });

  const tmp = Deno.makeTempDirSync({ prefix: "dep-source-" });
  try {
    const packCode = run("pnpm", ["pack", `${pkg}@${version}`, "--pack-destination", tmp]);
    if (packCode !== 0) {
      log("pnpm pack failed");
      Deno.exit(1);
    }

    const tgz = [...Deno.readDirSync(tmp)].find((e) => e.name.endsWith(".tgz"))?.name;
    if (!tgz) {
      log("no tarball produced by pnpm pack");
      Deno.exit(1);
    }

    const tarCode = run("tar", ["-xzf", join(tmp, tgz), "-C", dest, "--strip-components=1"]);
    if (tarCode !== 0) {
      log("tar extract failed");
      Deno.exit(1);
    }

    Deno.writeTextFileSync(join(dest, ".from-tarball"), "");
    log(`extracted tarball into ${dest}`);
  } finally {
    Deno.removeSync(tmp, { recursive: true });
  }
}

// --- main ---

const { version, repoDir, repoUrl: rawRepoUrl } = resolveMetadata();
const repoUrl = normalizeRepoUrl(rawRepoUrl);

const safeName = pkg.replaceAll("/", "__");
const dest = join(cacheRoot, `${safeName}@${version}`);

function printResult(): void {
  const sub = join(dest, repoDir);
  console.log(repoDir && fileExists(sub) ? sub : dest);
}

if ([join(dest, ".git"), join(dest, ".from-tarball")].some(fileExists)) {
  log(`cache hit: ${dest}`);
  printResult();
  Deno.exit(0);
}

if (!repoUrl) {
  log(`no repository field for ${pkg}; using tarball fallback`);
  tarballFallback(dest, version);
  printResult();
  Deno.exit(0);
}

const { code: lsCode, out: lsOut } = capture("git", ["ls-remote", "--tags", repoUrl], GIT_ENV);
if (lsCode !== 0) {
  log(`git ls-remote failed for ${repoUrl}; using tarball fallback`);
  tarballFallback(dest, version);
  printResult();
  Deno.exit(0);
}

const tags = new Set(
  lsOut
    .split("\n")
    .map((line) => line.split(/\s+/)[1] ?? "")
    .filter(Boolean)
    .map((ref) => ref.replace(/^refs\/tags\//, "").replace(/\^\{\}$/, "")),
);

const base = pkg.split("/").pop()!;
const candidates = [
  `v${version}`,
  version,
  `${pkg}@${version}`,
  `${base}@${version}`,
  `${base}-v${version}`,
  `${base}-${version}`,
  `release-${version}`,
  `release/${version}`,
];

const tag = candidates.find((c) => tags.has(c));
if (!tag) {
  log(`no matching tag for ${pkg}@${version} (tried: ${candidates.join(", ")}); using tarball fallback`);
  tarballFallback(dest, version);
  printResult();
  Deno.exit(0);
}

log(`cloning ${repoUrl} at ${tag}`);
const cloneCode = run(
  "git",
  ["clone", "--depth=1", "--single-branch", "--branch", tag, repoUrl, dest],
  GIT_ENV,
);
if (cloneCode !== 0) {
  log("git clone failed; using tarball fallback");
  tarballFallback(dest, version);
}

printResult();
