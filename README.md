# Font Installer Script

This bash script automates the installation of Nerd Fonts on your system.

## Prerequisites

Before running the script, ensure you have the following dependencies installed:

- `wget`
- `unzip`

## Usage

1. Clone this repository or download the script directly.
2. Make the script executable:

```bash
chmod +x font_installer.sh
```

Run the script with the fonts you want to install (optional, defaults are predefined):

```bash
./font_installer.sh [font1 font2 ...]
```

If no fonts are specified, default fonts will be installed.

## Script Overview

- _Defaults_: Predefined list of fonts available for installation.
- _Dependencies_: Checks for required utilities (wget and unzip).
- _Font Installation_: Downloads specified fonts from GitHub.
- _Directory Setup_: Creates necessary directories and sets permissions.
- _Font Cache_: Updates font cache after installation.

## Customization

You can customize the script by modifying:

- `defaults`: Add or remove fonts from the default list.
- `version`: Change the Nerd Fonts version used for downloads.
- `fontdir`: Directory where fonts are installed (/usr/local/share/fonts by default).

## Notes

Ensure you have appropriate permissions to execute and modify system directories (sudo might be required).
This script assumes internet connectivity for downloading fonts from GitHub.
