#!/bin/bash

# Exit on any command failure before merge
set -e

echo "[1/4] Checking for uncommitted changes..."
if [ -n "$(git status --porcelain)" ]; then
    echo "ERROR: You have uncommitted changes. Please commit or stash them first."
    exit 1
fi

echo "[2/4] Fetching remotes..."
git fetch ac
git fetch playerbots

echo "[3/4] Merging ac/master..."
if git merge ac/master --no-edit; then
    echo "Successfully merged ac/master"
else
    echo "CONFLICT: Detected in ac/master. Aborting merge."
    git merge --abort
    exit 1
fi

echo "[4/4] Merging playerbots/Playerbot..."
if git merge playerbots/Playerbot --no-edit; then
    echo "Successfully merged playerbots/Playerbot"
else
    echo "CONFLICT: Detected in playerbots/Playerbot. Aborting merge."
    git merge --abort
    exit 1
fi

echo "SUCCESS: All changes merged successfully."
