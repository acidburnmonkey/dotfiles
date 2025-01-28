#!/bin/bash


# Function to format the tooltip message
waybar_tooltip() {
    echo "$1" | while read -r line; do
        count="${#line}"
        [ "$count" -lt 69 ] && line="${line}$(printf "%$((69 - count))s")"
        printf '%s' "$line "
    done
}

# Get the number of updates
number=$(dnf check-update --refresh | awk 'NF < 4 {print $1}' |wc -l)

# Get the packages with updates
tooltip=$(dnf check-update --refresh  | awk 'NF < 4 {print $1}' )

if [ $number == 0 ]; then
    exit 0
else
    json_output=$(printf '{ "text": "%s ", "tooltip": "%s", "class": "updates" }' "$number" "$(waybar_tooltip "$tooltip")")
    echo "$json_output"
fi
