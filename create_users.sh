#!/bin/bash
#===========================================================
# Script Name: create_users.sh
# Description: Automates user account creation and management.
# Author: M SAIDEEP
#===========================================================

#---------------------------#
#       CONFIG PATHS        #
#---------------------------#
INPUT_FILE="$1"
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure secure directories exist
mkdir -p /var/secure
touch "$LOG_FILE" "$PASSWORD_FILE"

# Set strict permissions
chmod 600 "$LOG_FILE" "$PASSWORD_FILE"

#---------------------------#
#  Function: log messages   #
#---------------------------#
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> "$LOG_FILE"
}

#---------------------------#
# Validate input file       #
#---------------------------#
if [[ -z "$INPUT_FILE" ]]; then
    echo "Usage: $0 <userlist.txt>"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: Input file '$INPUT_FILE' not found!"
    exit 1
fi

#---------------------------#
# Main Processing Loop      #
#---------------------------#
while IFS= read -r line; do

    # Skip empty lines or comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Remove extra spaces
    line=$(echo "$line" | tr -d '[:space:]')

    # Split user and groups
    username=$(echo "$line" | cut -d';' -f1)
    groups=$(echo "$line" | cut -d';' -f2)

    if [[ -z "$username" ]]; then
        log "SKIPPED: Invalid line format -> $line"
        continue
    fi

    #---------------------------#
    #   Create user and groups  #
    #---------------------------#
    # Create groups if not exist
    IFS=',' read -ra GROUP_ARRAY <<< "$groups"
    for grp in "${GROUP_ARRAY[@]}"; do
        if [[ -n "$grp" ]]; then
            if ! getent group "$grp" > /dev/null; then
                groupadd "$grp"
                log "Created group: $grp"
            fi
        fi
    done

    # Check if user already exists
    if id "$username" &>/dev/null; then
        log "User '$username' already exists. Skipping user creation."
    else
        # Create user with primary group same as username
        if ! getent group "$username" > /dev/null; then
            groupadd "$username"
            log "Created primary group: $username"
        fi

        useradd -m -g "$username" -G "$groups" -s /bin/bash "$username"
        if [[ $? -eq 0 ]]; then
            log "User '$username' created successfully."
        else
            log "ERROR: Failed to create user '$username'."
            continue
        fi
    fi

    #---------------------------#
    #   Set password            #
    #---------------------------#
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    echo "$username:$password" >> "$PASSWORD_FILE"
    log "Password set for user '$username'."

    #---------------------------#
    #   Set home permissions    #
    #---------------------------#
    home_dir="/home/$username"
    if [[ -d "$home_dir" ]]; then
        chown "$username:$username" "$home_dir"
        chmod 700 "$home_dir"
        log "Permissions set for $home_dir"
    else
        mkdir -p "$home_dir"
        chown "$username:$username" "$home_dir"
        chmod 700 "$home_dir"
        log "Home directory created for '$username'."
    fi

done < "$INPUT_FILE"

log "User management process completed successfully."
echo "✅ All operations logged in $LOG_FILE"
echo "✅ User credentials stored securely in $PASSWORD_FILE"
