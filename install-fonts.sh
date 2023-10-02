#!/bin/bash

fonts=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip")
version=3.0.2

# Install deps
index=0
for dep in "${deps[@]}"
do
	if [[ -x "$(command -v $dep)" ]]; then
		unset 'deps[index]'
	fi
	let index++
done

if [[ ${#deps[@]} != 0 ]]; then
	echo "Missing deps ${deps[@]}"
	exit 1
fi

if [[ ! -d "/usr/local/share/fonts" ]]; then
  mkdir -p /usr/local/share/fonts
fi

# add write permissions for user
sudo chmod o+w /usr/local/share/fonts

# Download fonts
for value in "${fonts[@]}"
do
	wget -O $HOME/Downloads/$value.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v$version/$value.zip
	unzip $HOME/Downloads/$value.zip -d /usr/local/share/fonts/$value/
	rm -f $HOME/Downloads/$value.zip
done

# remove write permissions
sudo chmod o-w /usr/local/share/fonts

fc-cache -v
