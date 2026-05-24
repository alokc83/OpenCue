#!/bin/bash
set -e

# Ensure we run from the project root
cd "$(dirname "$0")/.."

# Find the current build number and increment it using awk
awk '{ if ($1 == "CURRENT_PROJECT_VERSION:") { sub(/[0-9]+/, $2+1) } print }' project.yml > project.yml.tmp
mv project.yml.tmp project.yml

# Extract the new build number to show the user
NEW_BUILD=$(awk '$1 == "CURRENT_PROJECT_VERSION:" {print $2}' project.yml)

echo "✅ Build number automatically incremented to $NEW_BUILD"
