#!/bin/bash
# Build MkDocs, copy PDFs, and deploy to GitHub Pages

set -e

echo "Building MkDocs..."
mkdocs build

echo "Copying PDF files to site directory..."
# Copy all PDF files from root to site directory
for pdf in *.pdf; do
    if [ -f "$pdf" ]; then
        cp "$pdf" site/
        echo "  ✓ Copied: $pdf"
    fi
done

echo "Deploying to GitHub Pages..."
# mkdocs gh-deploy will rebuild, so we need to copy PDFs after deployment
# We'll do it manually by committing to gh-pages branch
mkdocs gh-deploy

# After deployment, copy PDFs to gh-pages branch
echo "Copying PDFs to gh-pages branch..."
git checkout gh-pages
for pdf in *.pdf; do
    if [ -f "../$pdf" ]; then
        cp "../$pdf" .
        git add "$pdf" 2>/dev/null || true
    fi
done
git commit -m "Add PDF files" 2>/dev/null || echo "No PDF changes to commit"
git push origin gh-pages
git checkout main

echo "Done!"
