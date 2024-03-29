#!/bin/bash

dir="/media/toxic/photos/poster"

# Convert webp to png
for x in "$dir"/*.webp; do
  convert "$x" "${x%.webp}.png"
done

# Rename png files
find "$dir" -type f -name "*.webp.png" -exec rename 's/.webp.png/.png/' {} +

