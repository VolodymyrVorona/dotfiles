# My Niri + Arch Linux Setup Guide

Setup guide for a keyboard-focused Arch Linux desktop with Niri, Btrfs snapshots, and GNU Stow dotfiles management.

## My Hardware

| Component | Details |
|-----------|---------|
| System | ASUS Desktop |
| CPU | AMD Ryzen 5 5600G (integrated Radeon Vega) |
| GPU | AMD Radeon Vega (integrated) |
| Storage | Samsung 980 PRO 500GB NVMe (main) |
| | Samsung 860 EVO 500GB SATA (secondary) |
| Locale | en_US.UTF-8 |
| Keyboard | US |
| Timezone | Europe/Kyiv |

## Stack Overview

| Component | Choice |
|-----------|--------|
| Distro | Arch Linux (via archinstall) |
| Filesystem | Btrfs with subvolumes |
| Snapshots | Snapper |
| Compositor | Niri |
| Status bar | Waybar |
| Terminal | Alacritty |
| Shell | Fish |
| Launcher | Fuzzel |
| Dotfiles | GNU Stow |

---

## BEFORE REINSTALL: Backup Current System

### 1. Backup Important Configs

```bash
# Create backup directory
mkdir -p ~/backup-configs

# Fish config
cp -r ~/.config/fish ~/backup-configs/

# Git config
cp ~/.gitconfig ~/backup-configs/
cp -r ~/.config/git ~/backup-configs/git-config 2>/dev/null

# SSH keys (IMPORTANT!)
cp -r ~/.ssh ~/backup-configs/

# GPG keys
gpg --export-secret-keys > ~/backup-configs/gpg-private-keys.asc
gpg --export > ~/backup-configs/gpg-public-keys.asc

# Any app configs you want to keep
cp -r ~/.config/lazygit ~/backup-configs/ 2>/dev/null
cp -r ~/.config/yazi ~/backup-configs/ 2>/dev/null
cp -r ~/.config/bat ~/backup-configs/ 2>/dev/null
cp -r ~/.config/kitty ~/backup-configs/ 2>/dev/null
cp -r ~/.config/nvim ~/backup-configs/ 2>/dev/null
```

### 2. Save Package List

```bash
# Explicitly installed packages (for reference)
pacman -Qe > ~/backup-configs/packages-explicit.txt

# AUR packages
pacman -Qm > ~/backup-configs/packages-aur.txt
```

### 3. Copy Backup to External Drive or Cloud

```bash
# To USB drive
cp -r ~/backup-configs /run/media/voron/<USB_DRIVE>/

# Or tar it up for cloud upload
tar -czvf backup-configs.tar.gz ~/backup-configs
```

---

## Phase 1: Install Arch Linux with archinstall

### 1. Boot from Arch ISO

Download from https://archlinux.org/download/ and create bootable USB.

### 2. Connect to Internet

```bash
# Ethernet: auto-connects

# WiFi:
iwctl
> station wlan0 scan
> station wlan0 get-networks
> station wlan0 connect "YourNetworkName"
> exit

# Verify connection
ping -c 3 archlinux.org
```

### 3. Run archinstall

```bash
archinstall
```

### 4. archinstall Settings

| Setting | Value |
|---------|-------|
| **Language** | English |
| **Keyboard layout** | us |
| **Mirror region** | (your country) |
| **Locales** | en_US.UTF-8 |
| **Disk configuration** | Use best-effort partitioning |
| **Disk** | nvme0n1 (Samsung 980 PRO) |
| **Filesystem** | btrfs |
| **Btrfs options** | See below |
| **Disk encryption** | Skip (or set if you want) |
| **Bootloader** | systemd-boot |
| **Swap** | Yes (or zram) |
| **Hostname** | arch (or your choice) |
| **Root password** | Set one |
| **User account** | voron (add to wheel, sudo) |
| **Profile** | Desktop → **Niri** |
| **Seat access** | polkit |
| **Audio** | pipewire |
| **Kernel** | linux |
| **Network** | NetworkManager |
| **Timezone** | Europe/Kyiv |
| **NTP** | Yes |

### 5. Btrfs Subvolume Options

When prompted for Btrfs options:

| Option | Select |
|--------|--------|
| Use default subvolume structure? | **Yes** |
| Compression? | **Yes (zstd)** |
| Disable copy-on-write? | **No** |

This creates:
```
@           → /                        (root, snapshotted)
@home       → /home                    (separate from root snapshots)
@.snapshots → /.snapshots              (snapshot storage)
@log        → /var/log                 (excluded from snapshots)
@pkg        → /var/cache/pacman/pkg    (excluded from snapshots)
```

### 6. Install

Select "Install" and wait for completion. Reboot when done.

---

## Phase 2: First Boot Setup

You should boot directly into a TTY or Niri session.

### Test Niri

```bash
# If at TTY, start Niri
niri-session
```

If Niri starts, you have a working base. Press `Mod+Shift+E` to exit back to TTY.

### Install Additional Packages

```bash
# Update system first
sudo pacman -Syu

# Status bar and launcher
sudo pacman -S waybar fuzzel

# Terminal and shell
sudo pacman -S alacritty fish

# Essentials
sudo pacman -S polkit-gnome brightnessctl playerctl

# AMD GPU (you have integrated Vega)
sudo pacman -S mesa vulkan-radeon libva-mesa-driver

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-fira-code noto-fonts noto-fonts-emoji

# File manager & basics
sudo pacman -S nautilus xdg-user-dirs stow git

# Screenshots
sudo pacman -S grim slurp wl-clipboard

# Snapper for Btrfs snapshots
sudo pacman -S snapper snap-pac

# CLI tools you had
sudo pacman -S bat eza zoxide yazi lazygit git-delta htop tmux neovim

# Other essentials
sudo pacman -S unzip wget rsync openssh base-devel
```

### Install yay (AUR helper)

```bash
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
cd ~
```

### Install AUR packages

```bash
yay -S brave-bin slack-desktop
```

---

## Phase 3: Create Dotfiles Structure

```bash
mkdir -p ~/dotfiles/{niri/.config/niri,waybar/.config/waybar,alacritty/.config/alacritty,fish/.config/fish,scripts/.local/bin}
cd ~/dotfiles
git init
```

---

## Phase 4: Configuration Files

### Niri Config

Create `~/dotfiles/niri/.config/niri/config.kdl`:

```kdl
// Niri config for ASUS Desktop with AMD Ryzen 5 5600G

input {
    keyboard {
        xkb {
            layout "us"
        }
    }

    mouse {
        accel-speed 0.0
    }
}

// Adjust output name - run `niri msg outputs` to find yours
// output "DP-1" {
//     mode "1920x1080@144.0"
//     scale 1.0
// }

layout {
    gaps 8

    focus-ring {
        width 2
        active-color "#88c0d0"
        inactive-color "#4c566a"
    }

    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
    }

    default-column-width { proportion 0.5; }
}

// Autostart
spawn-at-startup "waybar"
spawn-at-startup "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"

binds {
    // Terminal
    Mod+Return { spawn "alacritty"; }

    // App launcher
    Mod+Space { spawn "fuzzel"; }

    // Close window
    Mod+W { close-window; }

    // Exit niri
    Mod+Shift+E { quit; }

    // Navigation
    Mod+Left { focus-column-left; }
    Mod+Right { focus-column-right; }
    Mod+Up { focus-window-up; }
    Mod+Down { focus-window-down; }

    // Move windows
    Mod+Shift+Left { move-column-left; }
    Mod+Shift+Right { move-column-right; }
    Mod+Shift+Up { move-window-up; }
    Mod+Shift+Down { move-window-down; }

    // Workspaces
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }

    Mod+Shift+1 { move-column-to-workspace 1; }
    Mod+Shift+2 { move-column-to-workspace 2; }
    Mod+Shift+3 { move-column-to-workspace 3; }
    Mod+Shift+4 { move-column-to-workspace 4; }
    Mod+Shift+5 { move-column-to-workspace 5; }

    // Window sizing
    Mod+R { switch-preset-column-width; }
    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }

    // Consume/expel windows in column
    Mod+BracketLeft { consume-window-into-column; }
    Mod+BracketRight { expel-window-from-column; }

    // Scrolling
    Mod+Tab { focus-column-right; }
    Mod+Shift+Tab { focus-column-left; }

    // Audio
    XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
    XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
    XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }

    // Screenshot
    Print { spawn "sh" "-c" "grim - | wl-copy"; }
    Mod+Print { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
    Mod+Shift+S { spawn "sh" "-c" "grim -g \"$(slurp)\" - | wl-copy"; }
}
```

### Waybar Config

Create `~/dotfiles/waybar/.config/waybar/config`:

```json
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["niri/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["cpu", "memory", "pulseaudio", "tray"],

    "niri/workspaces": {
        "format": "{index}"
    },

    "clock": {
        "format": "{:%a %b %d  %H:%M}",
        "timezone": "Europe/Kyiv"
    },

    "cpu": {
        "format": " {usage}%",
        "interval": 2
    },

    "memory": {
        "format": " {percentage}%",
        "interval": 2
    },

    "pulseaudio": {
        "format": "󰕾 {volume}%",
        "format-muted": "󰖁",
        "on-click": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    },

    "tray": {
        "spacing": 10
    }
}
```

Create `~/dotfiles/waybar/.config/waybar/style.css`:

```css
* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 14px;
}

window#waybar {
    background: #2e3440;
    color: #eceff4;
}

#workspaces button {
    padding: 0 8px;
    color: #4c566a;
}

#workspaces button.active {
    color: #88c0d0;
}

#clock, #cpu, #memory, #pulseaudio {
    padding: 0 10px;
}

#cpu {
    color: #a3be8c;
}

#memory {
    color: #ebcb8b;
}
```

### Alacritty Config

Create `~/dotfiles/alacritty/.config/alacritty/alacritty.toml`:

```toml
[shell]
program = "/usr/bin/fish"

[font]
size = 12.0

[font.normal]
family = "JetBrainsMono Nerd Font"

[colors.primary]
background = "#2e3440"
foreground = "#eceff4"

[colors.normal]
black = "#3b4252"
red = "#bf616a"
green = "#a3be8c"
yellow = "#ebcb8b"
blue = "#81a1c1"
magenta = "#b48ead"
cyan = "#88c0d0"
white = "#e5e9f0"
```

### Fish Config

Create `~/dotfiles/fish/.config/fish/config.fish`:

```fish
if not status is-interactive
    return
end

# Initialize zoxide
zoxide init fish | source

# Abbreviations
abbr -a g git
abbr -a gc "git commit"
abbr -a gp "git push"
abbr -a gs "git status"
abbr -a gd "git diff"
abbr -a gl "git log --oneline"

abbr -a l "eza -la"
abbr -a ll "eza -l"
abbr -a lt "eza -la --tree --level=2"

abbr -a pac "sudo pacman -S"
abbr -a pacs "pacman -Ss"
abbr -a pacu "sudo pacman -Syu"

abbr -a lg lazygit
abbr -a ld lazydocker

abbr -a dc docker compose
abbr -a dcu "docker compose up -d"
abbr -a dcd "docker compose down"
abbr -a dcl "docker compose logs -f"

# Use bat for cat
abbr -a cat bat
```

---

## Phase 5: Activate Dotfiles

```bash
cd ~/dotfiles
stow niri waybar alacritty fish

# Validate niri config
niri validate

# Create user directories
xdg-user-dirs-update
```

---

## Phase 6: Set Up Snapper

```bash
# Create snapper config for root
sudo snapper -c root create-config /

# Enable automatic snapshots
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer

# Create first manual snapshot
sudo snapper create -d "fresh install with dotfiles"
```

---

## Phase 7: Start Niri with Your Config

```bash
# Start niri session
niri-session
```

After boot, find your monitor name:

```bash
niri msg outputs
```

Then update your `config.kdl` with the correct output name and resolution.

---

## Phase 8: Restore Backups

```bash
# Restore SSH keys
cp -r /path/to/backup/backup-configs/.ssh ~/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

# Restore GPG keys
gpg --import /path/to/backup/backup-configs/gpg-public-keys.asc
gpg --import /path/to/backup/backup-configs/gpg-private-keys.asc

# Restore git config
cp /path/to/backup/backup-configs/.gitconfig ~/
```

---

## Packages to Reinstall (Your Previous Setup)

### From Official Repos

```bash
sudo pacman -S \
  bitwarden docker docker-compose docker-buildx \
  firefox telegram-desktop \
  dbeaver neovim kitty \
  lazydocker go php-legacy \
  meld glances fastfetch inxi \
  trash-cli tldr jq yazi \
  tokei tree-sitter-cli hurl
```

### From AUR

```bash
yay -S brave-bin google-chrome slack-desktop lazysql-bin
```

---

## Keybindings Cheat Sheet

| Keys | Action |
|------|--------|
| `Mod+Return` | Terminal |
| `Mod+Space` | App launcher |
| `Mod+W` | Close window |
| `Mod+Left/Right` | Focus column |
| `Mod+Up/Down` | Focus window in column |
| `Mod+Shift+Left/Right` | Move window |
| `Mod+1-5` | Switch workspace |
| `Mod+Shift+1-5` | Move to workspace |
| `Mod+R` | Cycle window width |
| `Mod+F` | Maximize column |
| `Mod+Shift+F` | Fullscreen |
| `Mod+[` | Consume window into column |
| `Mod+]` | Expel window from column |
| `Mod+Shift+S` | Screenshot selection |
| `Mod+Shift+E` | Exit Niri |

---

## Useful Commands

```bash
# Niri
niri validate              # Check config
niri msg outputs           # List monitors
niri msg workspaces        # List workspaces

# Snapper
sudo snapper list          # List snapshots
sudo snapper create -d "description"  # Manual snapshot
sudo snapper rollback N    # Rollback to snapshot N

# Package management
pacman -Ss <query>         # Search packages
pacman -Qi <package>       # Package info
pacman -Ql <package>       # List package files
yay -Ss <query>            # Search AUR
```

---

## Post-Install Todos

- [ ] Configure monitors with `niri msg outputs`
- [ ] Set up Docker: `sudo usermod -aG docker voron && newgrp docker`
- [ ] Restore browser profiles/bookmarks
- [ ] Set up lock screen (swaylock)
- [ ] Configure idle behavior (swayidle)
- [ ] Add more keybindings as needed
- [ ] Push dotfiles to GitHub: `gh repo create dotfiles --private --source=. --push`

---

## Troubleshooting

### Niri won't start
```bash
# Check for config errors
niri validate

# Check logs
journalctl -b -t niri
```

### No audio
```bash
# Ensure pipewire is running
systemctl --user status pipewire pipewire-pulse wireplumber

# Restart if needed
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Fuzzel not showing apps
```bash
# Regenerate desktop database
update-desktop-database ~/.local/share/applications
```

---

## Resources

- [Niri GitHub](https://github.com/YaLTeR/niri)
- [Niri Wiki](https://github.com/YaLTeR/niri/wiki)
- [Waybar Wiki](https://github.com/Alexays/Waybar/wiki)
- [Arch Wiki](https://wiki.archlinux.org)
- [Btrfs Wiki](https://wiki.archlinux.org/title/Btrfs)
- [Snapper Wiki](https://wiki.archlinux.org/title/Snapper)
- [Fish Shell Docs](https://fishshell.com/docs/current/)
