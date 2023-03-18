#!/usr/bin/env bash

ROOT="$1"

cd "$ROOT"
rm -f "dist/client-app.zip"

npm install
npm run build -- --configuration $ENV_CONFIGURATION
cd dist
zip client-app.zip app/

