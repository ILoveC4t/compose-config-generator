#!/usr/bin/env bash
set -e

RESET='\e[0m'
GREEN='\e[32m'
RED='\e[31m'

TEMPLATES_DIR="${TEMPLATES_DIR:-/templates}"
OUTPUT_DIR="${OUTPUT_DIR:-/output}"
TEMPLATE_PATTERN="${TEMPLATE_PATTERN:-*.template}"

echo "=== Config Generator Started ==="
echo "Templates directory: $TEMPLATES_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Template pattern: $TEMPLATE_PATTERN"
echo "================================"

mkdir -p "$OUTPUT_DIR"

if [ -n "$(find "$TEMPLATES_DIR" -name "$TEMPLATE_PATTERN" 2>/dev/null)" ]; then
    for template_file in "$TEMPLATES_DIR"/$TEMPLATE_PATTERN; do
        if [ -f "$template_file" ]; then
            filename=$(basename "$template_file")
            output_name="${filename%.template}"
            output_path="$OUTPUT_DIR/$output_name"
            
            echo "Processing: $filename -> $output_name"
            
            # Check if output path already exists as a directory
            # Docker compose sometimes creates these if you try to mount
            # a file before it was createda
            if [ -d "$output_path" ]; then
                # Check if directory is empty
                if [ -n "$(find "$output_path" -mindepth 1 -maxdepth 1 2>/dev/null)" ]; then
                    printf "%b\n" "${RED}Error: $output_path exists as non-empty directory. Cannot overwrite.${RESET}"
                    printf "%b\n" "${RED}Please ensure the output directory is clean before running the config generator.${RESET}"
                    exit 1
                else
                    echo "Warning: $output_path exists as empty directory, removing it..."
                    rmdir "$output_path"
                fi
            fi
            
            envsubst < "$template_file" > "$output_path"
            
            echo "Generated: $output_path"
            
            if [ "${DEBUG:-false}" = "true" ]; then
                echo "--- Content preview ---"
                head -5 "$output_path"
                echo "--- End preview ---"
            fi
        fi
    done
else
    printf "%b\n" "${RED}No template files found matching pattern: $TEMPLATE_PATTERN${RESET}"
    exit 1
fi

printf "%b\n" "${GREEN}=== Config Generation Completed ===${RESET}"

if [ "${KEEP_RUNNING}" = "true" ]; then
    echo "Keeping container running for debugging..."
    tail -f /dev/null
fi