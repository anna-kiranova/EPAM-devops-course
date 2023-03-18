#!/usr/bin/env bash

if ! command -v jq &>/dev/null; then
    echo "ERROR: jq could not be found"
    echo "please install it according to your distribution like that:"
    echo
    echo "sudo apt install jq"
    exit 1
fi

PIPELINE="$1"
if [ ! -f "$PIPELINE" ]; then
    echo "No such pipeline file: '$PIPELINE'"
    exit 1
fi

BRANCH="${2:-main}"
OWNER="${3}"
POLL_FOR_SOURCE_CHANGES="${4:-false}"
BUILD_CONFIGURATION="${5}"

RESULT="./pipeline-$(date +%Y%m%d-%H%M%S).json"

jq 'del(.metadata)' "$PIPELINE" | jq '.pipeline.version+=1' > "$RESULT"

echo "Pipeline saved as $RESULT"
