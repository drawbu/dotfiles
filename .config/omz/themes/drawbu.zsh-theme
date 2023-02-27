ZSH_THEME_GIT_PROMPT_PREFIX=" - %F{blue}[%F{red}" 
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{blue}]%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{green}+"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local pwd="%F{blue}[%f%~%F{blue}]%f"
local user="%F{blue}[%F{cyan}%n%f@%F{yellow}%m%F{blue}]%f"

PROMPT=$'%F{blue}┌─$user - $pwd$(git_prompt_info)
%F{blue}└─[%F{magenta}$%F{blue}]%f '
RPROMPT="[%*]"
PS2="%F{magenta}>%f "
PS3="%F{magenta}>%f "
