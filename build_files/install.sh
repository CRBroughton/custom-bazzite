#!/usr/bin/env bash
set -euo pipefail

# Add flathub repo
flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install flatpaks
flatpak install --system -y flathub \
    com.discordapp.Discord \
    org.libreoffice.LibreOffice