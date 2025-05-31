#!/usr/bin/env bash
set -euo pipefail

# Create necessary directories
mkdir -p /var/roothome
mkdir -p /root/.cache/dconf

# Add flathub repo
flatpak remote-add --if-not-exists --system flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpaks with container-friendly flags
flatpak install --system --noninteractive --assumeyes flathub \
    com.discordapp.Discord \
    org.libreoffice.LibreOffice