#!/usr/bin/env bash
set -euo pipefail

# === CONFIGURATION ===

readonly THEME_NAME="ii-sddm-theme"
readonly THEME_REPO="https://github.com/3d3f/ii-sddm-theme"

readonly SDDM_THEMES_DIR="/usr/share/sddm/themes"
readonly SDDM_THEME_DEST="${SDDM_THEMES_DIR}/${THEME_NAME}"
readonly SDDM_CONF_DIR="/etc/sddm.conf.d"
readonly SDDM_THEME_CONF="${SDDM_CONF_DIR}/ii-sddm-theme.conf"

readonly HYPR_SCRIPTS_BASE="${HOME}/.config"
readonly HYPR_THEME_SCRIPTS_DEST="${HYPR_SCRIPTS_BASE}/${THEME_NAME}"

readonly DATE=$(date +%s)
readonly CLONE_DIR="/tmp/${THEME_NAME}-repo-${DATE}"

readonly USERNAME="${USER}"
readonly APPLY_SCRIPT="${HYPR_THEME_SCRIPTS_DEST}/sddm-theme-apply.sh"
readonly SUDOERS_FILE="/etc/sudoers.d/sddm-theme-${USERNAME}"

readonly MATUGEN_QML_INPUT_TEMPLATE="${HYPR_THEME_SCRIPTS_DEST}/SddmColors.qml"
readonly MATUGEN_GENERATE_SETTINGS_SCRIPT="${HYPR_THEME_SCRIPTS_DEST}/generate_settings.py"
readonly MATUGEN_CONF="${HOME}/.config/matugen/config.toml"

readonly II_CONFIG_JSON="${HOME}/.config/illogical-impulse/config.json"

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

# Global flags

II_CONFIG_FOUND=false
MATUGEN_CONFIG_FOUND=false
INSTALLATION_TYPE="no-matugen"

# === BANNER ===

show_banner() {
    local title=" SETUP ii-sddm-theme "
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
    show_banner
    printf "This script will install ii-sddm-theme.\n"
    printf "\n"
    printf "  ${STY_YELLOW}Note:${STY_RST} Please check what the script will do before running it.\n"
    printf "\n"
    read -r -p "===> Continue? [y/n]: " p
    case $p in
        y|Y) ;;
        *)
            log_error "Installation aborted by user."
            exit 0
            ;;
    esac
}

# === GUARDS ===

check_requirements() {
    log_step "Preliminary checks"
    if [[ $EUID -eq 0 ]]; then
        log_error "Do not run this script as root. It will use sudo when needed."
        exit 1
    fi
    if ! sudo -v; then
        log_error "sudo authentication failed."
        exit 1
    fi
    log_ok "Environment check passed"
}

# === AUR HELPER DETECTION ===

get_aur_helper() {
    log_step "Checking for AUR helper"
    if command -v yay &>/dev/null; then
        log_ok "AUR helper 'yay' found."
    elif command -v paru &>/dev/null; then
        log_ok "AUR helper 'paru' found."
    else
        log_error "No AUR helper (yay or paru) found. Please install one to proceed."
        exit 1
    fi
}

# === GIT CHECK ===

check_git() {
    log_step "Checking for git"
    if ! command -v git &>/dev/null; then
        log_warn "git is not installed."
        read -r -p "===> git is required to clone the theme. Install it now? [y/n]: " p
        case $p in
            y|Y)
                sudo pacman -S --needed git
                log_ok "git installed successfully."
                ;;
            *)
                log_error "git is required. Installation aborted."
                exit 1
                ;;
        esac
    else
        log_ok "git is already installed."
    fi
}

# === SDDM CHECK ===

check_sddm_installation() {
    log_step "Checking SDDM installation"
    if ! command -v sddm &>/dev/null; then
        log_warn "SDDM is not currently installed on your system."
        log_warn "The script will proceed to install and configure SDDM along with the theme."
        read -r -p "===> Continue with SDDM installation and theme setup? [y/n]: " p
        case $p in
            y|Y) ;;
            *)
                log_error "Installation aborted by user. SDDM is required for this theme."
                exit 0
                ;;
        esac
    else
        log_ok "SDDM is already installed."
    fi
}

# === FONT INSTALLATION ===

install_fonts() {
    log_step "Installing fonts"

    local repo_fonts="${CLONE_DIR}/fonts/ii-sddm-theme-fonts"

    if [[ -d "${repo_fonts}" ]]; then
        log_info "Copying fonts from ${repo_fonts} to /usr/share/fonts/..."
        sudo rm -rf /usr/share/fonts/ii-sddm-theme-fonts
        sudo cp -r "${repo_fonts}" /usr/share/fonts/
        log_info "Setting permissions..."
        sudo chown -R root:root /usr/share/fonts/ii-sddm-theme-fonts
        sudo find /usr/share/fonts/ii-sddm-theme-fonts -type d -exec chmod 755 {} \;
        sudo find /usr/share/fonts/ii-sddm-theme-fonts -type f -exec chmod 644 {} \;
        log_info "Updating font cache..."
        sudo fc-cache -f > /dev/null
        log_ok "Fonts installed."
    else
        log_warn "Fonts folder not found in the repository. Skipping font installation."
    fi
}

# === INSTALLATION TYPE SELECTION ===

detect_configs_and_select_installation_type() {
    log_step "Detecting existing configurations for optional features"

    if [[ -f "${II_CONFIG_JSON}" ]]; then
        II_CONFIG_FOUND=true
        log_ok "ii config file found: ${II_CONFIG_JSON}"
    else
        log_info "ii config file not found."
    fi

    if [[ -f "${MATUGEN_CONF}" ]]; then
        MATUGEN_CONFIG_FOUND=true
        log_ok "Matugen config file found: ${MATUGEN_CONF}"
    else
        log_info "Matugen config file not found."
    fi

    printf "\n"
    printf -- "-- Installation type\n"
    printf "\n"
    printf "Please select your preferred installation mode:\n"
    printf "\n"

    local option_num=1
    declare -A option_map

    if "${II_CONFIG_FOUND}" && "${MATUGEN_CONFIG_FOUND}"; then
        printf "  ${STY_GREEN}[%s]${STY_RST} ii + Matugen Integration\n" "${option_num}"
        printf "      └─ Sync ii settings, wallpaper and colors automatically\n"
        option_map[$option_num]="ii-matugen"
        ((option_num++))
        printf "\n"

        printf "  ${STY_GREEN}[%s]${STY_RST} Matugen Integration Only\n" "${option_num}"
        printf "      └─ Wallpaper and colors generated through matugen, manual settings configuration\n"
        option_map[$option_num]="matugen-only"
        ((option_num++))
        printf "\n"

        printf "  ${STY_GREEN}[%s]${STY_RST} Manual Configuration\n" "${option_num}"
        printf "      └─ Manual background, colors and settings configuration\n"
        option_map[$option_num]="no-matugen"
        ((option_num++))

    elif "${MATUGEN_CONFIG_FOUND}"; then
        printf "  ${STY_GREEN}[%s]${STY_RST} Matugen Integration\n" "${option_num}"
        printf "      └─ Wallpaper and colors generated through matugen, manual settings configuration\n"
        option_map[$option_num]="matugen-only"
        ((option_num++))
        printf "\n"

        printf "  ${STY_GREEN}[%s]${STY_RST} Manual Configuration\n" "${option_num}"
        printf "      └─ Full manual control: background, colors and settings\n"
        option_map[$option_num]="no-matugen"
        ((option_num++))

    else
        printf "  ${STY_GREEN}[%s]${STY_RST} Manual Configuration\n" "${option_num}"
        printf "      └─ Manual background, colors and settings configuration\n"
        option_map[$option_num]="no-matugen"
        ((option_num++))
    fi

    printf "\n"

    local selected_option
    local max_option=$((option_num - 1))
    local range_str
    range_str=$(seq -s "-" 1 $((option_num - 1)))

    while true; do
        read -r -p "===> [${range_str}]: " selected_option
        if [[ "${selected_option}" =~ ^[0-9]+$ ]] && [[ -n "${option_map[$selected_option]:-}" ]]; then
            INSTALLATION_TYPE="${option_map[$selected_option]}"
            printf "\n"
            log_ok "Selected installation type: ${INSTALLATION_TYPE}"
            break
        else
            log_error "Invalid choice. Please enter a number between 1 and ${max_option}."
        fi
    done

    printf "\n"
}

# === DEPENDENCIES INSTALLATION ===

install_deps() {
    log_step "Installing dependencies"
    log_info "Installing official Arch repositories packages..."
    sudo pacman -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg

    install_fonts

    log_ok "Dependencies installed successfully"
}

# === REPO CLONING ===

clone_repo_to_temp() {
    log_step "Cloning repository to temporary directory"

    log_info "Cloning ${THEME_REPO} into temporary directory ${CLONE_DIR}..."
    if ! git clone --depth 1 "${THEME_REPO}" "${CLONE_DIR}"; then
        log_error "Failed to clone theme repository. Please check your internet connection and the repository URL."
        exit 1
    fi
    log_ok "Theme repository cloned successfully to ${CLONE_DIR}."
}

# === COPY SPECIFIC FILES TO HYPR SCRIPTS ===

copy_specific_files_to_hypr() {
    log_step "Copying specific files to Hyprland custom scripts (${HYPR_THEME_SCRIPTS_DEST})"

    if [[ -d "${HYPR_THEME_SCRIPTS_DEST}" ]]; then
        log_warn "Existing theme scripts directory found at ${HYPR_THEME_SCRIPTS_DEST}. Removing it before copying new files."
        rm -rf "${HYPR_THEME_SCRIPTS_DEST}"
        log_ok "Old theme scripts directory removed."
    fi

    mkdir -p "${HYPR_THEME_SCRIPTS_DEST}"

    local source_dir=""
    case "${INSTALLATION_TYPE}" in
        "ii-matugen")
            source_dir="${CLONE_DIR}/iiMatugen"
            log_info "Copying files for 'ii + Matugen Integration' from ${source_dir}..."
            ;;
        "matugen-only")
            source_dir="${CLONE_DIR}/Matugen"
            log_info "Copying files for 'Matugen Integration Only' from ${source_dir}..."
            ;;
        "no-matugen")
            source_dir="${CLONE_DIR}/noMatugen"
            log_info "Copying files for 'No Matugen Integration' from ${source_dir}..."
            ;;
        *)
            log_error "Unknown installation type: ${INSTALLATION_TYPE}. No files copied to Hyprland scripts."
            return 1
            ;;
    esac

    if [[ -d "${source_dir}" ]]; then
        cp -r "${source_dir}"/* "${HYPR_THEME_SCRIPTS_DEST}/"
        log_ok "All files from '${source_dir}' copied to '${HYPR_THEME_SCRIPTS_DEST}'."
    else
        log_error "Source directory '${source_dir}' not found. Cannot copy files for '${INSTALLATION_TYPE}'."
        return 1
    fi

    if [[ -f "${APPLY_SCRIPT}" ]]; then
        chmod +x "${APPLY_SCRIPT}"
        log_ok "Made ${APPLY_SCRIPT} executable."
    fi

    if [[ "${INSTALLATION_TYPE}" == "ii-matugen" ]] && [[ -f "${MATUGEN_GENERATE_SETTINGS_SCRIPT}" ]]; then
        chmod +x "${MATUGEN_GENERATE_SETTINGS_SCRIPT}"
        log_ok "Made ${MATUGEN_GENERATE_SETTINGS_SCRIPT} executable."
    fi

    log_ok "Specific files copied and permissions set in ${HYPR_THEME_SCRIPTS_DEST}."
}

# === SDDM THEME INSTALLATION ===

install_theme() {
    log_step "Installing SDDM theme files to SDDM directory"

    if [[ -d "${SDDM_THEME_DEST}" ]]; then
        log_warn "Existing SDDM theme '${THEME_NAME}' detected in ${SDDM_THEMES_DIR}. Overwriting it."
        sudo rm -rf "${SDDM_THEME_DEST}"
    fi

    sudo mkdir -p "${SDDM_THEME_DEST}"
    sudo cp -r "${CLONE_DIR}"/* "${SDDM_THEME_DEST}/"

    log_ok "SDDM theme '${THEME_NAME}' installed to ${SDDM_THEME_DEST}."
}

# === SDDM CONFIGURATION ===

configure_sddm() {
    log_step "Configuring SDDM"

    log_info "Creating SDDM configuration drop-in file..."

    sudo mkdir -p "${SDDM_CONF_DIR}"

    sudo tee "${SDDM_THEME_CONF}" >/dev/null <<EOF
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/ii-sddm-theme/Components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=ii-sddm-theme
EOF

    log_ok "SDDM configuration written to ${SDDM_THEME_CONF}"
}

# === ENABLE SDDM ===

enable_sddm() {
    log_step "Enabling SDDM"
    sudo systemctl disable display-manager.service 2>/dev/null || true
    sudo systemctl enable sddm.service
    log_ok "SDDM enabled. It will start on next boot."
}

# === MATUGEN CONFIGURATION ===

configure_matugen() {
    log_step "Matugen integration"

    if [[ ! -f "${MATUGEN_QML_INPUT_TEMPLATE}" ]]; then
        log_error "Matugen input template file not found in ${HYPR_THEME_SCRIPTS_DEST}: ${MATUGEN_QML_INPUT_TEMPLATE}."
        log_error "This indicates an issue with copying selected Matugen files or an unexpected installation type."
        return 1
    fi

    mkdir -p "$(dirname "${MATUGEN_CONF}")"
    touch "${MATUGEN_CONF}"

    local input_path_tilde="~/.config/${THEME_NAME}/SddmColors.qml"
    local output_path_tilde="~/.config/${THEME_NAME}/Colors.qml"
    local post_hook_command=""

    if [[ "${INSTALLATION_TYPE}" == "ii-matugen" ]]; then
        if [[ ! -f "${MATUGEN_GENERATE_SETTINGS_SCRIPT}" ]]; then
            log_error "Python script ${MATUGEN_GENERATE_SETTINGS_SCRIPT} not found for ii-matugen integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        if [[ ! -f "${APPLY_SCRIPT}" ]]; then
            log_error "Apply script ${APPLY_SCRIPT} not found for ii-matugen integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        post_hook_command="python3 ~/.config/${THEME_NAME}/generate_settings.py && sudo ~/.config/${THEME_NAME}/sddm-theme-apply.sh &"
    elif [[ "${INSTALLATION_TYPE}" == "matugen-only" ]]; then
        if [[ ! -f "${APPLY_SCRIPT}" ]]; then
            log_error "Apply script ${APPLY_SCRIPT} not found for Matugen-only integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        post_hook_command="sudo ~/.config/${THEME_NAME}/sddm-theme-apply.sh &"
    fi

    # Remove existing [templates.iisddmtheme] block
    if grep -q "^\[templates\.iisddmtheme\]" "${MATUGEN_CONF}"; then
        log_info "Found existing [templates.iisddmtheme] block. Removing it..."

        local temp_file
        temp_file=$(mktemp)
        awk '
            /^\[templates\.iisddmtheme\]/ { skip=1; next }
            /^\[/ { skip=0 }
            !skip { print }
        ' "${MATUGEN_CONF}" >"${temp_file}"
        sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "${temp_file}"
        mv "${temp_file}" "${MATUGEN_CONF}"
        log_ok "Previous [templates.iisddmtheme] block removed."
    fi

    cat >>"${MATUGEN_CONF}" <<EOF

[templates.iisddmtheme]
input_path = '${input_path_tilde}'
output_path = '${output_path_tilde}'
post_hook = '${post_hook_command}'
EOF
    log_ok "New SDDM template block added to Matugen config: ${MATUGEN_CONF}"

    if command -v matugen &>/dev/null; then
        if [[ "${INSTALLATION_TYPE}" == "ii-matugen" ]]; then
            local current_wallpaper
            current_wallpaper=$(cat "${HOME}/.local/state/quickshell/user/generated/wallpaper/path.txt" 2>/dev/null || echo "")
            if [[ -f "${current_wallpaper}" ]]; then
                log_info "Running matugen with current wallpaper to initialize SDDM theme: ${current_wallpaper}"
                matugen image "${current_wallpaper}" --source-color-index 0
            else
                log_warn "Could not detect current wallpaper. You may need to change your wallpaper once to trigger Matugen for SDDM theme synchronization."
            fi
        elif [[ "${INSTALLATION_TYPE}" == "matugen-only" ]]; then
            log_info "Run 'matugen image <your-wallpaper-path>' once to initialize the SDDM theme."
        fi
    fi

    return 0
}

# === SUDOERS CONFIGURATION ===

setup_sudoers() {
    log_step "Configuring sudoers for passwordless execution"
    if [[ ! -f "${APPLY_SCRIPT}" ]]; then
        log_warn "Apply script not found at expected path (${APPLY_SCRIPT}). Sudoers configuration cannot proceed."
        return 0
    fi

    local sudoers_rule="${USERNAME} ALL=(ALL) NOPASSWD: ${APPLY_SCRIPT}"
    local temp_file
    temp_file=$(mktemp)

    printf '%s\n' "${sudoers_rule}" >"${temp_file}"

    if ! visudo -c -f "${temp_file}" >/dev/null 2>&1; then
        log_error "Invalid sudoers rule generated. Aborting sudoers configuration."
        rm -f "${temp_file}"
        return 1
    fi

    sudo cp "${temp_file}" "${SUDOERS_FILE}"
    sudo chmod 0440 "${SUDOERS_FILE}"
    rm -f "${temp_file}"

    log_ok "Sudoers configured: ${USERNAME} can run ${APPLY_SCRIPT} without password."
}

# === MAIN ===

main() {
    introduction
    check_requirements
    get_aur_helper
    check_git
    check_sddm_installation

    clone_repo_to_temp

    detect_configs_and_select_installation_type

    install_deps
    install_theme

    configure_sddm
    enable_sddm

    copy_specific_files_to_hypr

    if [[ "${INSTALLATION_TYPE}" == "ii-matugen" || "${INSTALLATION_TYPE}" == "matugen-only" ]]; then
        configure_matugen
        setup_sudoers

        log_step "Applying SDDM theme"
        if [[ -f "${APPLY_SCRIPT}" ]]; then
            if [[ "${INSTALLATION_TYPE}" == "ii-matugen" ]]; then
                if ! python3 "${MATUGEN_GENERATE_SETTINGS_SCRIPT}" > /dev/null 2>&1; then
                    log_warn "generate_settings.py failed. Theme application might be incomplete."
                fi
            fi

            if sudo bash "${APPLY_SCRIPT}" >/dev/null 2>&1 || true; then
                log_ok "Theme applied."
            else
                log_warn "Failed to apply theme automatically. Run manually: sudo ${APPLY_SCRIPT}"
            fi
        else
            log_warn "Apply script not found at ${APPLY_SCRIPT}. Theme will be applied on next Matugen run."
        fi

    elif [[ "${INSTALLATION_TYPE}" == "no-matugen" ]]; then
        log_step "Applying SDDM theme"
        if [[ -f "${APPLY_SCRIPT}" ]]; then
            if sudo bash "${APPLY_SCRIPT}" >/dev/null 2>&1 || true; then
                log_ok "Theme applied."
            else
                log_warn "Failed to apply theme automatically. Run manually: sudo ${APPLY_SCRIPT}"
            fi
        else
            log_warn "Apply script not found at ${APPLY_SCRIPT}. Theme application skipped."
        fi
    fi
    
    local msg=" Installation completed successfully "
    local width=${#msg}
    local border
    border=$(printf '─%.0s' $(seq 1 $width))
    printf "\n"
    printf "  ${STY_GREEN}┌%s┐${STY_RST}\n" "${border}"
    printf "  ${STY_GREEN}│%s│${STY_RST}\n" "${msg}"
    printf "  ${STY_GREEN}└%s┘${STY_RST}\n" "${border}"
    printf "\n"

    printf -- "-- Optional: Test the theme with the following command:\n"
    printf "   ${STY_YELLOW}sddm-greeter-qt6 --test-mode --theme %s${STY_RST}\n" "${SDDM_THEME_DEST}"
    log_info "Test mode will open fullscreen. Appearance may have minor differences from the actual login screen."
    printf "\n"

    printf -- "-- Reboot your system\n"
    log_warn "Please REBOOT your system to apply the new SDDM theme and configurations."

    if [[ -d "${CLONE_DIR}" ]]; then
        rm -rf "${CLONE_DIR}"
    fi
}

main "$@"
