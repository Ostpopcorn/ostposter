#!/bin/sh
#
# Packs the poster template into a zip, e.g. for uploading to Overleaf.
# Only files tracked by git are included, so local drafts and build output
# are left out. The zip is named after the class file, e.g. ostposter-template.zip.
#
# Usage: ./make_zip.sh [output.zip]   (or: sh make_zip.sh [output.zip])

set -eu

cd "$(dirname "$0")"

cls=$(git ls-files -- '*.cls' | head -n 1)
if [ -z "$cls" ]; then
	echo "No tracked .cls file found." >&2
	exit 1
fi
out=${1:-"$(basename "$cls" .cls)-template.zip"}

# The class, the example posters and any template resources (logos, fonts).
# The file names contain no spaces, so word splitting into "$@" is safe.
files=$(git ls-files -- '*.cls' poster.tex poster_advanced.tex templateresources)
set -- $files

rm -f "$out"
if command -v zip >/dev/null 2>&1; then
	zip -q "$out" "$@"
else
	# Fallback: git archive packs the committed versions, not local edits.
	echo "zip not found, packing committed files with git archive." >&2
	git archive --format=zip -o "$out" HEAD -- "$@"
fi

echo "Wrote $out with $# files:"
printf '  %s\n' "$@"
