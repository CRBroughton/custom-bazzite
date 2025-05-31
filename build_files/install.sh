#!/usr/bin/env bash
set -euo pipefail

# Create necessary directories and suppress dconf warnings
mkdir -p /var/roothome
mkdir -p /root/.cache/dconf
export DCONF_PROFILE=""

# Add flathub repo
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpaks with additional flags to reduce sandbox issues
flatpak install --system --noninteractive --assumeyes --no-deps --no-related flathub \
    com.discordapp.Discord