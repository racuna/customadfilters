#!/bin/bash
# This script merges filters from GBA with custom filters, removes whitelist entries, and generates formats for PersonalDNSFilter and AdBlock
# v.1.0 added whitelist support
# v.1.2 remove blank lines of the whitelist + comments to the entire script
# v.1.3 added error checking, logging and improved filtering
# v.2 Claude fixes
# v.3 Rutas absolutas y mejoras
# v.4 Ruta base como parámetro
# v.4.1 no más log en el repo
# v.4.2 añadida verificación de líneas

# Obtener la ruta base como parámetro, si se proporciona
if [ -n "$1" ]; then
    BASE_DIR="$1"
else
    BASE_DIR=`pwd` # Ruta base por defecto
fi

# Verificar si la ruta base existe y es un directorio
if [ ! -d "$BASE_DIR" ]; then
    echo "ERROR: La ruta base '$BASE_DIR' no existe o no es un directorio."
    exit 1
fi

# Setup logging
LOG_FILE="$BASE_DIR/merger_log.txt"
echo "*** Script execution started: $(date) ***" > "$LOG_FILE"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check file size and content
check_file() {
    if [ -f "$1" ]; then
        local size=$(wc -l < "$1")
        log_message "File $1 contains $size lines"
        if [ "$size" -eq 0 ]; then
            log_message "WARNING: $1 is empty!"
        fi
        echo "$size"
    else
        log_message "ERROR: File $1 does not exist!"
        return 1
    fi
    return 0
}

# Update local repo
log_message "Pulling latest changes from git repository"
git pull

# Remember current directory
THISDIR=$(pwd)
log_message "Current directory: $THISDIR"

# Create and clean temporary workspace
TMPDIR=~/tmp/merger
log_message "Setting up temporary workspace at $TMPDIR"
rm -rf "$TMPDIR"
mkdir -p "$TMPDIR"
cd "$TMPDIR" || { log_message "Failed to change to temporary directory!"; exit 1; }

# Download filters with error checking
log_message "Downloading filter lists..."
download_files=(
    "https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Hosts/GoodbyeAds.txt"
    "https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-YouTube-AdBlock.txt"
    "https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Xiaomi-Extension.txt"
    "https://raw.githubusercontent.com/jerryn70/GoodbyeAds/master/Extension/GoodbyeAds-Spotify-AdBlock.txt"
    "https://raw.githubusercontent.com/racuna/customadfilters/master/customAdFilters.txt"
    "https://raw.githubusercontent.com/anudeepND/blacklist/master/CoinMiner.txt"
    "https://raw.githubusercontent.com/badmojr/1Hosts/master/Lite/hosts.txt"
    "https://raw.githubusercontent.com/racuna/customadfilters/master/whitelist.txt"
)

download_success=true
for url in "${download_files[@]}"; do
    filename=$(basename "$url")
    log_message "Downloading $filename"
    wget -q "$url" || { log_message "Failed to download $url"; download_success=false; }
    
    if [ -f "$filename" ]; then
        line_count=$(wc -l < "$filename")
        log_message "$filename downloaded, contains $line_count lines"
    else
        log_message "ERROR: $filename not found after download attempt"
        download_success=false
    fi
done

if [ "$download_success" = false ]; then
    log_message "One or more downloads failed. Script may not work correctly."
fi

# Check if whitelist exists
if [ ! -f "whitelist.txt" ]; then
    log_message "Warning: whitelist.txt not found, creating empty file"
    touch whitelist.txt
fi

# Remove whitelist blank lines and check resulting file
log_message "Processing whitelist"
grep -v "^\s*$" whitelist.txt > wl2.txt
check_file "wl2.txt"

# Generate master filter list with verbose output
log_message "Generating master filter list"
cat GoodbyeAds* CoinMiner.txt customAdFilters.txt hosts.txt 2>/dev/null | grep -v -f wl2.txt | grep -v "^#" | sort | uniq -i > master_temp.txt
check_file "master_temp.txt"

# Verificar el número de líneas en master_temp.txt
LINE_COUNT=$(wc -l < master_temp.txt)
log_message "Generated filter list has $LINE_COUNT lines"

# Solo actualizar si tiene más de 10 líneas
if [ "$LINE_COUNT" -gt 10 ]; then
    log_message "File has more than 10 lines, updating GBAplusMine.txt"
    # Copy result to final location
    cp master_temp.txt "$THISDIR/GBAplusMine.txt"
    log_message "Created GBAplusMine.txt in $THISDIR"
    
    # Add results to the repo
    log_message "Adding GBAplusMine.txt to git repo"
    git -C "$THISDIR" add GBAplusMine.txt
    
    # Commit changes
    commit_message="Actualizacion de GBAplusMine.txt dia: $(date)"
    log_message "Committing changes: $commit_message"
    git -C "$THISDIR" commit -m "$commit_message"
    
    # Generate Adblock syntax
    log_message "Generating AdBlock rules format"
    # Simplified grep to be less restrictive
    grep "0.0.0.0" "$THISDIR/GBAplusMine.txt" | \
      grep -v "::1\|127.0.0.1\|255.255.255.255\|fe80::\|ff00::\|ff02::\|^0.0.0.0 0.0.0.0$" | \
      sed 's/^0\.0\.0\.0 /||/; s/$/.^/' > "$THISDIR/adblock_rules.txt"
    
    check_file "$THISDIR/adblock_rules.txt"
    
    # Add AdBlock rules to repo
    log_message "Adding adblock_rules.txt to git repo"
    git -C "$THISDIR" add adblock_rules.txt
    git -C "$THISDIR" commit -m "Actualizacion de adblock_rules.txt dia: $(date)"
    
    # Push changes
    log_message "Pushing changes to remote repository"
    git -C "$THISDIR" push -u origin master
else
    log_message "File has 10 or fewer lines ($LINE_COUNT lines). No updates will be made to GBAplusMine.txt"
fi

# Delete temporary workspace
cd "$THISDIR" || { log_message "Failed to return to original directory!"; exit 1; }
rm -rf "$TMPDIR"
log_message "Cleaned up temporary workspace"

log_message "Script execution completed"
