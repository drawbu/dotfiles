ZSH_THEME_GIT_PROMPT_PREFIX=" - $fg_bold[blue][$fg[red]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color "
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[green]+$fg[blue]]"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[blue]]"

local pwd="$fg[blue][$reset_color%~$fg[blue]]$reset_color"
local user="$fg[blue][$fg[cyan]%n$reset_color@$fg[yellow]%m$fg[blue]]$reset_color"

PROMPT='$fg[blue]┌─$reset_color$user - $pwd$(git_prompt_info)
$fg[blue]└─[$fg[magenta]\$$fg[blue]]$reset_color '
RPROMPT="[%*] "
PS2="$fg[magenta]>$reset_color "
PS3="$fg[magenta]>$reset_color "
