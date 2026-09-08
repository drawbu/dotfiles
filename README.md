<div align="center">

# My dotfiles for NixOS

</div>


![image](https://github.com/user-attachments/assets/f74f1017-7d8f-447d-89e7-c69e0aac659f)

Simple and clean, using Niri. prev. Hyprland, prev. qtile.


## Installation
```
sudo nixos-rebuild switch --flake github:drawbu/dotfiles#the-machine
```
Replace `the-machine` with one of the following:
 - `lucy`: work/school laptop
 - `kiwi`: previously used macOS config
 - `maine`: home PC
 - `rebecca`: home server running on mini pc

And **tada** the pc is up and running, users are created, everything is
installed, and symlinks are linked!


## Config

If you are there to copy my config but are not familiar with Nix, you can check
out the folder [home/clement](./home/clement) where all my user config is.
