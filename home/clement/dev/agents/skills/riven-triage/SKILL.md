---
name: riven-triage
description: "Diagnose why riven (on rebecca) is not downloading a movie or show. Use when: (1) An item is stuck, missing from Jellyfin, or 'won't download', (2) Riven looks idle or a retry did nothing, (3) Deciding whether the fault is scraping, debrid availability, item state, or config drift"
---

# riven-triage

Riven runs on **rebecca** as rootful podman containers, configured entirely in
`hosts/rebecca/jellyfin.nix`. Library lands in `/mnt/library`, API on `:8080`,
frontend on `:3000` (`riven.drawbu.dev`).

Work the stages in order. Each one rules out a layer, and the log line that
proves it is quoted. Do not skip to a fix — the same symptom ("it won't
download") has four unrelated causes.

## 0. Is it even running

```bash
systemctl is-active podman-riven podman-riven-db podman-riven-frontend jellyfin
systemctl show podman-riven -p ActiveEnterTimestamp -p NRestarts
```

## 1. Read the logs for the title

```bash
journalctl -u podman-riven --since "2 hours ago" --no-pager | grep -i "<title>"
```

Riven logs an item as `Show Name S01E01`. Strip scrape noise to see outcomes:

```bash
journalctl -u podman-riven --since "7 days ago" --no-pager \
  | grep -i "<title>" | grep -vE "torrentio.scrape|rarbg.scrape|Added [0-9]+ new streams"
```

You are looking for a `🔗 DEBRID | Downloaded ...` line. If it is absent, the
item never got past availability.

## 2. Classify the failure signature

| log line | means | do |
|---|---|---|
| `Found N streams` then `Added 5 new streams` | **exactly** 5 every time = `bucket_limit` cap | raise `RIVEN_SCRAPING_BUCKET_LIMIT` (max 20) |
| `No new streams added` on a **Season** | `shared.py` drops torrents with `len(episodes) <= 2`, so a Season can only match a season pack | normal for an airing show — go to §4, do **not** reset |
| `[451] Infringing Torrent` | Real-Debrid blocklist, common on anime | expected; AllDebrid fallback should carry it |
| `Circuit breaker OPEN for realdebrid, trying next service` | fallback engaging | this is the design working, not an error |
| `Invalid response format from AllDebrid` | known upstream bug, see §5 | ignore, cosmetic |
| `Name does not resolve` / `Circuit breaker tripped to OPEN for <x>` | a scraper points at a host that does not exist | config drift, see §6 |
| item reaches `Scraped` but never `Downloaded` | every candidate 451'd **and** uncached on AllDebrid | genuinely not on either debrid yet — no config fixes this |

Aggregate counts to tell content-specific from systemic:

```bash
L=$(journalctl -u podman-riven --since "7 days ago" --no-pager)
grep -c '451.*Infringing' <<<"$L"; grep -c 'using realdebrid' <<<"$L"; grep -c 'using alldebrid' <<<"$L"
```

Other items downloading fine ⇒ the fault is that title, not the pipeline.

## 3. Query the API

Key is root-only. Ask the operator to run it — `sudo` needs a TTY, so prompt
them to use the `!` prefix rather than calling sudo yourself:

```
! sudo grep -oP '^RIVEN_API_KEY=\K.*' /var/lib/opnix/secrets/rivenEnv
```

Then:

```bash
export K='<key>'
A=(-s -H "x-api-key: $K")
B=http://127.0.0.1:8080/api/v1

curl "${A[@]}" "$B/items?search=<title>&limit=50" | jq '.items[]|{id,title,type,state}'
curl "${A[@]}" "$B/items/<id>?media_type=item&extended=true" \
  | jq '{id,title,state,seasons:[.seasons[]?|{id,number,state,episodes:[.episodes[]?|{id,number,state}]}]}'
```

Two quirks that will waste your time:

- `media_type` is **required** and must be `movie` \| `tv` \| `item` — not `show`.
- `ids` in POST bodies must be **strings**: `{"ids":["139"]}`, not `[139]`.

Per-item scrape gate (`scrapers/__init__.py` `should_submit`):

```bash
curl "${A[@]}" "$B/items/<id>?media_type=item&extended=true" \
  | jq '{state,scraped_at,scraped_times,failed_attempts,streams:(.streams|length?)}'
```

`scraped_at: None` + 0 streams ⇒ it is ready and simply is not being submitted.

## 4. The reset trap (airing shows)

**Do not press reset/retry on a show or season that is still airing, and do not
advise it.** Reset sets Show, Season and Episodes all to `Indexed`. In
`state_transition.py` an `Indexed` Show decomposes to Seasons, and an `Indexed`
Season submits *only itself* — never its episodes. Combined with the `<= 2`
episode filter in §2, the season scrape matches nothing and the episodes are
never queued. Repeating it never helps.

The `Ongoing` states visible afterwards are recomputed post-hoc, so the item
tree looks healthy while nothing is scheduled.

Fix — retry the **episode** IDs directly. An `Indexed` Episode is submitted on
its own and skips the Season path entirely:

```bash
curl "${A[@]}" -X POST -H 'content-type: application/json' \
  -d '{"ids":["139","140","141"]}' "$B/items/retry" | jq .
```

Then watch: `journalctl -u podman-riven -f`. Episode scrapes appear within seconds.

Related endpoints: `POST /items/retry_library` procs the scheduler's 24h job on
demand; `POST /items/{id}/streams/reset` clears streams/blacklist for one item.

## 5. Known upstream bugs

The image is pinned in `jellyfin.nix`. Before blaming config, check whether the
pin is actually behind:

```bash
GIT_CONFIG_GLOBAL=/dev/null git clone --filter=blob:none \
  https://github.com/rivenmedia/riven.git local/repos/riven
```

Then read the real code rather than guessing at settings names — every claim in
this skill is checkable there. Settings live in `src/program/settings/models.py`.

As of 2026-08, upstream `main` has been stale since 2026-06-26 and its HEAD is
the commit that **reverted** the AllDebrid response-model fix. "Just go to
latest" is a no-op. See `[[riven-alldebrid-pin]]` in memory.

## 6. Config drift

Env vars are `RIVEN_<PATH>_<KEY>`, uppercased, walking the settings.json tree
(`settings/__init__.py`). `RIVEN_FORCE_ENV=true` only overrides keys that are
**declared** — anything dropped from `jellyfin.nix` silently keeps its old DB
value forever. A scraper erroring on a host that appears nowhere in nix is this.

Declare disabled things explicitly (`RIVEN_SCRAPING_JACKETT_ENABLED = "false"`)
rather than omitting them.

## Do not

- Do not conclude "we need anime indexers" without checking. Torrentio's default
  provider set already returns mostly NyaaSi for anime; verify with
  `curl -s "https://torrentio.strem.fun/stream/series/<imdb>:1:1.json" | jq -r '.streams[].title' | grep -oE "⚙️ *[A-Za-z]+" | sort | uniq -c`.
  Setting an explicit `providers=` list *excludes* everything omitted.
- Do not restart or recreate containers to "fix" state — the vfs mount prep in
  `jellyfin.nix` makes restarts non-trivial, and it has never been the cause.
- Do not theorise past the data. Three separate wrong diagnoses in one session
  came from explaining a log line before querying item state. Get the states
  from §3 first.
