#!/usr/bin/env bash

for path in "$@"; do
    echo "path: $path, files: $(find "$path" -type f | wc -l)"
done
