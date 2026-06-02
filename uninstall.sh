#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===

readonly THEME_NAME="ii-sddm-theme"

readonly SDDM_THEME_DEST="/usr/share/sddm/themes/${THEME_NAME}"
readonly SDDM_CONF_DIR="/etc/sddm.conf.d"
readonly SDDM_THEME_CONF="${SDDM_CONF_DIR}/ii-sddm-theme.conf"

readonly HYPR_THEME_SCRIPTS_DEST="${HOME}/.config/${THEME_NAME}"

readonly MATUGEN_CONF="${HOME}/.config/matugen/config.toml"

readonly USERNAME="${USER}"
readonly SUDOERS_FILE="/etc/sudoers.d/sddm-theme-${USERNAME}"

readonly FONTS_DIR="/usr/share/fonts/ii-sddm-theme-fonts"

# === COLORS ===

STY_CYAN='\e[36m'
STY_GREEN='\e[32m'
STY_YELLOW='\e[33m'
STY_RED='\e[31m'
STY_RST='\e[0m'

# === LOGGING ===

log_info()  { printf "  [INFO] %s\n" "$*"; }
log_ok()    { printf "  ${STY_GREEN}[OK]   %s${STY_RST}\n" "$*"; }
log_warn()  { printf "  ${STY_YELLOW}[WARN] %s${STY_RST}\n" "$*" >&2; }
log_error() { printf "  ${STY_RED}[ERR]  %s${STY_RST}\n" "$*" >&2; }
log_step()  { printf "\n-- %s\n" "$*"; }

# === GUARDS ===

if [[ $EUID -eq 0 ]]; then
    log_error "Do not run this script as root. It will use sudo when needed."
    exit 1
fi

if ! sudo -v; then
    log_error "sudo authentication failed."
    exit 1
fi

# === BANNER ===

show_banner() {
    local title=" UNINSTALL ii-sddm-theme "
    local width=${#title}
    local border
    border=$(printf '─%.0s' $(seq 1 $width))
    printf "\n"
    printf "${STY_CYAN}┌%s┐${STY_RST}\n" "${border}"
    printf "${STY_CYAN}│%s│${STY_RST}\n" "${title}"
    printf "${STY_CYAN}└%s┘${STY_RST}\n" "${border}"
    printf "\n"
}

# === INTRODUCTION ===

introduction() {
    clear
    show_banner
    printf "This script will remove the ii-sddm-theme and all its components.\n"
    printf "\n"
    printf "  ${STY_YELLOW}Note:${STY_RST} This will remove the theme, SDDM configuration, scripts,\n"
    printf "        fonts, matugen block, and sudoers rule.\n"
    printf "\n"
    read -r -p "===> Continue? [y/n]: " p
    case $p in
        y|Y) ;;
        *)
            log_error "Uninstallation aborted by user."
            exit 0
            ;;
    esac
}

# === REMOVE SDDM THEME ===

remove_theme() {
    log_step "Removing SDDM theme"

    if [[ -d "${SDDM_THEME_DEST}" ]]; then
        sudo rm -rf "${SDDM_THEME_DEST}"
        log_ok "Removed ${SDDM_THEME_DEST}"
    else
        log_warn "${SDDM_THEME_DEST} not found, skipping"
    fi
}

# === REMOVE SDDM CONFIGURATION ===

remove_sddm_conf() {
    log_step "Removing SDDM configuration"

    if [[ -f "${SDDM_THEME_CONF}" ]]; then
        sudo rm -f "${SDDM_THEME_CONF}"
        log_ok "Removed ${SDDM_THEME_CONF}"

        if [[ -d "${SDDM_CONF_DIR}" ]] && [[ -z "$(sudo ls -A "${SDDM_CONF_DIR}")" ]]; then
            sudo rmdir "${SDDM_CONF_DIR}"
            log_ok "Removed empty ${SDDM_CONF_DIR}"
        fi
    else
        log_warn "${SDDM_THEME_CONF} not found, skipping"
    fi
}

# === REMOVE HYPR SCRIPTS ===

remove_hypr_scripts() {
    log_step "Removing theme scripts"

    if [[ -d "${HYPR_THEME_SCRIPTS_DEST}" ]]; then
        rm -rf "${HYPR_THEME_SCRIPTS_DEST}"
        log_ok "Removed ${HYPR_THEME_SCRIPTS_DEST}"
    else
        log_warn "${HYPR_THEME_SCRIPTS_DEST} not found, skipping"
    fi
}

# === REMOVE FONTS ===

remove_fonts() {
    log_step "Removing fonts"

    if [[ -d "${FONTS_DIR}" ]]; then
        sudo rm -rf "${FONTS_DIR}"
        log_ok "Fonts removed."
        sudo fc-cache -fv > /dev/null 2>&1
    else
        log_warn "${FONTS_DIR} not found, skipping"
    fi
}

# === REMOVE MATUGEN BLOCK ===

remove_matugen_conf() {
    log_step "Removing matugen configuration block"

    if [[ ! -f "${MATUGEN_CONF}" ]]; then
        log_warn "${MATUGEN_CONF} not found, skipping"
        return
    fi

    if grep -q "^\[templates\.iisddmtheme\]" "${MATUGEN_CONF}"; then
        log_info "Found [templates.iisddmtheme] block. Removing it..."

        local temp_file
        temp_file=$(mktemp)
        awk '
            /^\[templates\.iisddmtheme\]/ { skip=1; next }
            /^\[/ { skip=0 }
            !skip { print }
        ' "${MATUGEN_CONF}" >"${temp_file}"
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${temp_file}"
        mv "${temp_file}" "${MATUGEN_CONF}"
        log_ok "[templates.iisddmtheme] block removed from ${MATUGEN_CONF}"
    else
        log_warn "No [templates.iisddmtheme] block found in ${MATUGEN_CONF}, skipping"
    fi
}

# === REMOVE SUDOERS ===

remove_sudoers() {
    log_step "Removing sudoers rule"

    if sudo test -f "${SUDOERS_FILE}"; then
        sudo rm -f "${SUDOERS_FILE}"
        log_ok "Removed ${SUDOERS_FILE}"
    else
        log_warn "${SUDOERS_FILE} not found, skipping"
    fi
}

# === MAIN ===

main() {
    introduction

    remove_theme
    remove_sddm_conf
    remove_hypr_scripts
    remove_fonts
    remove_matugen_conf
    remove_sudoers

    local msg=" Uninstallation completed successfully "
    local width=${#msg}
    local border
    border=$(printf '─%.0s' $(seq 1 $width))
    printf "\n"
    printf "  ${STY_GREEN}┌%s┐${STY_RST}\n" "${border}"
    printf "  ${STY_GREEN}│%s│${STY_RST}\n" "${msg}"
    printf "  ${STY_GREEN}└%s┘${STY_RST}\n" "${border}"
    printf "\n"
    
    printf -- "-- Reboot your system\n"
    log_warn "Please REBOOT now your system to fully apply the changes, if fonts looks broken rebooting will fix it."
}

main "$@"
