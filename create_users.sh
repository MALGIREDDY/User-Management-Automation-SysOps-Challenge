#!/bin/bash

# User Management Automation Script

INPUT_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASS_FILE="/var/secure/user_passwords.txt"

mkdir -p /var/secure

touch "$LOG_FILE"
touch "$PASS_FILE"

chmod 600 "$LOG_FILE" "$PASS_FILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "❌ Input file not found!"
    exit 1
fi

while IFS= read -r line; do
    line=$(echo "$line" | tr -d '\r' | xargs)

    [[ -z "$line" || "$line" == \#* ]] && continue

    IFS=';' read -r user groups <<< "$line"

    # CLEAN WINDOWS CRLF + SPACES
    user=$(echo "$user" | tr -d '\r' | xargs)
    groups=$(echo "$groups" | tr -d '\r' | xargs)

    echo ""
    echo "Processing user: $user"
    log "Processing user: $user"

    # Create primary group
    if ! getent group "$user" >/dev/null 2>&1; then
        echo " -> Creating primary group: $user"
        groupadd "$user"
        log "Created primary group $user"
    else
        echo " -> Primary group already exists"
        log "Primary group exists"
    fi

    # Create user
    if ! id "$user" >/dev/null 2>&1; then
        echo " -> Creating user: $user"
        useradd -m -g "$user" -s /bin/bash "$user"
        log "User $user created"
    else
        echo " -> User already exists"
        log "User exists"
    fi

    # Supplementary groups
    IFS=',' read -ra grp_array <<< "$groups"

    for g in "${grp_array[@]}"; do
        g=$(echo "$g" | tr -d '\r' | xargs)   # CLEAN hidden chars

        if ! getent group "$g" >/dev/null 2>&1; then
            echo " -> Creating group: $g"
            groupadd "$g"
            log "Group $g created"
        fi
        
        echo " -> Adding $user to group: $g"
        usermod -a -G "$g" "$user"
        log "Added $user to $g"
    done

    # Home directory
    home_dir="/home/$user"
    mkdir -p "$home_dir"
    chown "$user:$user" "$home_dir"
    chmod 700 "$home_dir"

    # Password
    password=$(openssl rand -base64 12)
    echo "$user:$password" | chpasswd

    echo "$user:$password" >> "$PASS_FILE"
    log "Password generated for $user"

done < "$INPUT_FILE"

echo ""
echo "✅ All operations logged in $LOG_FILE"
echo "✅ User credentials stor

