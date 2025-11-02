#!/bin/bash

## TODO support for other distros

set -euo pipefail

# === CONFIGURATION ===
readonly THEME_NAME="ii-sddm-theme"
readonly THEME_REPO="https://github.com/3d3f/ii-sddm-theme" 

# SDDM directory
readonly SDDM_THEMES_DIR="/usr/share/sddm/themes"
readonly SDDM_THEME_DEST="$SDDM_THEMES_DIR/$THEME_NAME"

# Theme's local copy directory (for specific files)
readonly HYPR_SCRIPTS_BASE="$HOME/.config/hypr/custom/scripts"
# The destination inside HYPR_SCRIPTS_BASE for theme-related files
readonly HYPR_THEME_SCRIPTS_DEST="$HYPR_SCRIPTS_BASE/$THEME_NAME" 

# Temp directory
readonly DATE=$(date +%s)
readonly CLONE_DIR="/tmp/$THEME_NAME-repo-$DATE" 

readonly SDDM_CONF="/etc/sddm.conf"
readonly QML_PATH="$SDDM_THEME_DEST/Components/" 
readonly VIRTUAL_KEYBOARD="qtvirtualkeyboard"

# Sudoers configuration
readonly USERNAME="$USER"
readonly APPLY_SCRIPT="$HYPR_THEME_SCRIPTS_DEST/sddm-theme-apply.sh" 
readonly SUDOERS_FILE="/etc/sudoers.d/sddm-theme-$USERNAME"

# Matugen configuration 
readonly MATUGEN_QML_INPUT_TEMPLATE="$HYPR_THEME_SCRIPTS_DEST/SddmColors.qml" 
readonly MATUGEN_QML_OUTPUT_FILE="$SDDM_THEME_DEST/Components/Colors.qml" 
readonly MATUGEN_GENERATE_SETTINGS_SCRIPT="$HYPR_THEME_SCRIPTS_DEST/generate_settings.py" 
readonly MATUGEN_CONF="$HOME/.config/matugen/config.toml"

# ii configuration files
readonly II_CONFIG_JSON="$HOME/.config/illogical-impulse/config.json"

# Font dependencies (AUR)
readonly AUR_FONTS=(
  otf-space-grotesk
  ttf-gabarito-git
  ttf-material-symbols-variable-git
  ttf-readex-pro
  ttf-rubik-vf
)

# === COLORS ===
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# === LOGGING ===
info() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠  $*${NC}" >&2; }
error() { echo -e "${RED}❌ $*${NC}" >&2; }
step() { echo -e "\n${BLUE}━━━ $* ━━━${NC}"; }

# Global flags to control integration types
II_CONFIG_FOUND=false
MATUGEN_CONFIG_FOUND=false
INSTALLATION_TYPE="no-matugen"

# === INTRODUCTION ===
introduction() {
    clear
    echo -e "${BLUE}"
    echo "╔═════════════════════════════════════════════════════════╗"
    echo "║                ii-sddm-theme Installer                  ║"
    echo "╚═════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "This script will install the ii-sddm-theme."
    echo
    echo -e "${YELLOW}Note:${NC} Please check what the scripts will do before running it."
    echo
    read -p "Do you want to proceed with the installation? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        error "Installation aborted by user."
        exit 0
    fi
}

# === PRELIMINARY CHECKS ===
check_requirements() {
    step "Preliminary checks"
    if [[ $EUID -eq 0 ]]; then
        error "Do not run this script as root. It will use sudo when needed."
        exit 1
    fi
    info "Environment check passed"
}

# === AUR HELPER DETECTION ===
get_aur_helper() {
    step "Checking for AUR helper"
    if command -v yay &>/dev/null; then
        info "AUR helper 'yay' found."
        echo "yay"
    elif command -v paru &>/dev/null; then
        info "AUR helper 'paru' found."
        echo "paru"
    else
        error "No AUR helper (yay or paru) found. Please install one to proceed with font installation."
        exit 1
    fi
}

# === SDDM INSTALLATION CHECK ===
check_sddm_installation() {
    step "Checking SDDM installation"
    if ! command -v sddm &>/dev/null; then
        warn "SDDM is not currently installed on your system."
        warn "The script will proceed to install and configure SDDM along with the theme."
        read -p "Do you wish to continue with SDDM installation and theme setup? (y/n): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            error "Installation aborted by user. SDDM is required for this theme."
            exit 0
        fi
    else
        info "SDDM is already installed."
    fi
}

# === CONFIGURATION FILE DETECTION AND INSTALLATION TYPE SELECTION ===
detect_configs_and_select_installation_type() {
    step "Detecting existing configurations for optional features"

    # Detect configuration files
    if [[ -f "$II_CONFIG_JSON" ]]; then
        II_CONFIG_FOUND=true
        info "ii config file found: $II_CONFIG_JSON"
    else
        info "ii config file not found."
    fi

    if [[ -f "$MATUGEN_CONF" ]]; then
        MATUGEN_CONFIG_FOUND=true
        info "Matugen config file found: $MATUGEN_CONF"
    else
        info "Matugen config file not found."
    fi

    # Display installation options menu
    echo
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                      INSTALLATION TYPE SELECTION                          ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "Please select your preferred installation mode:"
    echo

    local option_num=1
    declare -A option_map

    # Build menu based on available configurations
    if "$II_CONFIG_FOUND" && "$MATUGEN_CONFIG_FOUND"; then
        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}ii + Matugen Integration${NC}"
        echo -e "      └─ Settings, wallpaper and colors generated from ii app"
        option_map[$option_num]="ii-matugen"
        ((option_num++))
        echo

        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}Matugen Integration Only${NC}"
        echo -e "      └─ Wallpaper and colors generated through matugen, manual settings configuration"
        option_map[$option_num]="matugen-only"
        ((option_num++))
        echo

        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}Manual Configuration${NC}"
        echo -e "      └─ Manual background, colors and settings configuration"
        option_map[$option_num]="no-matugen"
        ((option_num++))

    elif "$MATUGEN_CONFIG_FOUND"; then
        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}Matugen Integration${NC}"
        echo -e "      └─ Wallpaper and colors generated through matugen, manual settings configuration"
        option_map[$option_num]="matugen-only"
        ((option_num++))
        echo

        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}Manual Configuration${NC}"
        echo -e "      └─ Full manual control: background, colors and settings"
        option_map[$option_num]="no-matugen"
        ((option_num++))

    else
        echo -e "${GREEN}  [$option_num]${NC} ${BLUE}Manual Configuration${NC}"
        echo -e "      └─ Manual background, colors and settings configuration"
        option_map[$option_num]="no-matugen"
        ((option_num++))
    fi

    echo
    echo -e "${BLUE}───────────────────────────────────────────────────────────────────────────${NC}"
    echo

    # Get user selection
    local selected_option
    local max_option=$((option_num - 1))
    
    while true; do
        read -p "$(echo -e "${YELLOW}→${NC} Enter your choice [1-$max_option]: ")" selected_option
        
        if [[ "$selected_option" =~ ^[0-9]+$ ]] && [[ -n "${option_map[$selected_option]}" ]]; then
            INSTALLATION_TYPE="${option_map[$selected_option]}"
            echo
            info "Selected installation type: ${BLUE}$INSTALLATION_TYPE${NC}"
            break
        else
            error "Invalid choice. Please enter a number between 1 and $max_option."
        fi
    done
    
    echo
}

# === DEPENDENCIES INSTALLATION ===
install_deps() {
    step "Installing dependencies"
    info "Installing official Arch repositories packages..."
    sudo pacman -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg

    local aur_helper
    aur_helper=$(get_aur_helper | tail -n 1)
    info "Using AUR helper: $aur_helper. Installing AUR font packages..."
    "$aur_helper" -S --needed "${AUR_FONTS[@]}" --noconfirm 
    
    info "Dependencies installed successfully"
}

# === REPO CLONING (only to temp) ===
clone_repo_to_temp() {
    step "Cloning repository to temporary directory"
    
    info "Cloning $THEME_REPO into temporary directory $CLONE_DIR..."
    git clone --depth 1 "$THEME_REPO" "$CLONE_DIR"
    if [[ $? -ne 0 ]]; then
        error "Failed to clone theme repository. Please check your internet connection and the repository URL."
        exit 1
    fi
    info "Theme repository cloned successfully to $CLONE_DIR."
}

# === COPY SPECIFIC FILES TO HYPR CUSTOM SCRIPTS ===
copy_specific_files_to_hypr() {
    step "Copying specific files to Hyprland custom scripts ($HYPR_THEME_SCRIPTS_DEST)"
    
    # Delete existing directory if it exists
    if [[ -d "$HYPR_THEME_SCRIPTS_DEST" ]]; then
        warn "Existing theme scripts directory found at $HYPR_THEME_SCRIPTS_DEST. Removing it before copying new files."
        rm -rf "$HYPR_THEME_SCRIPTS_DEST"
        info "Old theme scripts directory removed."
    fi
    
    mkdir -p "$HYPR_THEME_SCRIPTS_DEST"

    # Source directories are now relative to CLONE_DIR
    local source_dir=""
    case "$INSTALLATION_TYPE" in
        "ii-matugen")
            source_dir="$CLONE_DIR/iiMatugen"
            info "Copying files for 'ii + Matugen Integration' from $source_dir..."
            ;;
        "matugen-only")
            source_dir="$CLONE_DIR/Matugen"
            info "Copying files for 'Matugen Integration Only' from $source_dir..."
            ;;
        "no-matugen")
            source_dir="$CLONE_DIR/noMatugen"
            info "Copying files for 'No Matugen Integration' from $source_dir..."
            ;;
        *)
            error "Unknown installation type: $INSTALLATION_TYPE. No files copied to Hyprland scripts."
            return 1
            ;;
    esac

    # Copy files from the source directory
    if [[ -d "$source_dir" ]]; then
        cp -r "$source_dir"/* "$HYPR_THEME_SCRIPTS_DEST/"
        info "All files from '$source_dir' copied to '$HYPR_THEME_SCRIPTS_DEST'."
    else
        error "Source directory '$source_dir' not found. Cannot copy files for '$INSTALLATION_TYPE'."
        return 1
    fi

    # Ensure relevant scripts are executable
    if [[ -f "$APPLY_SCRIPT" ]]; then
        chmod +x "$APPLY_SCRIPT"
        info "Made $APPLY_SCRIPT executable."
    fi
    # Only make generate_settings.py executable if ii-matugen was chosen
    if [[ "$INSTALLATION_TYPE" == "ii-matugen" ]] && [[ -f "$MATUGEN_GENERATE_SETTINGS_SCRIPT" ]]; then
        chmod +x "$MATUGEN_GENERATE_SETTINGS_SCRIPT"
        info "Made $MATUGEN_GENERATE_SETTINGS_SCRIPT executable."
    fi

    info "Specific files copied and permissions set in $HYPR_THEME_SCRIPTS_DEST."
}

# === SDDM THEME INSTALLATION (from temp directory) ===
install_theme() {
    step "Installing SDDM theme files to SDDM directory"
    
    # Check if the theme directory already exists
    if [[ -d "$SDDM_THEME_DEST" ]]; then
        warn "Existing SDDM theme '$THEME_NAME' detected in $SDDM_THEMES_DIR. Overwriting it."
        sudo rm -rf "$SDDM_THEME_DEST"
    fi
    
    # Create the destination directory and copy the theme
    sudo mkdir -p "$SDDM_THEME_DEST"
    sudo cp -r "$CLONE_DIR"/* "$SDDM_THEME_DEST/"
    
    info "SDDM theme '$THEME_NAME' installed to $SDDM_THEME_DEST."
}

# === SDDM CONFIGURATION ===
configure_sddm() {
    step "Configuring SDDM"

    # Ensure [General] section exists and add InputMethod/GreeterEnvironment
    if ! grep -q "^\[General\]" "$SDDM_CONF" 2>/dev/null; then
        echo "[General]" | sudo tee -a "$SDDM_CONF" > /dev/null
        info "Added [General] section to $SDDM_CONF"
    fi

    # Update or add InputMethod under [General]
    if grep -q "^\[General\]" "$SDDM_CONF" && grep -q "InputMethod=" "$SDDM_CONF"; then
        sudo sed -i "/^\[General\]/,/^\[/ s|^InputMethod=.*|InputMethod=$VIRTUAL_KEYBOARD|" "$SDDM_CONF"
    else
        sudo sed -i "/^\[General\]/a InputMethod=$VIRTUAL_KEYBOARD" "$SDDM_CONF"
    fi
    info "SDDM InputMethod set to $VIRTUAL_KEYBOARD"

    # Update or add GreeterEnvironment under [General]
    local greeter_env="QML2_IMPORT_PATH=$QML_PATH,QT_IM_MODULE=$VIRTUAL_KEYBOARD"
    if grep -q "^\[General\]" "$SDDM_CONF" && grep -q "GreeterEnvironment=" "$SDDM_CONF"; then
        sudo sed -i "/^\[General\]/,/^\[/ s|^GreeterEnvironment=.*|GreeterEnvironment=$greeter_env|" "$SDDM_CONF"
    else
        sudo sed -i "/^\[General\]/a GreeterEnvironment=$greeter_env" "$SDDM_CONF"
    fi
    info "SDDM GreeterEnvironment set to $greeter_env"

    # Ensure [Theme] section exists
    if ! grep -q "^\[Theme\]" "$SDDM_CONF" 2>/dev/null; then
        echo -e "\n[Theme]" | sudo tee -a "$SDDM_CONF" > /dev/null
        info "Added [Theme] section to $SDDM_CONF"
    fi

    # Set Current theme under [Theme]
    if grep -q "^\[Theme\]" "$SDDM_CONF" && grep -q "Current=" "$SDDM_CONF"; then
        sudo sed -i "/^\[Theme\]/,/^\[/ s|^Current=.*|Current=$THEME_NAME|" "$SDDM_CONF"
    else
        sudo sed -i "/^\[Theme\]/a Current=$THEME_NAME" "$SDDM_CONF"
    fi
    info "SDDM theme set to $THEME_NAME"

    info "SDDM configured successfully"
}

# === MATUGEN CONFIGURATION ===
configure_matugen() {
    step "Matugen integration"

    # Verify the matugen input template (SddmColors.qml) exists in the HYPR_THEME_SCRIPTS_DEST
    if [[ ! -f "$MATUGEN_QML_INPUT_TEMPLATE" ]]; then
        error "Matugen input template file not found in $HYPR_THEME_SCRIPTS_DEST: $MATUGEN_QML_INPUT_TEMPLATE."
        error "This indicates an issue with copying selected Matugen files or an unexpected installation type."
        return 1
    fi
    info "Verified Matugen color input template exists: $MATUGEN_QML_INPUT_TEMPLATE"

    # Ensure Matugen config directory and file exist
    mkdir -p "$(dirname "$MATUGEN_CONF")"
    touch "$MATUGEN_CONF"

    # Define the Matugen config block to add with tilde paths
    local input_path_tilde="~/.config/$THEME_NAME/SddmColors.qml" 
    local output_path_tilde="~/.config/$THEME_NAME/Colors.qml" 
    local post_hook_command=""
    
    if [[ "$INSTALLATION_TYPE" == "ii-matugen" ]]; then
        # For ii-matugen, both generate_settings.py and apply.sh are needed
        if [[ ! -f "$MATUGEN_GENERATE_SETTINGS_SCRIPT" ]]; then
            error "Python script $MATUGEN_GENERATE_SETTINGS_SCRIPT not found for ii-matugen integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        if [[ ! -f "$APPLY_SCRIPT" ]]; then
            error "Apply script $APPLY_SCRIPT not found for ii-matugen integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        # The post-hook now explicitly calls generate_settings.py before sddm-theme-apply.sh
        post_hook_command="python3 ~/.config/$THEME_NAME/generate_settings.py && sudo ~/.config/$THEME_NAME/sddm-theme-apply.sh &"
        info "Matugen post-hook will include ii clock and time settings generation via generate_settings.py."
    elif [[ "$INSTALLATION_TYPE" == "matugen-only" ]]; then
        # For matugen-only, only apply.sh is included in files_to_copy, so just use it
        if [[ ! -f "$APPLY_SCRIPT" ]]; then
            error "Apply script $APPLY_SCRIPT not found for Matugen-only integration. Skipping Matugen post-hook configuration."
            return 1
        fi
        post_hook_command="sudo ~/.config/$THEME_NAME/sddm-theme-apply.sh &"
        info "Matugen post-hook will apply theme changes via sddm-theme-apply.sh."
    fi

    # Remove existing [templates.iisddmtheme] block more robustly
    if grep -q "^\[templates\.iisddmtheme\]" "$MATUGEN_CONF"; then
        info "Found existing [templates.iisddmtheme] block. Removing it before adding the new configuration."
        
        local temp_file
        temp_file=$(mktemp)
        
        # Use awk to delete the section, regardless of its content
        awk '
            /^\[templates\.iisddmtheme\]/ {
                skip=1;
            }
            /^\[/ && !/^\[templates\.iisddmtheme\]/ {
                skip=0;
            }
            !skip {
                print;
            }
        ' "$MATUGEN_CONF" > "$temp_file"
        
        mv "$temp_file" "$MATUGEN_CONF"
        info "Previous [templates.iisddmtheme] block removed successfully."
    else
        info "No existing [templates.iisddmtheme] block found. Proceeding to add new configuration."
    fi

    # Add the new block
    local block_to_add="[templates.iisddmtheme]
input_path = '$input_path_tilde'
output_path = '$output_path_tilde'
post_hook = '$post_hook_command'"

    echo -e "\n$block_to_add" >> "$MATUGEN_CONF"
    info "New SDDM template block added to Matugen config: $MATUGEN_CONF"
    
    return 0
}

# === ENABLE SDDM ===
enable_sddm() {
    step "Enabling SDDM"
    info "Attempting to disable other display managers (if active)..."
    sudo systemctl disable display-manager.service 2>/dev/null || true
    info "Enabling sddm.service..."
    sudo systemctl enable sddm.service
    info "SDDM enabled successfully. It will start on next boot."
}

# === SUDOERS CONFIGURATION ===
setup_sudoers() {
    step "Configuring sudoers for passwordless execution"
    if [[ ! -f "$APPLY_SCRIPT" ]]; then
        warn "Apply script not found at expected path ($APPLY_SCRIPT). Sudoers configuration cannot proceed."
        return 0
    fi

    local SUDOERS_RULE="$USERNAME ALL=(ALL) NOPASSWD: $APPLY_SCRIPT"
    local TEMP_FILE
    TEMP_FILE=$(mktemp)

    echo "$SUDOERS_RULE" > "$TEMP_FILE"

    # Validate the rule with visudo before copying
    if ! visudo -c -f "$TEMP_FILE" >/dev/null 2>&1; then
        error "Invalid sudoers rule generated. Aborting sudoers configuration."
        rm -f "$TEMP_FILE"
        return 1
    fi
    
    # Copy the validated rule to the sudoers.d directory
    sudo cp "$TEMP_FILE" "$SUDOERS_FILE"
    sudo chmod 0440 "$SUDOERS_FILE"
    rm -f "$TEMP_FILE"
    
    info "Sudoers configured successfully. Rule added to $SUDOERS_FILE"
    info "Your user ($USERNAME) can now execute $APPLY_SCRIPT without a password using sudo."
}

# === MAIN EXECUTION ===
main() {
    introduction
    check_requirements
    get_aur_helper 
    check_sddm_installation 
    
    # Clone the repository FIRST to make source files available
    clone_repo_to_temp
    
    # Now, detect configurations and select the installation type
    detect_configs_and_select_installation_type
    
    install_deps 
    install_theme # Full theme installation to the SDDM directory

    configure_sddm
    enable_sddm
    
    # Copy specific files to Hyprland scripts based on the selected type
    copy_specific_files_to_hypr

    if [[ "$INSTALLATION_TYPE" == "ii-matugen" || "$INSTALLATION_TYPE" == "matugen-only" ]]; then
        configure_matugen
        setup_sudoers

        # Apply the theme immediately for Matugen integrations
        step "Applying SDDM theme"
        if [[ -f "$APPLY_SCRIPT" ]]; then
            info "Executing sddm-theme-apply.sh to apply theme settings..."
            if [[ "$INSTALLATION_TYPE" == "ii-matugen" ]]; then
                info "Executing generate_settings.py for ii-matugen integration..."
                if python3 "$MATUGEN_GENERATE_SETTINGS_SCRIPT"; then
                    info "generate_settings.py executed successfully."
                else
                    warn "Failed to execute generate_settings.py. Theme application might be incomplete."
                fi
            fi
            
            # Use 'sudo bash' and ignore non-critical exit codes
            if sudo bash "$APPLY_SCRIPT" >/dev/null 2>&1 || true; then
                info "Theme applied."
            else
                warn "Failed to apply theme automatically. You can run it manually later with: sudo $APPLY_SCRIPT"
            fi
        else
            warn "Apply script not found at $APPLY_SCRIPT. Theme will be applied on next Matugen run."
        fi
    elif [[ "$INSTALLATION_TYPE" == "no-matugen" ]]; then
        # no-matugen: no sudoers but theme apply yes
        step "Applying SDDM theme (no-matugen mode)"
        if [[ -f "$APPLY_SCRIPT" ]]; then
            info "Executing sddm-theme-apply.sh to apply theme settings..."
            # exec with sudo, it will ask for password
            if sudo bash "$APPLY_SCRIPT" >/dev/null 2>&1 || true; then
                info "Theme applied successfully."
            else
                warn "Failed to apply theme automatically. You can run it manually later with: sudo $APPLY_SCRIPT"
            fi
        else
            warn "Apply script not found at $APPLY_SCRIPT. Theme application skipped."
        fi
        info "Sudoers configuration skipped for no-matugen installation."
    fi


    echo
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗"
    echo -e "${GREEN}║       Installation completed successfully!       ║"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo
    
    # Suggest to test the theme
    local test_script="$SDDM_THEME_DEST/test.sh"
    if [[ -f "$test_script" ]]; then
    echo -e "${BLUE}━━━ Optional: Test the theme ━━━${NC}"
    info "You can test the SDDM theme before rebooting by running:"
    echo -e "  ${YELLOW}sddm-greeter-qt6 --test-mode --theme $SDDM_THEME_DEST${NC}"
    echo "This command allows you to preview the theme. Theme appearance in test mode might have minor differences from the actual login screen, but it will confirm if the theme loads correctly."
    echo "Test mode will open fullscreen"
    fi
    
    echo -e "${BLUE}━━━ Reboot your system ━━━${NC}"
    warn "Please REBOOT your system to apply the new SDDM theme and configurations."

    # Clean up the temporary directory
    if [[ -d "$CLONE_DIR" ]]; then
        info "Cleaning up temporary clone directory: $CLONE_DIR"
        rm -rf "$CLONE_DIR"
    fi
}

main "$@"