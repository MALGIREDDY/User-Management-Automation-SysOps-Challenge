#!/bin/bash
#####
# Linux User Management Automation
# This script reads:
#     username; group1,group2,group3
# And automatically:
#   • Creates user + primary group
#   • Creates required secondary groups
#   • Sets up /home/username with correct permissions
#   • Generates secure passwords (12-char base64)
#   • Saves credentials to /var/secure/user_passwords.txt
#   • Logs everything to /var/log/user_management.log
####

# Paths 
LOG_FILE="/var/log/user_management.log"
SECURE_DIR="/var/secure"
PASS_FILE="$SECURE_DIR/user_passwords.txt"

#  Ensure secure directories/files 
mkdir -p "$SECURE_DIR"
touch "$LOG_FILE" "$PASS_FILE"

chmod 600 "$LOG_FILE" "$PASS_FILE"

# Logging Function 
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE" >/dev/null
}

# Validate Input File 
INPUT_FILE="$1"

if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: sudo ./create_users.sh <input-file>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo " Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

log "Started processing file: $INPUT_FILE"

#  Main Loop ##
while IFS= read -r raw_line; do
    
    # Normalize whitespace and remove CRLF
    line=$(echo "$raw_line" | tr -d '\r' | xargs)

    # Skip comments & empty lines
    [[ -z "$line" || "$line" == \#* ]] && continue

    # Split at semicolon
    IFS=';' read -r username group_string <<< "$line"

    username=$(echo "$username" | xargs)
    group_string=$(echo "$group_string" | xargs)

    # If username is empty → skip
    [[ -z "$username" ]] && log "Skipped invalid entry: $raw_line" && continue

    echo ""
    echo "=== Processing user: $username ==="
    log "Processing user: $username"

    ## Create primary group (username) 
    if getent group "$username" >/dev/null 2>&1; then
        log "Primary group '$username' already exists"
    else
        groupadd "$username"
        log "Created primary group: $username"
    fi

    ## Create user
    if id "$username" >/dev/null 2>&1; then
        log "User '$username' already exists — skipping creation"
    else
        useradd -m -g "$username" -s /bin/bash "$username"
        log "Created user: $username"
    fi

     ## Process secondary groups 
    if [[ -n "$group_string" ]]; then
        IFS=',' read -ra groups <<< "$group_string"

        for grp in "${groups[@]}"; do
            grp=$(echo "$grp" | xargs)   # Clean whitespace

            [[ -z "$grp" ]] && continue

            if ! getent group "$grp" >/dev/null 2>&1; then
                groupadd "$grp"
                log "Created group: $grp"
            fi

            usermod -aG "$grp" "$username"
            log "Added $username to group: $grp"
        done
    fi

    ##  Setup Home Directory 
    HOME_DIR="/home/$username"

    if [[ ! -d "$HOME_DIR" ]]; then
        mkdir -p "$HOME_DIR"
        log "Created home directory: $HOME_DIR"
    fi

    chown "$username:$username" "$HOME_DIR"
    chmod 700 "$HOME_DIR"

    ### Generate Password 
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd

    echo "$username : $password" >> "$PASS_FILE"
    log "Generated and stored password for $username"

done < "$INPUT_FILE"

echo ""
echo " All operations completed."
echo " Logs saved in: $LOG_FILE"
echo " Passwords saved in: $PASS_FILE"

log "Completed processing input file."
exit 0
