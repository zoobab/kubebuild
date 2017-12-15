#!/bin/bash
# 1. check the arguments to check that's a git URL

set -e

REPO_URL="$1"
WORKDIR="/tmp"
FINAL="kubebuild.yaml"
TEMPLATE="$FINAL.tmpl"
FINAL_PATH="$WORKDIR/$FINAL"

if [[ "$REPO_URL" != http?(s)://*.git ]]; then
    echo "ERROR, invalid URL (not with https:// ending by .git)"
    echo "Example: $0 https://github.com/zoobab/versaloon.git"
    exit 1
fi

echo "[1/2] Templating..."
sed -e "s/{{{repo_url}}}/caca/g" $TEMPLATE > $WORKDIR/$FINAL

echo "[2/2] Launching in kubernetes..."
kubectl apply -f $FINAL_PATH
