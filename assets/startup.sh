# Set notifcations
if [ -x "$(command -v wired)" ]; then
  wired &
elif [ -x "$(command -v dunst)" ]; then
  dunst &
fi

setxkbmap fr

# Start JetBrains ToolBox
if [ -x "$(command -v jetbrains-toolbox)" ]; then
  jetbrains-toolbox --minimize &
fi

# Start picom
if [ -x "$(command -v picom)" ]; then
  picom &
fi

if [ -x "$(command -v bluetoothctl)" ]; then
  bluetoothctl power on &
fi

if [ -x "$(command -v flameshot)" ]; then
  flameshot &
fi
