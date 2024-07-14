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
number=$(dnf check-update --refresh 2>/tmp/dnf-updates-error.log | grep -Ec ' updates$')

# Get the packages with updates
tooltip=$(dnf check-update --refresh 2>>/tmp/dnf-updates-error.log | grep ' updates$' | awk '{print $1}' )

# printf '{ "text": "%s", "tooltip": "%s", "class": "updates" }' "$number" "$(waybar_tooltip "$tooltip")"
json_output=$(printf '{ "text": "%s ", "tooltip": "%s", "class": "updates" }' "$number" "$(waybar_tooltip "$tooltip")")
echo "$json_output"
