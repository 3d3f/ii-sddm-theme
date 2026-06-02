#!/usr/bin/env bash

# === CONFIGURATION ===

readonly THEME_NAME="ii-sddm-theme"

readonly SDDM_THEME_DEST="/usr/share/sddm/themes/${THEME_NAME}"
readonly SDDM_THEME_CONF="/etc/sddm.conf.d/ii-sddm-theme.conf"

readonly HYPR_THEME_SCRIPTS_DEST="${HOME}/.config/${THEME_NAME}"

readonly MATUGEN_CONF="${HOME}/.config/matugen/config.toml"

readonly USERNAME="${USER}"
readonly APPLY_SCRIPT="${HYPR_THEME_SCRIPTS_DEST}/sddm-theme-apply.sh"
readonly SUDOERS_FILE="/etc/sudoers.d/sddm-theme-${USERNAME}"

readonly FONTS_DIR="/usr/share/fonts/ii-sddm-theme-fonts"

# === COLORS ===

STY_CYAN='\e[36m'
STY_GREEN='\e[32m'
STY_YELLOW='\e[33m'
STY_RED='\e[31m'
STY_RST='\e[0m'

# === LOGGING ===

failures=0
warnings=0

log_ok()   { printf "  ${STY_GREEN}[OK]   %s${STY_RST}\n" "$*"; }
log_warn() { printf "  ${STY_YELLOW}[WARN] %s${STY_RST}\n" "$*"; warnings=$((warnings + 1)); }
log_fail() { printf "  ${STY_RED}[FAIL] %s${STY_RST}\n" "$*"; failures=$((failures + 1)); }
log_step() { printf "\n-- %s\n" "$*"; }

# === CHECKS ===

check_dependencies() {
    log_step "Dependencies"

    local pkgs=(sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg)
    for pkg in "${pkgs[@]}"; do
        if pacman -Q "${pkg}" >/dev/null 2>&1; then
            log_ok "${pkg} installed"
        else
            log_fail "${pkg} missing"
        fi
    done

    if command -v matugen >/dev/null 2>&1; then
        log_ok "matugen found"
    else
        log_warn "matugen not found (only required for matugen integrations)"
    fi

    if command -v python3 >/dev/null 2>&1; then
        log_ok "python3 found"
    else
        log_warn "python3 not found (only required for ii-matugen integration)"
    fi
}

check_sddm_theme() {
    log_step "SDDM theme"

    if [[ -d "${SDDM_THEME_DEST}" ]]; then
        log_ok "Theme directory exists: ${SDDM_THEME_DEST}"
    else
        log_fail "Theme directory missing: ${SDDM_THEME_DEST}"
        return
    fi

    for f in Main.qml metadata.desktop; do
        if [[ -f "${SDDM_THEME_DEST}/${f}" ]]; then
            log_ok "${f} present"
        else
            log_fail "${f} missing in ${SDDM_THEME_DEST}"
        fi
    done

    if find "${SDDM_THEME_DEST}/Backgrounds/" -maxdepth 1 -name 'background.*' 2>/dev/null | grep -q .; then
        log_ok "Background file present"
    else
        log_warn "No background file found in ${SDDM_THEME_DEST}/Backgrounds/"
    fi

    for f in Components/Colors.qml Components/Settings.qml; do
        if [[ -f "${SDDM_THEME_DEST}/${f}" ]]; then
            log_ok "${f} present"
        else
            log_warn "${f} missing (may not be generated yet — run matugen once)"
        fi
    done
}

check_sddm_conf() {
    log_step "SDDM configuration"

    if [[ -f "${SDDM_THEME_CONF}" ]]; then
        log_ok "Drop-in exists: ${SDDM_THEME_CONF}"
    else
        log_fail "Drop-in missing: ${SDDM_THEME_CONF}"
        return
    fi

    if grep -q "^Current=${THEME_NAME}$" "${SDDM_THEME_CONF}"; then
        log_ok "Current=${THEME_NAME} set"
    else
        log_fail "Current=${THEME_NAME} not set in ${SDDM_THEME_CONF}"
    fi

    if grep -q "QML2_IMPORT_PATH" "${SDDM_THEME_CONF}"; then
        log_ok "QML2_IMPORT_PATH set"
    else
        log_warn "QML2_IMPORT_PATH not found in ${SDDM_THEME_CONF}"
    fi
}

check_hypr_scripts() {
    log_step "Theme scripts"

    if [[ -d "${HYPR_THEME_SCRIPTS_DEST}" ]]; then
        log_ok "Scripts directory exists: ${HYPR_THEME_SCRIPTS_DEST}"
    else
        log_fail "Scripts directory missing: ${HYPR_THEME_SCRIPTS_DEST}"
        return
    fi

    if [[ -f "${APPLY_SCRIPT}" ]]; then
        log_ok "sddm-theme-apply.sh present"
    else
        log_fail "sddm-theme-apply.sh missing"
    fi

    if [[ -x "${APPLY_SCRIPT}" ]]; then
        log_ok "sddm-theme-apply.sh is executable"
    else
        log_fail "sddm-theme-apply.sh is not executable"
    fi

    if [[ -f "${HYPR_THEME_SCRIPTS_DEST}/SddmColors.qml" ]]; then
        log_ok "SddmColors.qml present"
    else
        log_warn "SddmColors.qml missing (only required for matugen integrations)"
    fi

    if [[ -f "${HYPR_THEME_SCRIPTS_DEST}/generate_settings.py" ]]; then
        log_ok "generate_settings.py present"
    else
        log_warn "generate_settings.py missing (only required for ii + matugen integration)"
    fi
}

check_fonts() {
    log_step "Fonts"

    if [[ -d "${FONTS_DIR}" ]]; then
        log_ok "Font directory exists: ${FONTS_DIR}"
    else
        log_warn "Font directory missing: ${FONTS_DIR}"
    fi
}

check_matugen_conf() {
    log_step "Matugen configuration"

    if [[ ! -f "${MATUGEN_CONF}" ]]; then
        log_warn "${MATUGEN_CONF} not found (only required for matugen integrations)"
        return
    fi

    log_ok "${MATUGEN_CONF} present"

    if grep -q "^\[templates\.iisddmtheme\]" "${MATUGEN_CONF}"; then
        log_ok "[templates.iisddmtheme] block found"
    else
        log_warn "[templates.iisddmtheme] block missing (only required for matugen integrations)"
    fi
}

check_sudoers() {
    log_step "Sudoers"

    if sudo test -f "${SUDOERS_FILE}"; then
        log_ok "Sudoers rule exists: ${SUDOERS_FILE}"
    else
        log_warn "Sudoers rule missing: ${SUDOERS_FILE} (only required for matugen integrations)"
        return
    fi

    if sudo visudo -c -f "${SUDOERS_FILE}" >/dev/null 2>&1; then
        log_ok "Sudoers rule is valid"
    else
        log_fail "Sudoers rule failed validation"
    fi
}

check_sddm_service() {
    log_step "SDDM service"

    if systemctl is-enabled sddm.service >/dev/null 2>&1; then
        log_ok "sddm.service is enabled"
    else
        log_warn "sddm.service is not enabled"
    fi
}

# === MAIN ===

main() {
    clear
    printf "\n"
    printf "${STY_CYAN}CHECK ii-sddm-theme${STY_RST}\n"
    printf "\n"

    check_dependencies
    check_sddm_theme
    check_sddm_conf
    check_hypr_scripts
    check_fonts
    check_matugen_conf
    check_sudoers
    check_sddm_service

    printf "\n-- Result\n"
    printf "  Failures : ${STY_RED}%d${STY_RST}\n" "${failures}"
    printf "  Warnings : ${STY_YELLOW}%d${STY_RST}\n" "${warnings}"

    if [[ "${failures}" -gt 0 ]]; then
        printf "\n  ${STY_RED}Some checks failed. Run setup.sh to repair the installation.${STY_RST}\n"
        exit 1
    elif [[ "${warnings}" -gt 0 ]]; then
        printf "\n  ${STY_YELLOW}Installation looks good, but review the warnings above.${STY_RST}\n"
    else
        printf "\n  ${STY_GREEN}All checks passed.${STY_RST}\n"
    fi
}

main "$@"
