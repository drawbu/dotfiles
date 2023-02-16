ZSH_THEME_GIT_PROMPT_PREFIX=" - %F{blue}[%F{red}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%F{reset} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{green}+%F{blue}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{blue}]"

local pwd="%F{blue}[%F{reset}%~%F{blue}]%F{reset}"
local user="%F{blue}[%F{cyan}%n%F{reset}@%F{yellow}%m%F{blue}]%F{reset}"

# %{\e[0;34m%}%B└─%B[%{\e[1;35m%}$%{\e[0;34m%}%B]%{\e[0m%}%b 
PROMPT=$'%F{blue}┌─%F{reset}$user - $pwd$(git_prompt_info)
%F{blue}└─[%F{magenta}$%F{blue}]%F{reset} '
RPROMPT="[%*]"
PS2="%F{magenta}>%F{reset} "
PS3="%F{magenta}>%F{reset} "
