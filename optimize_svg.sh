#!/bin/bash

# Check if directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

DIR="$1"

# Recursively find all .svg files and clean them with Inkscape
find "$DIR" -type f -name "*.svg" -exec inkscape --export-plain-svg --export-filename={} --export-overwrite {} \;
