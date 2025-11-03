# ii-sddm-theme

https://github.com/user-attachments/assets/2af3d30f-c288-4a32-a9bf-4bec4c31490e

## Overview

[ii-sddm-theme](https://github.com/3d3f/ii-sddm-theme) is a custom theme for the [SDDM](https://github.com/sddm/sddm/) display manager that tries to replicate the lockscreen aesthetic and settings of [illogical impulse](https://github.com/end-4/dots-hyprland). It can be used with ii dotfiles, with [Matugen](https://github.com/InioX/matugen) only, or as a standalone theme.

I only have a basic understanding of Qt QML, so this project is a learning experience—piecing together code from various sources while figuring things out along the way.

**Currently supports:** Arch Linux + Hyprland, to be extended

---

## Acknowledgements

This theme wouldn't exist without these projects:

- **[illogical impulse](https://github.com/end-4/dots-hyprland)** – All the widgets code, the design and the creativeness comes from [end-4](https://github.com/end-4) repo
- **[sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme)** – The starting point for this theme
- **[SilentSDDM](https://github.com/uiriansan/SilentSDDM)** – Custom virtual keyboard implementation and various improvements
- **[matugen](https://github.com/InioX/matugen)** - Material You color palette generator
- **[qt/qtvirtualkeyboard](https://github.com/qt/qtvirtualkeyboard)** – Default virtual keyboard style template

---

## Features

Depending on your setup, you can choose from one to three different installation modes:

### ii + Matugen Integration
Settings, wallpaper, and colors automatically synced from ii configuration

<p align="left">
  <img src="https://github.com/3d3f/ii-sddm-theme/raw/main/Previews/iiMatugen-preview.png" width="50%" alt="ii + Matugen" />
</p>

### Matugen Integration Only
Wallpaper and colors generated via Matugen, with manual settings configuration

<p align="left">
  <img src="https://github.com/3d3f/ii-sddm-theme/raw/main/Previews/Matugen-preview.png" width="50%" alt="Matugen Only" />
</p>

### No Matugen Integration
Manually configure your background, colors, and settings

<p align="left">
  <img src="https://github.com/3d3f/ii-sddm-theme/raw/main/Previews/noMatugen-preview.png" width="50%" alt="Manual Configuration" />
</p>

---

## Installation

### Install Script

The script will detect your configuration and guide you through the installation:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/3d3f/ii-sddm-theme/main/setup.sh)"
```

> **Note:** Only Arch Linux + Hyprland is supported. Non-standard folder structures will require manual installation. If something goes wrong, please [open an issue](https://github.com/3d3f/ii-sddm-theme/issues/new/choose).

---

<details>
<summary><b>Manual Installation</b></summary>

<br>

Follow these steps for a manual installation. You'll choose your integration method after completing the initial setup.

### 1. Install Dependencies

**Arch Linux:**
```bash
yay -S --needed sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg otf-space-grotesk ttf-gabarito-git ttf-material-symbols-variable-git ttf-readex-pro ttf-rubik-vf
```

### 2. Clone the Repository

```bash
git clone -b main --depth=1 https://github.com/3d3f/ii-sddm-theme
cd ii-sddm-theme/
```

### 3. Test the Theme

```bash
./test.sh
```

> **Note:** The test appearance is not exactly representative of the theme look. If something goes wrong, [open an issue](https://github.com/3d3f/ii-sddm-theme/issues/new/choose).

---

### Choose Your Integration Method

Select **one** of the following installation types based on your needs:

<details>
<summary><b>ii + Matugen Integration</b></summary>

<br>

This option is for users who have both `illogical impulse` and `matugen` configured and want the SDDM theme to automatically match their Hyprland settings, wallpapers, and color schemes.

#### 4. Copy Integration Files

```bash
mkdir -p ~/.config/ii-sddm-theme/
cp -r iiMatugen/* ~/.config/ii-sddm-theme/
chmod +x ~/.config/ii-sddm-theme/sddm-theme-apply.sh
chmod +x ~/.config/ii-sddm-theme/generate_settings.py
```

#### 5. Install the Theme

```bash
sudo mkdir -p /usr/share/sddm/themes/ii-sddm-theme
sudo cp -rf . /usr/share/sddm/themes/ii-sddm-theme/
```

#### 6. Configure SDDM

Edit `/etc/sddm.conf` with your preferred editor:

```bash
sudo nano /etc/sddm.conf
```

Ensure these options are set:

```ini
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/ii-sddm-theme/Components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=ii-sddm-theme
```

#### 7. Configure Matugen

Add this block to `~/.config/matugen/config.toml`:

```toml
[templates.iisddmtheme]
input_path = '~/.config/ii-sddm-theme/SddmColors.qml'
output_path = '~/.config/ii-sddm-theme/Colors.qml'
post_hook = 'python3 ~/.config/ii-sddm-theme/generate_settings.py && sudo ~/.config/ii-sddm-theme/sddm-theme-apply.sh &'
```

#### 8. Configure Passwordless Sudo

Allow the apply script to run without a password prompt:

```bash
echo "$USER ALL=(ALL) NOPASSWD: /home/$USER/.config/ii-sddm-theme/sddm-theme-apply.sh" | sudo tee /etc/sudoers.d/sddm-theme-$USER > /dev/null
sudo chmod 0440 /etc/sudoers.d/sddm-theme-$USER
```

#### 9. Apply the Theme

```bash
python3 ~/.config/ii-sddm-theme/generate_settings.py
sudo ~/.config/ii-sddm-theme/sddm-theme-apply.sh
```

#### 10. Test the Theme

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/ii-sddm-theme
```

#### 11. Reboot

Restart your system to see the theme in action.

</details>

<details>
<summary><b>Matugen Integration Only</b></summary>

<br>

This option uses `matugen` to generate color schemes from your wallpaper without `illogical impulse`. You'll manually manage theme settings.

#### 4. Copy Integration Files

```bash
mkdir -p ~/.config/ii-sddm-theme/
cp -r Matugen/* ~/.config/ii-sddm-theme/
chmod +x ~/.config/ii-sddm-theme/sddm-theme-apply.sh
```

#### 5. Install the Theme

```bash
sudo mkdir -p /usr/share/sddm/themes/ii-sddm-theme
sudo cp -rf . /usr/share/sddm/themes/ii-sddm-theme/
```

#### 6. Configure SDDM

Edit `/etc/sddm.conf` with your preferred editor:

```bash
sudo nano /etc/sddm.conf
```

Ensure these options are set:

```ini
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/ii-sddm-theme/Components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=ii-sddm-theme
```

#### 7. Configure Matugen

Add this block to `~/.config/matugen/config.toml`:

```toml
[templates.iisddmtheme]
input_path = '~/.config/ii-sddm-theme/SddmColors.qml'
output_path = '~/.config/ii-sddm-theme/Colors.qml'
post_hook = 'sudo ~/.config/ii-sddm-theme/sddm-theme-apply.sh &'
```

#### 8. Configure Passwordless Sudo

```bash
echo "$USER ALL=(ALL) NOPASSWD: /home/$USER/.config/ii-sddm-theme/sddm-theme-apply.sh" | sudo tee /etc/sudoers.d/sddm-theme-$USER > /dev/null
sudo chmod 0440 /etc/sudoers.d/sddm-theme-$USER
```

#### 9. Apply the Theme

```bash
sudo ~/.config/ii-sddm-theme/sddm-theme-apply.sh
```

#### 10. Test the Theme

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/ii-sddm-theme
```

#### 11. Reboot

Restart your system to see the theme in action.

</details>

<details>
<summary><b>No Matugen Integration</b></summary>

<br>

This option is for users who prefer full manual control over background, colors, and settings without any automation.

#### 4. Copy Integration Files

```bash
mkdir -p ~/.config/ii-sddm-theme/
cp -r noMatugen/* ~/.config/ii-sddm-theme/
chmod +x ~/.config/ii-sddm-theme/sddm-theme-apply.sh
```

#### 5. Install the Theme

```bash
sudo mkdir -p /usr/share/sddm/themes/ii-sddm-theme
sudo cp -rf . /usr/share/sddm/themes/ii-sddm-theme/
```

#### 6. Configure SDDM

Edit `/etc/sddm.conf` with your preferred editor:

```bash
sudo nano /etc/sddm.conf
```

Ensure these options are set:

```ini
[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/ii-sddm-theme/Components/,QT_IM_MODULE=qtvirtualkeyboard

[Theme]
Current=ii-sddm-theme
```

#### 7. Apply the Theme

```bash
sudo ~/.config/ii-sddm-theme/sddm-theme-apply.sh
```

#### 8. Test the Theme

```bash
sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/ii-sddm-theme
```

#### 9. Reboot

Restart your system to see the theme in action.

</details>

</details>

---

## Post-Installation

After installation, check the `GUIDE.txt` file in your `~/.config/ii-sddm-theme/` folder.

## Uninstallation

<details>
<summary><b>Click to expand uninstallation instructions</b></summary>

<br>

To completely remove the theme from your system, follow these steps:

### 1. Remove Theme Files
```bash
sudo rm -rf /usr/share/sddm/themes/ii-sddm-theme
```

### 2. Remove Configuration Files
```bash
rm -rf ~/.config/ii-sddm-theme
```

### 3. Remove Sudo Permissions
```bash
sudo rm -f /etc/sudoers.d/sddm-theme-$USER
```

### 4. Remove Matugen Configuration
If you used Matugen integration, remove the theme configuration from `~/.config/matugen/config.toml`:
```bash
nano ~/.config/matugen/config.toml
```

Remove the `[templates.iisddmtheme]` section.

### 5. Restore Default SDDM Theme
Edit `/etc/sddm.conf`:
```bash
sudo nano /etc/sddm.conf
```

Change or remove these lines:
```ini
[General]
InputMethod=
GreeterEnvironment=

[Theme]
Current=
```

Or set `Current=` to your preferred theme (you can check available themes in `/usr/share/sddm/themes`).

### 6. Optional: Remove Dependencies
If you no longer need the theme-specific fonts and packages (they are used in ii):
```bash
yay -Rns otf-space-grotesk ttf-gabarito-git ttf-material-symbols-variable-git ttf-readex-pro ttf-rubik-vf
```

> **Note:** 
> Only remove `sddm`, `qt6-svg`, `qt6-virtualkeyboard`, and `qt6-multimedia-ffmpeg` if you're certain no other applications depend on them.

### 7. Reboot
Restart your system to apply the changes:
```bash
reboot
```

</details>

## Support

If you encounter any issues or have questions:

- [Open an issue](https://github.com/3d3f/ii-sddm-theme/issues/new/choose) on GitHub
