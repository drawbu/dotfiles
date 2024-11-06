<div align="center">

# My dotfiles for NixOS

<div style="width: 200px; display: flex; justify-content: space-between">
    <img alt="Nix snowflake" src="https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/logo/nix-snowflake-colours.svg" width="48">
</div>

</div>


## :art: <samp> SCREENSHOTS </samp>


![image](https://github.com/user-attachments/assets/61fc6544-057e-407a-b114-263d37015e6a)
![image](https://github.com/user-attachments/assets/caf26026-c74a-465d-bdcb-7d0f4c85611f)

Simple and clean, using Hyprland. Previously qtile.


## :snowflake: Installation
```
sudo nixos-rebuild switch --flake github:drawbu/dotfiles#the-machine
```
Replace `the-machine` with one of the following:
 - `pain-de-mie`: For my PC
 - `pancake`: For my laptop

And **tada** the pc is up and running, users are created, everything is
installed, and symlinks are linked!


## Config

If you are there to copy my config but are not familiar with Nix, you can check
out the folder [home/clement](./home/clement) where all my user config is.
