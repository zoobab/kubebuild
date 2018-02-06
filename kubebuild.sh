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
GIT_URL_REGEX="http?(s)://*.git"
BUILD_NUMBER="$(echo $RANDOM)"

if [[ "$REPO_URL" != $GIT_URL_REGEX ]]; then
    echo "ERROR, invalid URL (not with http(s):// ending by .git)"
    echo "Example: $0 https://github.com/zoobab/versaloon.git"
    exit 1
fi

REPONAME_DOTGIT="$(basename $REPO_URL)"
REPO_NAME=$(echo $REPONAME_DOTGIT | sed -e "s/.git//g")

echo -ne "[1/4] Templating (with repo named '$REPO_NAME')..."
sed -e "s#{{{repo_url}}}#$REPO_URL#g" -e "s#{{{repo_name}}}#$REPO_NAME#g" -e "s#{{{buildnumber}}}#$BUILD_NUMBER#g" $TEMPLATE > $FINAL_PATH
echo -ne "OK\n"

POD_NAME="kubebuild-$BUILD_NUMBER"

echo "[2/4] Launching pod '$POD_NAME' in kubernetes..."
kubectl apply -f $FINAL_PATH

get_pod_status() {
    POD_STATUS=$(kubectl get pod $POD_NAME | tail -n +2 | awk '{print $3}')
    echo $POD_STATUS
}

POD_STATUS=$(get_pod_status)
while [ "$POD_STATUS" != "Running" ] ; do
    echo "[3/4] Waiting for pod '$POD_NAME', current status $POD_STATUS"
    POD_STATUS=$(get_pod_status)
    sleep 2
done

echo "[4/4] Tail the log..."
kubectl logs -f $POD_NAME
