#!/bin/bash

if ! command -v neofetch &> /dev/null
then
    echo "neofetch command not found"
    exit 1
fi

CACHE_FILE_NAME="$HOME/.cache/neofetch"
MAXAGE=$(bc <<< '24*60*60')

# oh you silly shell
TRUE="0"
FALSE="1"

function FileAgeIsLessThanMaxAge() {

    # file age in seconds = current_time - file_modification_time.
    FILEAGE=$(($(date +%s) - $(stat -t %s -f %m -- "$1")))

    test "$FILEAGE" -lt "$MAXAGE" && {
        return $TRUE
    }

    return $FALSE
}

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
