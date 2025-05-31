#!/usr/bin/env bash
set -euo pipefail


# Install VSCode
echo "Installing Visual Studio Code..."
dnf5 config-manager addrepo --set=baseurl="https://packages.microsoft.com/yumrepos/vscode" --id="vscode"
dnf5 config-manager setopt vscode.enabled=0
dnf5 config-manager setopt vscode.gpgcheck=0
dnf5 install --nogpgcheck --enable-repo="vscode" -y code
echo "Visual Studio Code installation complete!"