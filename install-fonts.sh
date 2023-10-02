#!/bin/bash

fonts=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip")
version=3.0.2
fontdir=/usr/local/share/fonts

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

if [[ ! -d "$fontdir" ]]; then
  mkdir -p $fontdir
fi

# add write permissions for user
sudo chmod o+w $fontdir

# Download fonts
for value in "${fonts[@]}"
do
	wget -O $HOME/Downloads/$value.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v$version/$value.zip
	unzip $HOME/Downloads/$value.zip -d $fontdir/$value/
	rm -f $HOME/Downloads/$value.zip
done

# remove write permissions
sudo chmod o-w $fontdir

fc-cache -v
