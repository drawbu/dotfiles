<div align="center">

# My dotfiles for macOS and Arch

<div style="width: 200px; display: flex; justify-content: space-between">
    <img alt="macOS Finder logo" src="assets/docs/finder_logo.png" width="48">
    <img alt="Asahi Linux logo" src="assets/docs/asahi_linux.png" width="48">
    <img alt="Arch Linux logo" src="assets/docs/arch.png" width="48">
</div>

<samp>Those dotfiles is the config I use mainly on macOS, but also on Linux (Vanilla Arch & Asahi).</samp>

#

</div>


## Table of content

1. [Screenshots](#art--screenshots-)
    1. [macOS](#samp-macos-samp)
2. [Installation](#wrench--installation-)
    1. [Install Apple's Command Line Tools](#install-apples-command-line-tools-this-are-prerequisites-for-git-and-homebrew)
    2. [Clone the repo](#clone-the-repo)
    3. [Create symlinks](#create-symlinks)
    4. [Homebrew](#homebrew)
    5. [Zsh & Oh My Zsh & Powerlevel10k](#zsh--oh-my-zsh--powerlevel10k)
    6. [iTerm2](#iterm2)


## :art: <samp> SCREENSHOTS </samp>

### <samp> macOS </samp>
![Screenshot 1](assets/docs/screenshots/screenshot-1.png)
![Screenshot 2](assets/docs/screenshots/screenshot-2.png)
![Screenshot 3](assets/docs/screenshots/screenshot-3.png)

The wallpaper is the macOS Catalina official dynamic wallpaper (the light scheme change during the day).


## :wrench: <samp> INSTALLATION </samp>

### Install Apple's Command Line Tools (these are prerequisites for Git and Homebrew)
```bash
xcode-select --install
```

### Clone the repo
```bash
git clone --recursive https://github.com/drawbu/dotfiles $DOTFILE_PATH
```
If the recursive repo cloning failed, run:
```bash
git submodule update --recursive
```
(with `--init` flag if it fails again)

### Create symlinks
_Don't forget to remove the orignal file before setting a symlink at the same 
path!_
```bash
ln -si $DOTFILE_PATH/.zshrc ~/.zshrc
ln -si $DOTFILE_PATH/.config/ ~/.config/
...
```
_Except for Brewfile, see [homebrew step](#homebrew)_

### Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle --file $DOTFILE_PATH/Brewfile
```

### Zsh & Oh My Zsh & Powerlevel10k
```bash
ln -s $DOTFILE_PATH/.ohmyzsh ~/.ohmyzsh
ln -s $DOTFILE_PATH/.p10k.zsh ~/.p10k.zsh
ln -s $DOTFILE_PATH/.zshrc ~/.zshrc
ln -s $DOTFILE_PATH/.profile ~/.profile
```

### iTerm2
Go on the GUI preferences, search from a custom folder or URL, check the box, and select the `~/.config/iterm2` folder.

To open the terminal on top, press `CTRL`+`SPACE`.
