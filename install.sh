#!/bin/bash

fonts=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
version=3.0.2

# Install deps
which wget | apt -y install wget
which unzip | apt -y install unzip
which curl | apt -y install curl

# Download fonts
for value in "${fonts[@]}"
do
	wget -O /home/$USER/Downloads/$value.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v$version/$value.zip
	unzip /home/$USER/Downloads/$value.zip -d /usr/local/share/fonts/$value/
done
fc-cache -v

# Install starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)"' >> /home/$USER/.bashrc
starship preset nerd-font-symbols -o /home/$USER/.config/starship.toml
