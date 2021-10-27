#!/bin/bash

if ! command -v neofetch &> /dev/null
then
    echo "neofetch dependency not found"
    exit 1
fi

TRUE="0"
FALSE="1"
MINUTES="60"
SECONDS="60"
HOURS="24"
MAXAGE=$(bc <<< $HOURS*$MINUTES*$SECONDS)


# returns true if file age is less than the calculated max age
function FileAgeIsLessThanMaxAge() {

    # file age in seconds = current_time - file_modification_time.
    FILEAGE=$(($(date +%s) - $(stat -t %s -f %m -- "$1")))

    test "$FILEAGE" -lt "$MAXAGE" && {
        return $TRUE
    }

    return $FALSE
}

CACHE_DIR_NAME="$HOME/.cache"
[ -d "$CACHE_DIR_NAME" ] || mkdir -p "$CACHE_DIR_NAME"

CACHE_FILE_NAME="$CACHE_DIR_NAME/neofetch"

function CreateNeofetchCache() {
    neofetch > "$CACHE_FILE_NAME"
}

function GetCachedNeoFetch () {
    cat "$CACHE_FILE_NAME"
}

if [ ! -f "$CACHE_FILE_NAME" ]; then
    CreateNeofetchCache
fi

if FileAgeIsLessThanMaxAge "$CACHE_FILE_NAME"; then
    GetCachedNeoFetch
else
    CreateNeofetchCache
    GetCachedNeoFetch
fi
