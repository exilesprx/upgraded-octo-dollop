#!/bin/bash

defaults=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip")
version=3.2.1
fontdir=/usr/local/share/fonts

help() {
	echo "Font Installer Script"
	echo
	echo "Usage: ./font_installer.sh [OPTIONS] [FONT1 FONT2 ...]"
	echo
	echo "Options:"
	echo "  -h, --help           Show this help message and exit"
	echo
	echo "Fonts:"
	echo "  FONT1 FONT2 ...      Specify fonts to install (default: ${defaults[*]})"
	echo
	echo "Examples:"
	echo "  ./font_installer.sh Hack JetBrainsMono"
	echo "  ./font_installer.sh -h"
	echo
	echo "Notes:"
	echo "  - Ensure 'wget' and 'unzip' are installed and executable."
	echo "  - Script may require sudo permissions to modify system directories."
}

check_deps() {
	local index=0
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
		printf "Create directory %s \n" "$fontdir"
		sudo mkdir -p $fontdir
	fi

	printf "Set write permissions to %s \n" "$fontdir"
	sudo chmod o+w $fontdir
}

install_fonts() {
	local fonts=("$@")
	printf "Installing fonts %s \n" "${fonts[@]}"
	for font in "${fonts[@]}"; do
		if wget -q --spider https://github.com/ryanoasis/nerd-fonts/releases/download/v"$version"/"$font".zip; then
			wget -O "$HOME"/Downloads/"$font".zip https://github.com/ryanoasis/nerd-fonts/releases/download/v"$version"/"$font".zip
		else
			printf "Font %s not found \n" "$font"
			continue
		fi

		if [[ -d "$fontdir/$font" ]]; then
			echo "Removing existing directory $fontdir/$font"
			sudo rm -rf "${fontdir:?Font directory is required}"/"${font:?Font is required}"
		fi
		unzip "$HOME"/Downloads/"$font".zip -d "$fontdir"/"$font"/
		rm -f "$HOME"/Downloads/"$font".zip
	done
}

reset_cache() {
	sudo chmod o-w $fontdir
	fc-cache -v
	echo "Fonts installed successfully"
}

main() {
	if [[ $# -eq 0 ]]; then
		help
		exit 1
	fi

	while [[ $# -gt 0 ]]; do
		case "$1" in
		-h | --help)
			help
			exit 0
			;;
		-*)
			echo "Unknown option: $1"
			help
			exit 1
			;;
		*)
			fonts+=("$1")
			;;
		esac
		shift
	done

	check_deps
	create_dir
	install_fonts "${fonts[@]}"
	reset_cache
}

main "$@"
