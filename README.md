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

And **tada** the pc is up and running, users are created, everything is
installed, and symlinks are linked!

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
git clone https://github.com/drawbu/dotfiles $DOTFILE_PATH
```

### Create symlinks
> **Info**
> If you are using Nix, you can skip this step as it is handled automatically
```bash
ln -s $DOTFILE_PATH/.config ~/.config
ln -s $DOTFILE_PATH/.gitconfig ~/.gitconfig
ln -s $DOTFILE_PATH/.zshrc ~/.zshrc
ln -s $DOTFILE_PATH/assets ~/assets
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
