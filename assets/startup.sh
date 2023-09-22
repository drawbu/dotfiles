# Set notifcations
if [ -x "$(command -v wired)" ]; then
  wired &
elif [ -x "$(command -v dunst)" ]; then
  dunst &
fi

if [ grep -q Asahi /etc/hostname]; then
  setxkbmap fr -variant mac
else
  setxkbmap fr
fi

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
