#!/usr/bin/env bash
set -eo pipefail
CONTEXT_PATH="$(realpath "$(dirname "$0")/..")" # should return /run/context
BUILD_SCRIPTS_PATH="$(realpath "$(dirname "$0")")"
MAJOR_VERSION_NUMBER="$(sh -c '. /usr/lib/os-release ; echo $VERSION_ID')"
SCRIPTS_PATH="$(realpath "$(dirname "$0")/scripts")"
export CONTEXT_PATH
export SCRIPTS_PATH
export MAJOR_VERSION_NUMBER

run_buildscripts_for() {
    WHAT="$1"  # Removed asterisks
    shift
    # Complex "find" expression here since there might not be any overrides
    # Allows us to numerically sort scripts by stuff like "01-packages.sh" or whatever
    # CUSTOM_NAME is required if we dont need or want the automatic name
    find "${BUILD_SCRIPTS_PATH}/$WHAT" -maxdepth 1 -iname "*-*.sh" -type f -print0 | sort --zero-terminated --sort=human-numeric | while IFS= read -r -d $'\0' script ; do
        if [ "${CUSTOM_NAME}" != "" ] ; then
            WHAT=$CUSTOM_NAME
        fi
        printf "::group:: ===%s-%s===\n" "$WHAT" "$(basename "$script")"
        "$(realpath "$script")"
        printf "::endgroup::\n"
    done
}

copy_systemfiles_for() {
    WHAT="$1"  # Removed asterisks
    shift
    DISPLAY_NAME=$WHAT
    if [ "${CUSTOM_NAME}" != "" ] ; then
        DISPLAY_NAME=$CUSTOM_NAME
    fi
    printf "::group:: ===%s-file-copying===\n" "${DISPLAY_NAME}"
    
    # Debug output
    echo "DEBUG: Looking for directory /${WHAT}"
    echo "DEBUG: Current working directory: $(pwd)"
    echo "DEBUG: Contents of root:"
    ls -la / | head -10
    echo "DEBUG: Looking for /files specifically:"
    ls -la /files 2>/dev/null || echo "/files does not exist"
    
    if [ -d "/${WHAT}" ]; then
        echo "DEBUG: Found /${WHAT}, copying contents..."
        echo "DEBUG: Contents of /${WHAT}:"
        find "/${WHAT}" -type f | head -5
        cp -avf "/${WHAT}/." /
        echo "DEBUG: Copy completed"
    else
        echo "ERROR: Directory /${WHAT} not found, skipping..."
    fi
    printf "::endgroup::\n"
}

# Enable podman socket (from your original script)
systemctl enable podman.socket

CUSTOM_NAME="base"
copy_systemfiles_for files
run_buildscripts_for .
CUSTOM_NAME=