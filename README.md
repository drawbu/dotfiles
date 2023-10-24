<div align="center">

# My dotfiles for NixOS

<div style="width: 200px; display: flex; justify-content: space-between">
    <img alt="Nix snowflake" src="docs/nix-snowflake.svg" width="48">
</div>

</div>

#

## :art: <samp> SCREENSHOTS </samp>

<div style="display: flex">
    <img alt="Nix snowflake" src="docs/nix-snowflake.svg" width="16">
</div>

![Screenshot 1](docs/screenshots/screenshot-01.png)
![Screenshot 2](docs/screenshots/screenshot-02.png)
Simple and clean, using [qtile](https://github.com/qtile/qtile).

## :snowflake: Installation
```
sudo nixos-rebuild switch --flake github:drawbu/dotfiles#the-machine
```
Replace `the-machine` with one of the following:
 - `pain-de-mie`: For my PC
 - `pancake`: For my laptop
 - `croissant`: For my Contabo VPS (setup [here](https://github.com/drawbu/Notes/blob/main/Server%20administration/Install%20NixOS%20on%20Contabo%20server.md))

And **tada** the pc is up and running, users are created, everything is
installed, and symlinks are linked!
