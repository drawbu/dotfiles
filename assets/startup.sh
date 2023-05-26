# Set notifcations
if [ -x "$(command -v wired)" ]; then
  wired &
fi

# Set keyboard layout
if [ grep -q Asahi /etc/hostname]; then
  setxkbmap fr -variant mac
else
  setxkbmap fr
fi

# Start JetBrains ToolBox
if [ -x "$(command -v jetbrains-toolbox)" ]; then
  jetbrains-toolbox --minimize &
fi

# Start JetBrains ToolBox
if [ -x "$(command -v picom)" ]; then
  picom &
fi
