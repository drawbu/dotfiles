# Set notifcations
if [ -x "$(command -v wired)" ]; then
  wired &
fi

setxkbmap fr

# Start JetBrains ToolBox
if [ -x "$(command -v jetbrains-toolbox)" ]; then
  jetbrains-toolbox --minimize &
fi

# Start JetBrains ToolBox
if [ -x "$(command -v picom)" ]; then
  picom &
fi
