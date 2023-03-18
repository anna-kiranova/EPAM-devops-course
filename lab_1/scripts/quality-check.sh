#!/usr/bin/env bash

ROOT="$1"

cd "$ROOT"

npm run lint && npm run test