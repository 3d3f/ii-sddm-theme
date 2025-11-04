#!/usr/bin/env bash

# edited, original script from from uiriansan SilentSDDM (https://github.com/uiriansan/SilentSDDM/blob/main/change_avatar.sh)

# --- Color Configuration ---
green='\033[0;32m'
red='\033[0;31m'
cyan='\033[0;36m'
yellow='\033[1;33m'
reset="\033[0m"

# --- Utility Functions ---

# Function to check for dependencies
check_dependencies() {
    if ! command -v mogrify &> /dev/null; then
        echo -e "${red}Error: 'mogrify' (from ImageMagick) is not installed.${reset}"
        echo -e "Please install it before running the script."
        echo -e "On Debian/Ubuntu-based systems: ${cyan}sudo apt install imagemagick${reset}"
        echo -e "On Arch-based systems: ${cyan}sudo pacman -S imagemagick${reset}"
        echo -e "On Fedora-based systems: ${cyan}sudo dnf install ImageMagick${reset}"
        exit 1
    fi
}

# Function to process a single user's avatar
process_user_avatar() {
    local USERNAME="$1"
    local IMAGE_PATH="$2"
    local success_flag=0 # 0 for success, 1 for failure

    echo -e "\n${yellow}Processing user: ${USERNAME}${reset}"

    TARGET_PATH="/usr/share/sddm/faces/$USERNAME.face.icon"
    TEMP_FILE="/tmp/sddm_avatar_temp_$$"

    if [[ -f "$TARGET_PATH" ]]; then
        echo -e "${green}Existing avatar found for '$USERNAME'. It will be overwritten.${reset}"
    fi

    # Copy the source file to a temporary file to work on
    cp "$IMAGE_PATH" "$TEMP_FILE"

    # Crop image to square
    if ! mogrify -gravity center -crop 1:1 +repage "$TEMP_FILE"; then
        echo -e "${red}Error cropping the image with mogrify. The image might be corrupted or an unsupported format${reset}" 
        rm -f "$TEMP_FILE" # Clean up the temp file
        success_flag=1
    fi

    # Resize to 256x256, only if cropping was successful
    if [[ $success_flag -eq 0 ]]; then
        if ! mogrify -resize 256x256 "$TEMP_FILE"; then
            echo -e "${red}Error resizing the image with mogrify.${reset}"
            rm -f "$TEMP_FILE" # Clean up the temp file
            success_flag=1
        fi
    fi

    # Move the temporary file to the final destination with sudo privileges, only if previous steps were successful
    if [[ $success_flag -eq 0 ]]; then
        if ! sudo mv -f "$TEMP_FILE" "$TARGET_PATH"; then
            echo -e "${red}Error moving the processed image to '$TARGET_PATH'. Check permissions.${reset}"
            rm -f "$TEMP_FILE" # Clean up the temp file if mv failed
            success_flag=1
        fi
    fi

    # Set permissions, only if previous steps were successful
    if [[ $success_flag -eq 0 ]]; then
        if sudo chmod 644 "$TARGET_PATH"; then
            echo -e "${green}File permissions set correctly.${reset}"
        else
            echo -e "${red}Warning: Could not set permissions for '$TARGET_PATH'. SDDM might not display the avatar.${reset}"
            success_flag=1 # Consider it a partial failure if permissions can't be set
        fi
    fi

    # Final check and message
    if [[ $success_flag -eq 0 && -f "$TARGET_PATH" ]]; then
        echo -e "${green}Avatar successfully updated for user '$USERNAME'!${reset}"
        return 0 # Indicate overall success
    else
        echo -e "${red}Failed to update avatar for '$USERNAME'. Please check errors above.${reset}"
        rm -f "$TEMP_FILE" 2>/dev/null # Ensure temp file is cleaned up on failure
        return 1 # Indicate overall failure
    fi
}


# --- Main Logic ---

# 1. Check for necessary tools
check_dependencies

# --- IMPROVED INTRODUCTION ---
echo -e "${cyan}This script will guide you to change an SDDM user avatar.${reset}"
echo -e "${cyan}You can change avatars for multiple users, one at a time.${reset}"
echo -e "${cyan}Detecting system users...${reset}"

# 2. Get the list of real system users (UID >= 1000 with login shell)
mapfile -t system_users < <(getent passwd | awk -F: '$3 >= 1000 && ($7 ~ /bash/ || $7 ~ /zsh/ || $7 ~ /sh/) {print $1}' | sort)

if [ ${#system_users[@]} -eq 0 ]; then
    echo -e "${red}No valid users found on the system.${reset}"
    exit 1
fi

current_user=$(logname)

# Loop for selecting and processing users
while true; do
    echo -e "\n${cyan}--- User List ---${reset}"
    for i in "${!system_users[@]}"; do
        marker=" "
        if [[ "${system_users[$i]}" == "$current_user" ]]; then
            marker="*"
        fi
        echo "$((i+1))) $marker ${system_users[$i]}"
    done
    echo "-------------------"

    read -p "Enter the number of the user to change avatar for (or 'q' to exit): " choice

    # Check if the user wants to exit
    if [[ "$choice" =~ ^[qQ]$ ]]; then
        echo -e "\n${green}Operation complete! Exiting.${reset}"
        break
    fi

    # Check if the choice is a valid number
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#system_users[@]}" ]; then
        USERNAME="${system_users[$((choice-1))]}"
        echo -e "${cyan}You have selected user: ${USERNAME}${reset}"

        # Get the image path for the selected user
        IMAGE_PATH=""
        while true; do
            echo -e "\n${cyan}--- Provide the Image Path for ${USERNAME}---${reset}"
            echo -e "${yellow}Note: Some less common image formats may cause issues during processing.${reset}" 
            echo
            read -p "Drag an image file here or type the full path: " TEMP_IMAGE_PATH
            
            # Remove any single quotes that some terminals add with drag & drop
            TEMP_IMAGE_PATH=$(sed -e "s/^'//" -e "s/'$//" <<< "$TEMP_IMAGE_PATH")

            if [[ -f "$TEMP_IMAGE_PATH" ]]; then
                echo -e "${green}Image file found: $TEMP_IMAGE_PATH${reset}"
                IMAGE_PATH="$TEMP_IMAGE_PATH"
                break
            else
                echo -e "${red}Invalid image file or path not found. Please try again.${reset}"
            fi
        done

        # Process the avatar for the selected user
        process_user_avatar "$USERNAME" "$IMAGE_PATH"
        LAST_OPERATION_STATUS=$? # $? contiene il codice di uscita dell'ultimo comando

        # Ask if the user wants to continue or exit based on the status
        while true; do
            if [[ "$LAST_OPERATION_STATUS" -eq 0 ]]; then
                # Successo
                read -p "Avatar changed for ${USERNAME}. Do you want to change another user's avatar? (y/n): " continue_choice
            else
                # Fallimento
                read -p "Avatar update failed for ${USERNAME}. Do you want to try with another image or image format? (y/n): " continue_choice
            fi

            if [[ "$continue_choice" =~ ^[yY]$ ]]; then
                break # Break from this inner loop to go back to user selection
            elif [[ "$continue_choice" =~ ^[nN]$ ]]; then
                echo -e "\n${green}Operation complete! Exiting.${reset}"
                exit 0 # Exit the script
            else
                echo -e "${red}Invalid choice. Please enter 'y' or 'n'.${reset}"
            fi
        done

    else
        echo -e "${red}Invalid choice. Please enter a number from the list or 'q'.${reset}"
    fi
done