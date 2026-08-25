# R Ready — Basic R pre-course site

A Quarto website, built as pre-course material for the Basic R course (A340/01).

**Live at:** <https://tahereh-gh.github.io/basic-r-course/>
**Repo:** <https://github.com/Tahereh-Gh/basic-r-course>

## Preview it in your browser

Requires [Quarto](https://quarto.org/docs/get-started/) — already installed on this machine.

From the `Basic R Course` folder (one level up from here), run:

```bash
quarto preview r-ready
```

or, from inside this `r-ready` folder itself:

```bash
quarto preview
```

Either way: it builds the site, opens it in your default browser automatically, and live-reloads every time you save a `.qmd` file. Press Ctrl+C in the terminal to stop it.

## Status

Content complete: home page, all 7 missions (00–06), and the full Help section. Mission 3 has live, runnable R in the browser (webR); Mission 2 has an interactive click-and-get-feedback quiz; the final challenge ends with an animated "R Passport."

Published: pushed to GitHub (`main` branch) and live on GitHub Pages (`gh-pages` branch). See "Publish to GitHub Pages" below for how to push updates.

## Notes for whoever edits this next

- **Dataset**: Missions 1, 5, and 6 all use one small synthetic file, `downloads/participants.csv` (id/age/group/score, made up, not real course data) — deliberately generic since it wasn't clear yet whether the course itself would use `climate.xlsx` or something else. It's registered in `_quarto.yml` under `project: resources:` — if you add more downloadable files, add their folder there too, or Quarto won't copy them into `_site/`. If the course settles on a real dataset, swap this file and update the three missions that reference it (search for `participants.csv`).
- **Live R (webR)**: Mission 3 uses the [quarto-webr](https://www.github.com/coatless/quarto-webr) extension (installed under `_extensions/coatless/webr/`) for in-browser, no-install-needed R cells (` ```{webr-r} `). It needs `engine: knitr` + `filters: [webr]` in that page's front matter — building it requires R + knitr installed locally (they are, on this machine), but *viewing* the page needs nothing but a browser, since webR itself runs client-side via WebAssembly. First cell on a page takes a few seconds to initialize (downloads the R runtime); later cells on the same page are instant and share the same R session/objects.
- **Interactive quiz**: the click-and-get-feedback widget (Mission 2) and the R Passport (final challenge) are both plain HTML/CSS/JS — no extra dependency. Markup pattern and behavior live in `_includes/site-scripts.html` (shared JS, injected on every page via `include-after-body` in `_quarto.yml`) and the `.rr-quiz` / `.rr-passport` rules in `styles.scss`. To add another quiz elsewhere, copy the `.rr-quiz` block from `missions/02-paths.qmd` and change `data-answer`/`data-option`/`data-feedback`.
- **RStudio diagram** (Mission 1): a real screenshot (`images/rstudio-panes.png`) with the ①②③④ pane labels and highlight boxes overlaid via CSS (`.rr-pane-box` / `.rr-pane-badge` in `styles.scss`), not baked into the image itself — see the `.rr-diagram-photo` block in `missions/01-projects.qmd`. To swap in a newer screenshot later, replace the PNG and nudge the `left/top/width/height` percentages on the overlay `<span>`s if the pane layout has shifted.
- Missions 4 and 6 deliberately avoid case-only filename changes (e.g. `data` → `Data`) as a way to trigger an error — Windows and default Mac filesystems are case-insensitive, so that wouldn't actually break for most students. They use real renames/wrong filenames instead, which fail everywhere.
- The Help → "Tahereh or Genona" names are hardcoded in `help/index.qmd`; update if that page ever gets used for a different course or instructor pairing.

## Publish to GitHub Pages

**To update the live site after editing content:**

1. Commit your changes on `main` as usual (`git add`, `git commit`, `git push`).
2. From inside `r-ready/`, run:

```bash
bash republish.sh
```

[`republish.sh`](republish.sh) re-renders the site and pushes the result to `gh-pages` (the worktree dance below, scripted). Or do it by hand:

```bash
git worktree add --detach /c/ghpwt-tmp
cd /c/ghpwt-tmp
git checkout --orphan gh-pages
git rm -rf . -q
cp -r "/path/to/r-ready/_site/." .
touch .nojekyll
git add -A && git commit -m "Publish site"
git push origin gh-pages -f
cd - && git worktree remove /c/ghpwt-tmp --force
```

**Why not `quarto publish gh-pages`?** That's the normal one-command way to do this, and it works fine for brand-new repos in most setups — but on this machine it refused with "the remote origin does not have a branch named gh-pages", even freshly initialized, even with `--no-prompt`/piped confirmation. The worktree approach above is what actually worked and is what's used now. If a future Quarto/environment update fixes this, `quarto publish gh-pages` is the simpler path to retry.

**Gotcha hit while setting this up:** don't run the orphan-branch steps (`git checkout --orphan`, `git rm -rf .`) directly inside the `r-ready` working copy, even "temporarily" — if a `cd` into a worktree silently fails (e.g. Windows' ~260-character path limit, easy to hit with a deeply nested temp folder + this extension's long filenames), those commands run in `r-ready` itself instead and wipe the working directory. Always use a *separate, short-path* worktree (e.g. `C:\ghpwt-tmp`, not something nested under a long temp/session path), and verify `pwd` before running anything destructive. (Recovery, if it happens again: the files are still safe in the `main` branch's history — `git switch main` restores everything.)

Live URL: **https://tahereh-gh.github.io/basic-r-course/** — GitHub enabled Pages automatically the moment the `gh-pages` branch was pushed; no manual Settings step was needed.

See <https://quarto.org/docs/publishing/github-pages.html> for details.

## Structure

```text
r-ready/
├── _quarto.yml          site config, navigation
├── styles.scss           theme + small custom styles
├── index.qmd             home page
├── missions/              the "Before the course" missions, 00–06
├── help/                  the "Help! 😱" troubleshooting section
├── downloads/             files students download (participants.csv)
├── _includes/             shared JS (quiz + R Passport interactivity)
└── _extensions/           quarto-webr, for Mission 3's live R cells
```
