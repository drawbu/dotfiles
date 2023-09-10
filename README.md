<div align="center">

# My dotfiles for macOS and Arch

<div style="width: 200px; display: flex; justify-content: space-between">
    <img alt="macOS Finder logo" src="assets/docs/finder_logo.png" width="48">
    <img alt="Asahi Linux logo" src="assets/docs/asahi_linux.png" width="48">
    <img alt="Arch Linux logo" src="assets/docs/arch.png" width="48">
    <img alt="Nix snowflake" src="assets/docs/nix-snowflake.svg" width="48">
</div>

<samp>
   Those dotfiles is the config I use mainly on macOS, but also on Linux 
   (Vanilla Arch & Asahi).
</samp>

</div>

#

## :building_construction: <samp> TABLE OF CONTENT </samp>

1. [Screenshots](#art--screenshots-)
    1.  [Arch](#-arch-)
    2.  [macOS](#-macos-)
2. [OS]
    1.  [NixOS]
    2.  [Linux]
2. [Installation](#wrench--installation-)
    1.  [Nix](#snowflake-nix)
    2.  [Nix Home Manager](#nix-home-manager)
    3.  [Install Apple's Command Line Tools](#apples-command-line-tools)
    4.  [Clone the repo](#clone-the-repo)
    5.  [Create symlinks](#create-symlinks)
    6.  [Homebrew](#beer-homebrew)
    7.  [Zsh & Oh My Zsh & Powerlevel10k](#zsh--oh-my-zsh--powerlevel10k)
    8.  [iTerm2](#iterm2)
    9.  [Qtile](#qtile)
    10. [Picom](#picom)
    11. [Tmux](#tmux)


## :art: <samp> SCREENSHOTS </samp>

### <samp> ARCH </samp>
<div style="display: flex">
    <img alt="Asahi Linux logo" src="assets/docs/asahi_linux.png" width="16"> 
    <img alt="Arch Linux logo" src="assets/docs/arch.png" width="16">
    <img alt="Nix snowflake" src="assets/docs/nix-snowflake.svg" width="16">
</div>

Simple and clean, with [qtile](#qtile) and [picom](#picom).
![Screenshot 1](assets/docs/screenshots/screenshot-arch-01.png)
![Screenshot 2](assets/docs/screenshots/screenshot-arch-02.png)

## OS
Depending on your OS, you way need different steps

### :snowflake: NixOS
```sh
cd /etc/nixos
git clone https://github.com/drawbu/nix-config config
sudo nixos-rebuild switch /etc/nixos/config#the-machine
```
Replace `the-machine` with one of the following:
 - `pain-de-mie`: For my PC
 - `pancake`: For my laptop
 - `croissant`: For my Contabo VPS (setup [here](https://github.com/drawbu/Notes/blob/main/Server%20administration/Install%20NixOS%20on%20Contabo%20server.md)
 - `linux`: for non-NixOS Linux

And **tada** the pc is up and running, users are created, and everything is
installed.

### Average Linux
Setup home manager for Linux Non-NixOS
```sh
git clone https://github.com/drawbu/nix-config
cd nix-config
home-manager switch --flake .#linux
```

## :wrench: <samp> INSTALLATION </samp>
> **Note**
> For the next steps, im going to refer as the folder you want to put the 
> dotfiles in as `$DOTFILES_PATH`

### Clone the repo
```bash
git clone --recursive https://github.com/drawbu/dotfiles $DOTFILE_PATH
```
If the recursive repo cloning failed, run:
```bash
git submodule update --recursive
```
(with `--init` flag if it fails again)

> **Note**
> Be careful when cloning the submodules, the repo where the wallpapers are 
> ([here](https://github.com/DenverCoder1/minimalistic-wallpaper-collection))
> is over 800 Mo

### Create symlinks
> **Warning**
> Don't forget to remove the orignal file before setting a symlink at the same 
> path!_

You don't have to create symlinks for every file, only the ones you need. The 
`.config` folder is for me a go-to folder for all the config files I need to
symlink.

Exemple:
```bash
ln -si $DOTFILE_PATH/.config ~/.config
```

### :beer: Homebrew
Don't symlink the `Brewfile` file, it's only used for the installation of
the packages.

These commands will install Homebrew and all the packages listed in the
`Brewfile` file.
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file $DOTFILE_PATH/Brewfile
```

### Zsh & Oh My Zsh & Powerlevel10k
```bash
ln -s $DOTFILE_PATH/.ohmyzsh ~/.ohmyzsh
ln -s $DOTFILE_PATH/.zshrc ~/.zshrc
ln -s $DOTFILE_PATH/assets ~/assets
```

### iTerm2
Go on the GUI preferences, search from a custom folder or URL, check the box, 
and select the `~/.config/iterm2` folder.

To open the terminal on top, press `CTRL`+`SPACE`.

### Qtile
(Already installed by default on my Nix HM config)

The Window Manager I use on Linux. It's a tiling window manager written and 
configured in Python. All the config files are in the `.config/qtile` folder.
```bash
pacman -S qtile
```

### Picom
(Already installed by default on my Nix HM config)

The compositor I use on Linux. It's a lightweight compositor for X11. 
Qtile works fine without it, but it's better with it, as it adds little 
animations and the possibility to play with window opacity.
```bash
pacman -S picom
```

### Tmux
Tmux comes preinstalled with the nix Home-Manager and NixOS conf. You can also
install it manually.
You'll need to install [TMP](https://github.com/tmux-plugins/tpm).
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
Then, open a tmux session and press <kbd>CTRL</kbd> + <kbd>b</kbd>, then 
<kbd>I</kbd> to install the plugins and reload the config.

### Rofi
Rofi comes preinstalled with the nix Home-Manager and NixOS conf. You can also
install it manually.

You'll need to install [adi1090x/rofi](https://github.com/adi1090x/rofi).
Then, install it following the README.
