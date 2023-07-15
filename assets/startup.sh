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
  xrandr --output HDMI-0 --primary --output DVI-D-0 --right-of HDMI-0
fi

# Start JetBrains ToolBox
if [ -x "$(command -v jetbrains-toolbox)" ]; then
  jetbrains-toolbox --minimize &
fi

# Start picom
if [ -x "$(command -v picom)" ]; then
  picom &
fi

