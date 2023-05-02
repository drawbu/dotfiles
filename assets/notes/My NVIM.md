I installed a blank NVIM and used [NVChad](https://nvchad.com/) to setup the plugins

## Theming

Plenty of color shcemes are installed by default. Just use `SPACE + t + h` and navigate using the `CTRL + n` and `CTRL + p` commands. You can also search a theme with his name.


## Syntax hightlighling with [Tree-Sitter](https://tree-sitter.github.io/tree-sitter/)

Install a new color scheme (ex: python)
```sh
:TSInstall python
```

List all the color schemes (installed or not)
```sh
:TSInstallInfo
```


## File Tree

- `CTRL + n` -> to show (and focus), or to hide the file tree
- `m` -> to mark a file
- `a` -> to add a file
- `r` -> rename a file
- `c` -> copy a file
- `p` -> paste a file


## File navigation

- `SPACE + f + f` -> search a file on the entire project
- `SPACE + f + b` -> search a file on the opened buffers
- `TAB` -> switch buffer
- `SPACE + x` to close buffer


## Cheat sheet

Open with `SPACE + c + h` 


## Split screen

- `vsp` -> split horizontaly
- `vsp` -> split verticaly
- `CTRL + w` , then press the navigation keys (`hjkl`) to switch between splits 


## Terminal

- `SPACE + h` -> horizontal terminal
- `SPACE + v` -> vertical terminal