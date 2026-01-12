#!/bin/bash

PACMAN_CACHE="/var/cache/pacman/pkg/"
YAY_CACHE="$HOME/cache/yay"

# Enable nullglob to handle empty patterns correctly
shopt -s nullglob

# Collect all package files from both caches
files=()
# Pacman cache
files+=("${PACMAN_CACHE}"*.pkg.tar.zst "${PACMAN_CACHE}"*.pkg.tar.xz)
# Yay cache
files+=("${YAY_CACHE}"*.pkg.tar.zst "${YAY_CACHE}"*.pkg.tar.xz)

# Check if any files exist
if [[ ${#files[@]} -eq 0 ]]; then
    echo "No packages in cache."
    exit 0
fi

total=0
sizes=()
names=()

# Process each package file
for file in "${files[@]}"; do
    # Extract filename without extension
    base=$(basename "$file")
    name="${base%.pkg.tar.zst}"
    name="${name%.pkg.tar.xz}"
    
    # Get package name (first part before first dash)
    pkgname=$(echo "$name" | cut -d'-' -f1)
    
    sizes+=( $(stat -c%s "$file") )
    names+=("$pkgname")
    ((total++))
done

# Count unique package names
unique=($(printf "%s\n" "${names[@]}" | sort -u))
dup=$((total - ${#unique[@]}))

# Sum sizes using awk
totalsize=$(printf "%s\n" "${sizes[@]}" | awk '{s += $1} END {print s}')

# Convert to GiB (1 GiB = 1073741824 bytes)
totalsize_gib=$(awk -v size="$totalsize" 'BEGIN { printf "%.2f", size / 1073741824 }')

# Output results
echo "Total packages: $total"
echo "Duplicate packages: $dup"
echo "Total size: $totalsize_gib GiB"
