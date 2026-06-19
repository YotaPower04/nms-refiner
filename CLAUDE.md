# CLAUDE.md — NMS Refiner Cheat Sheet (deploy brief)

## What this is
A finished, self-contained **Progressive Web App**: a searchable No Man's Sky
refining-recipe cheat sheet (306 recipes, with self-feeding "multiplier" dupe
loops auto-flagged). It is a static site — no build step, no backend, no
dependencies. The files are already complete and correct.

```
index.html              # the whole app (HTML + CSS + JS + recipe data inline)
manifest.webmanifest    # PWA manifest (name, icons, standalone display)
sw.js                   # service worker (offline cache)
icon-192.png            # app icons
icon-512.png
icon-maskable-512.png
```

## The goal
Get this onto the user's **Android phone as an installable app**. PWAs only
become installable over **HTTPS**, which is why opening the file locally
(`content://` / `file://`) shows no "Add to Home screen" option. So the job is:
serve it over HTTPS, then (optionally) wrap it as a signed APK.

Do the tasks below **in order**. Confirm with the user before anything that
touches their accounts or installs global tooling (steps 2 and 3).

---

## Environment
The user is on **Linux**. All commands below are Linux shell commands. If a
required tool is missing, install it (examples are Debian/Ubuntu `apt`; adapt to
the user's distro — `dnf`, `pacman`, etc.):
- GitHub CLI: `sudo apt install gh` (or see https://cli.github.com)
- Node.js + npm: `sudo apt install nodejs npm` (or use `nvm`)
- Python 3 is preinstalled on essentially all Linux distros.

## Task 1 — Local preview (do first, no accounts needed)
Serve the folder and have the user open it in a desktop browser to confirm it
works, then test installability.

```bash
# from the project folder; pick whichever is available
python3 -m http.server 8080
# or
npx --yes serve -l 8080 .
```
Then open it (or just tell the user the URL):

```bash
xdg-open http://localhost:8080 >/dev/null 2>&1 &
```

A convenience script is included: `./serve.sh`

**Verify before moving on:**
- The page renders and shows "306 recipes".
- Searching `sodium` returns ~33 results; `cobalt` ~41; `platinum` ~20.
- The "⟳ Multipliers" toggle narrows the list to the dupe loops.
- In Chrome DevTools → Application → Manifest: no errors; icons load.
- DevTools → Lighthouse → run the PWA/Installable audit: should pass
  "installable". (localhost counts as a secure context.)

## Task 2 — Deploy to GitHub Pages (durable, free HTTPS)
Requires the GitHub CLI authenticated. Check first:

```bash
gh auth status   # if not logged in, tell the user to run: gh auth login
```

Then publish (ask the user for a repo name; default `nms-refiner`):

```bash
git init -b main
git add .
git commit -m "NMS Refiner Cheat Sheet PWA"
gh repo create nms-refiner --public --source=. --remote=origin --push

# enable GitHub Pages from the main branch root
gh api -X POST repos/{owner}/nms-refiner/pages \
  -f 'source[branch]=main' -f 'source[path]=/'
```

After ~1 minute the site is live at:
`https://<github-username>.github.io/nms-refiner/`

Give the user that URL and tell them: open it in **Chrome on the phone** →
menu → **Install app** / **Add to Home screen**. It then runs fullscreen and
works offline (the service worker caches everything on first load).

Confirm the deploy: `curl -sI https://<user>.github.io/nms-refiner/manifest.webmanifest`
should return 200. Note GitHub Pages serves `.webmanifest` with a correct
content-type by default.

## Task 3 — (Optional) Build a real signed APK with Bubblewrap
Only if the user wants an actual installable/Play-Store-ready `.apk`/`.aab`.
This needs the GitHub Pages URL from Task 2 to exist first. Bubblewrap is
Google's official Trusted Web Activity wrapper.

```bash
npm install -g @bubblewrap/cli
# Bubblewrap will offer to download a JDK + Android SDK if missing — let it.
bubblewrap init --manifest https://<user>.github.io/nms-refiner/manifest.webmanifest
bubblewrap build
```
This produces `app-release-signed.apk` (and an `.aab`). Bubblewrap generates a
signing key on first run — **tell the user to back up the keystore and
passwords it creates**; they're required for any future update. The user can
sideload the APK (enable "install unknown apps") or upload the `.aab` to the
Play Console. On Linux, to push it straight to a USB-connected phone:
`adb install app-release-signed.apk` (needs `android-tools-adb` and USB
debugging enabled).

---

## Guardrails
- **Do not change the recipe data** in `index.html` unless the user explicitly
  asks. The yields are datamined and patch-sensitive; the user fact-checks them
  against the live game.
- Keep it a static site — do **not** add frameworks, bundlers, or a build step.
- This is the user's personal reference tool. NMS recipe data isn't anyone's
  proprietary content, but don't republish it under a misleading "official" name.
- Ask before creating public repos or installing global npm packages.
