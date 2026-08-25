#!/bin/bash
# Rebuilds the site and pushes it to the gh-pages branch (GitHub Pages).
# Run from inside the r-ready/ folder, after committing/pushing your content
# changes to main as usual. Requires a short-path-friendly filesystem (see
# the "Gotcha" note in README.md about Windows path-length limits).
set -e

REPO_DIR="$(pwd)"
if [ ! -f "$REPO_DIR/_quarto.yml" ]; then
  echo "Run this from inside the r-ready/ folder." >&2
  exit 1
fi

quarto render .

WT="/c/ghpwt-tmp-$$"
rm -rf "$WT"
git worktree add --detach "$WT"

cd "$WT"
[ "$(pwd)" = "$WT" ] || { echo "ABORT: failed to enter worktree ($WT)"; exit 1; }

git checkout -B gh-pages
git rm -rf . -q || true
cp -r "$REPO_DIR/_site/." .
touch .nojekyll
git add -A
git commit -q -m "Publish site $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push origin gh-pages -f

cd "$REPO_DIR"
git worktree remove "$WT" --force
rm -rf "$WT"

echo "Published: https://tahereh-gh.github.io/basic-r-course/"
