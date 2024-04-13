#!/bin/bash

fonts=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip")
version=3.2.1
fontdir=/usr/local/share/fonts

check_deps() {
	index=0
	for dep in "${deps[@]}"; do
		if [[ -x "$(command -v "$dep")" ]]; then
			unset 'deps[index]'
		fi
		((index++)) || true
	done

	if [[ ${#deps[@]} != 0 ]]; then
		echo "Missing deps" "${deps[@]}"
		exit 1
	fi
}

create_dir() {
	if [[ ! -d "$fontdir" ]]; then
		printf "Prompting to create directory %s \n" "$fontdir"
		sudo mkdir -p $fontdir
	fi
}

set_permissions() {
	printf "Prompting for write permissions to %s \n" "$fontdir"
	sudo chmod o+w $fontdir
}

install_fonts() {
	for value in "${fonts[@]}"; do
		wget -O "$HOME"/Downloads/"$value".zip https://github.com/ryanoasis/nerd-fonts/releases/download/v"$version"/"$value".zip
		if [[ -d "$fontdir/$value" ]]; then
			echo "Removing existing directory $fontdir/$value"
			sudo rm -rf "${fontdir:?}"/"${value:?}"
		fi
		unzip "$HOME"/Downloads/"$value".zip -d "$fontdir"/"$value"/
		rm -f "$HOME"/Downloads/"$value".zip
	done
}

reset_permissions_and_cache() {
	sudo chmod o-w $fontdir
	fc-cache -v
	echo "Fonts installed successfully"
}

main() {
	check_deps
	create_dir
	set_permissions
	install_fonts
	reset_permissions_and_cache
}

main "$@"
