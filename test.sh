#!/usr/bin/env bash
# Test script for SDDM Astronaut Theme
# Author: Adapted for Keyitdev's sddm-astronaut-theme
# Compatible with Arch, Fedora, Debian, Ubuntu, etc.

green='\033[0;32m'
red='\033[0;31m'
bred='\033[1;31m'
cyan='\033[0;36m'
grey='\033[2;37m'
reset="\033[0m"

script_dir="$(dirname "$0")"
theme_dir="$script_dir"   # Directory that contains Main.qml
theme_name="ii-sddm-theme"
system_theme_dir="/usr/share/sddm/themes/${theme_name}"
metadata_file="${theme_dir}/metadata.desktop"

# Extract active config file from metadata
config_file=$(awk -F '=' '/^ConfigFile=/ {print $2}' "$metadata_file")

# Header
echo -e "${cyan}🚀 Testing ${theme_name}${reset}\n"
echo -e "Config file: ${grey}${config_file}${reset}\n"

# Debug or normal mode
if [[ "$1" =~ ^(debug|-debug|--debug|-d)$ ]]; then
    echo -e "${green}Starting in DEBUG mode...${reset}\n"
    QT_IM_MODULE=qtvirtualkeyboard \
    QML2_IMPORT_PATH="${theme_dir}/Components/" \
    sddm-greeter-qt6 --test-mode --theme "$theme_dir"
else
    echo -e "${green}Starting in normal test mode...${reset}"
    echo -e "Don't worry if it keeps loading — test mode doesn't allow login.\n"

    QT_IM_MODULE=qtvirtualkeyboard \
    QML2_IMPORT_PATH="${theme_dir}/Components/" \
    sddm-greeter-qt6 --test-mode --theme "$theme_dir" > /dev/null 2>&1
fi

# Warn if not installed system-wide
if [ ! -d "$system_theme_dir" ]; then
    echo -e "\n${bred}[WARNING]: ${red}Theme not installed system-wide!${reset}"
    echo -e "To install it, run ${cyan}'./setup.sh'${reset} or copy the theme folder to:"
    echo -e "    ${cyan}${system_theme_dir}${reset}\n"
    echo -e "Then set the current theme in ${cyan}/etc/sddm.conf${reset}:"
    echo -e "${grey}# /etc/sddm.conf${reset}"
    echo -e "[Theme]"
    echo -e "Current=${theme_name}"
fi
