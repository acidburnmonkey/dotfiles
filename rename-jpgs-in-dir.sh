#!/bin/bash

#This program will rename all images in a directory from 1-200 + letter from a-z

counter=1
dir="/media/toxic/photos/random/"

echo "Working on $dir"

for file in "$dir"/*.jpg "$dir"/*.webp "$dir"/*.gif "$dir"/*.png "$dir"/*.jpeg; do
   if [ -f "$file" ]; then
        extension="${file##*.}"
        new_name="${counter}.${extension}"

        if [ -n "$new_name" ]; then
            if [ -e "$dir/$new_name" ]; then
                echo "Warning: File $new_name already exists. Skipping..."
            else
                mv "$file" "$dir/$new_name"
                ((counter++))
            fi
        else
            echo "Error: Unable to generate new name for $file. Skipping..."
        fi
    fi
done
