# Install flatpaks after first boot
install-flatpaks:
    flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user -y flathub com.discordapp.Discord md.obsidian.Obsidian com.bitwarden.desktop