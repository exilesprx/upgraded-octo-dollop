#!/bin/bash

fonts=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip" "curl")
version=3.0.2

# Install deps
index=0
for dep in "${deps[@]}"
do
	if which $dep; then
		unset 'deps[index]'
	fi
	let index++
done

if [ ${#deps[@]} != 0 ]; then
	echo "Missing deps ${deps[@]}"
	exit 1
fi

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
