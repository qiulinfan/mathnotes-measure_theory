#!/bin/bash
# Build MkDocs, copy PDFs, and deploy to GitHub Pages manually

set -e

echo "Building MkDocs..."
mkdocs build

echo "Copying PDF files to site directory..."
# Copy all PDF files from root to site directory
pdf_count=0
for pdf in *.pdf; do
    if [ -f "$pdf" ]; then
        cp "$pdf" site/
        echo "  ✓ Copied: $pdf"
        pdf_count=$((pdf_count + 1))
    fi
done
echo "Copied $pdf_count PDF files"

echo "Deploying to GitHub Pages (manually)..."
# Manually deploy to gh-pages branch
git stash
git checkout gh-pages
git rm -r . 2>/dev/null || true
cp -r site/* .
git add .
git commit -m "Deploy with PDFs $(date +%Y-%m-%d)" || echo "No changes to commit"
git push origin gh-pages
git checkout main
git stash pop

echo "Done! PDFs should now be in gh-pages branch."

echo "Done!"
