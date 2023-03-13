#!/usr/bin/env bash

CMD="$1"

DATA_ROOT="$(dirname ${BASH_SOURCE[0]})/../data"
USERS_DB="$DATA_ROOT/users.db"

ensureDbFile() {
    if [ ! -f "$USERS_DB" ]; then
        read -p "No users.db file, do you want to create it? (y/n) " -n 1
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 0
        fi
        echo
        mkdir -p "$DATA_ROOT" && touch "$USERS_DB"
    fi
}

case "$CMD" in
    add)
        ensureDbFile
        read -p "Username: " username
        if [[ ! $username =~ ^[a-zA-Z]+$ ]]; then
            echo "Invalid username: '$username'"
            exit 1
        fi
        read -p "Role: " role
        if [[ ! $role =~ ^[a-zA-Z]+$ ]]; then
            echo "Invalid role: '$role'"
            exit 1
        fi
        echo "$username,$role" >> "$USERS_DB"
        ;;
    backup)
        ensureDbFile
        backup_fn="$(date +%Y%m%d-%H%M%S)-users.db.backup"
        backup="$DATA_ROOT/$backup_fn"
        cp "$USERS_DB" "$backup" && echo "Created backup $backup_fn"
        ;;
    restore)
        ensureDbFile
        backups=($(ls $DATA_ROOT/*-users.db.backup 2>/dev/null | sort -r))
        last_backup="${backups[0]}"
        if [ -z "$last_backup" ]; then
            echo "No backup file found"
            exit 1
        fi
        cp "$last_backup" "$USERS_DB" && echo "Restored backup $(basename $last_backup)"
        ;;
    find)
        ensureDbFile
        read -p "Username: " username
        if [[ ! $username =~ ^[a-zA-Z]+$ ]]; then
            echo "Invalid username: '$username'"
            exit 1
        fi
        found=false
        while read line; do
            user="$(echo "$line" | cut -d',' -f 1)"
            if [[ $user = $username ]]; then
                found=true
                role="$(echo "$line" | cut -d',' -f 2)"
                echo "Found user '$user', role '$role'"
            fi
        done < "$USERS_DB"
        if ! $found; then
            echo "User not found"
        fi
        ;;
    list)
        ensureDbFile
        n=1
        if [[ $2 = "--inverse" ]]; then
            file="tac $USERS_DB"
        else
            file="cat $USERS_DB"
        fi
        while read line; do
            user="$(echo "$line" | cut -d',' -f 1)"
            role="$(echo "$line" | cut -d',' -f 2)"
            echo "$n. $user, $role"
            let n=$n+1
        done < <(/usr/bin/env bash -c "$file")
        ;;
    '' | help)
        cat << EOF
Users database manipulation script.

Usage:
    $0 <command>
    Where <command> is one of add, backup, find, list, help

    add         - add a new user entry to database
    backup      - backup users database
    find        - find users matching query
    list        - list users in database
    help        - print this help and exit
EOF
        ;;
    *)
        echo "Error: unexpected command $CMD"
        exit 1
        ;;
esac
