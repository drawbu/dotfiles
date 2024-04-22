{pkgs, hyprland, ...}:
let
  run_gnome = pkgs.writeShellScriptBin "run_gnome" ''
    export DISPLAY=:0
    export XDG_SESSION_TYPE=wayland
    ${pkgs.dbus}/bin/dbus-run-session ${pkgs.gnome.gnome-session}/bin/gnome-session
  '';

  choiceSelectorPy = pkgs.writeText "choiceSelector.py" ''
    import subprocess
    import os
    import shutil


    DISPLAYS = {
        "Hyprland": "${hyprland.hyprland}/bin/Hyprland",
        "qtile": f"startx ${pkgs.qtile-unwrapped}/bin/qtile start",
        "Gnome": "${run_gnome}/bin/run_gnome",
    }


    def select_display():
        fzf = subprocess.Popen(
            ["${pkgs.fzf}/bin/fzf"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            text=True
        )
        display, _ = fzf.communicate(input="\n".join(DISPLAYS.keys()))

        return DISPLAYS.get(display.strip())


    def main():
        command = select_display()
        if command is None:
            print("Invalid display selected.")
            exit(1)
        print(command)


    if __name__ == "__main__":
        main()
  '';
in
{
  home.file."login.sh" = {
    text = ''
      #!/bin/sh

      choice=$(${pkgs.python312}/bin/python3 ${choiceSelectorPy})
      exec $choice
    '';
    executable = true;
  };
}
