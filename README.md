# NMS Refiner Cheat Sheet

A searchable No Man's Sky refining-recipe reference that installs as an app on
your phone and works offline. 306 recipes across Portable / Medium / Large
refiners, with self-feeding "multiplier" dupe loops auto-flagged.

## Use it with Claude Code (easiest)
1. Drop this folder onto your PC.
2. Open it in Claude Code and say: **"Read CLAUDE.md and deploy this."**
3. Claude Code will preview it locally, deploy it to GitHub Pages over HTTPS,
   and—if you want—build a signed Android APK with Bubblewrap.

`CLAUDE.md` contains the full step-by-step brief and verification checks.

## Or just open it
Open `index.html` in any browser to use it right now (`xdg-open index.html`, or
run `./serve.sh` for a local server). Installing it to your home screen requires
serving it over HTTPS — see `CLAUDE.md`, Task 2.

## Files
- `index.html` — the entire app (markup, styles, logic, and recipe data inline)
- `manifest.webmanifest` — PWA metadata
- `sw.js` — offline service worker
- `icon-*.png` — app icons

## A note on the data
Recipe yields are community-datamined and Hello Games retunes them between
updates. Treat exact ratios as a strong guide and confirm anything you're
scaling a farm around in your current game version.
