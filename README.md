# R Ready — Basic R pre-course site

A Quarto website, built as pre-course material for the Basic R course (A340/01).

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

Not done yet: no git repo, not published anywhere. See "Publish to GitHub Pages" below.

## Notes for whoever edits this next

- **Dataset**: Missions 1, 5, and 6 all use one small synthetic file, `downloads/participants.csv` (id/age/group/score, made up, not real course data) — deliberately generic since it wasn't clear yet whether the course itself would use `climate.xlsx` or something else. It's registered in `_quarto.yml` under `project: resources:` — if you add more downloadable files, add their folder there too, or Quarto won't copy them into `_site/`. If the course settles on a real dataset, swap this file and update the three missions that reference it (search for `participants.csv`).
- **Live R (webR)**: Mission 3 uses the [quarto-webr](https://www.github.com/coatless/quarto-webr) extension (installed under `_extensions/coatless/webr/`) for in-browser, no-install-needed R cells (` ```{webr-r} `). It needs `engine: knitr` + `filters: [webr]` in that page's front matter — building it requires R + knitr installed locally (they are, on this machine), but *viewing* the page needs nothing but a browser, since webR itself runs client-side via WebAssembly. First cell on a page takes a few seconds to initialize (downloads the R runtime); later cells on the same page are instant and share the same R session/objects.
- **Interactive quiz**: the click-and-get-feedback widget (Mission 2) and the R Passport (final challenge) are both plain HTML/CSS/JS — no extra dependency. Markup pattern and behavior live in `_includes/site-scripts.html` (shared JS, injected on every page via `include-after-body` in `_quarto.yml`) and the `.rr-quiz` / `.rr-passport` rules in `styles.scss`. To add another quiz elsewhere, copy the `.rr-quiz` block from `missions/02-paths.qmd` and change `data-answer`/`data-option`/`data-feedback`.
- **RStudio diagram** (Mission 1): a hand-built SVG (not a screenshot) showing the Source/Console/Environment/Files panes, styled to match the site. If you'd rather use real screenshots of RStudio, they're a straightforward swap — see the `.rr-diagram` block in `missions/01-projects.qmd`.
- Missions 4 and 6 deliberately avoid case-only filename changes (e.g. `data` → `Data`) as a way to trigger an error — Windows and default Mac filesystems are case-insensitive, so that wouldn't actually break for most students. They use real renames/wrong filenames instead, which fail everywhere.
- The Help → "Tahereh or Genona" names are hardcoded in `help/index.qmd`; update if that page ever gets used for a different course or instructor pairing.

## Publish to GitHub Pages

Not set up yet — this folder isn't a git repository. Rough steps when ready (all require your go-ahead, since they push content publicly):

1. `git init`, commit, create a GitHub repo, push.
2. `quarto publish gh-pages` from this folder — it builds the site and pushes it to a `gh-pages` branch, then GitHub serves it at `https://<username>.github.io/<repo>/`.

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
