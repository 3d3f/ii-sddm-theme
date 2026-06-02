# ii-sddm-theme

https://github.com/user-attachments/assets/a03e1628-3438-4390-bb62-96e18308a8e0

## Overview

[ii-sddm-theme](https://github.com/3d3f/ii-sddm-theme) is a custom theme for the [SDDM](https://github.com/sddm/sddm/) display manager that tries to replicate the lockscreen aesthetic and settings of [illogical impulse](https://github.com/end-4/dots-hyprland). It can be used with ii dotfiles, with [Matugen](https://github.com/InioX/matugen) only, or as a standalone theme.

I only have a basic understanding of Qt QML, so this project is a learning experience and mostly about piecing together code from various sources while figuring things out along the way. I also get a ton of help from ai models.

**Currently supports:** Arch Linux + Hyprland, to be extended

---

## Acknowledgements

This theme wouldn't exist without these projects:

- **[illogical impulse](https://github.com/end-4/dots-hyprland)** – All the widgets code, the design and the creativeness comes from [end-4](https://github.com/end-4) repo
- **[win11-sddm-theme](https://github.com/syrupderg/win11-sddm-theme)** – An amazing win 11 sddm theme, which i used for the waffle implementation
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

It can also be used to update the theme.

> **Note:** Only Arch Linux + Hyprland is supported. Non-standard folder structures will require manual installation. 

---

## Post-Installation

After installation, check the `GUIDE.txt` file in your `~/.config/ii-sddm-theme/` folder.

## Uninstallation

Run the uninstall script:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/3d3f/ii-sddm-theme/main/uninstall.sh)"
```

This will remove the SDDM theme, configuration, scripts, fonts, Matugen block, and sudoers rule. A reboot is required to fully apply the changes.

## Cursor theme
This example is made with [Bibata Modern Classic](https://github.com/ful1e5/Bibata_Cursor), but you can use any cursor theme.
This workaround worked for me but may not work for everybody.

### Install the cursor theme package (if you use ii you have it already)
```bash
yay -S bibata-cursor-theme-bin
```

### Workaround 
Backup and then edit `/usr/share/icons/default/index.theme`:
```bash
sudo nano /usr/share/icons/default/index.theme
```
Change or add these lines:
```ini
[Icon Theme]
Inherits=Bibata-Modern-Classic
```

---

## Issues & Questions

For bug reports, questions, or feature requests, please [open an issue](https://github.com/3d3f/ii-sddm-theme/issues/new/choose).