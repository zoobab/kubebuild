#!/bin/bash
# 1. check the arguments to check that's a git URL

set -e

check_command() {
PROGRAM=$1
command -v $PROGRAM >/dev/null 2>&1 || { echo "ERROR, this script requires $PROGRAM but it's not installed.  Aborting." >&2; exit 1; }
}

check_command kubectl
check_command sed

REPO_URL="$1"
WORKDIR="/tmp"
NAME="kubebuild"
FINAL="$NAME.yaml"
TEMPLATE="$NAME.tmpl"
FINAL_PATH="$WORKDIR/$FINAL"

if [[ "$REPO_URL" != http?(s)://*.git ]]; then
    echo "ERROR, invalid URL (not with https:// ending by .git)"
    echo "Example: $0 https://github.com/zoobab/versaloon.git"
    exit 1
fi

echo "[1/2] Templating..."
sed -e "s#{{{repo_url}}}#$REPO_URL#g" $TEMPLATE > $WORKDIR/$FINAL

echo "[2/2] Launching in kubernetes..."
kubectl apply -f $FINAL_PATH
