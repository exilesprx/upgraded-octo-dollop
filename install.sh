#!/bin/bash

defaults=("3270" "FiraCode" "Hack" "IntelOneMono" "JetBrainsMono" "Meslo" "SpaceMono")
deps=("wget" "unzip")
version=3.2.1
fontdir=/usr/local/share/fonts

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
			sudo rm -rf "${fontdir:?}"/"${font:?}"
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
		local fonts=("${defaults[@]}")
	else
		local fonts=("$@")
	fi

	check_deps
	create_dir
	install_fonts "${fonts[@]}"
	reset_cache
}

main "$@"
