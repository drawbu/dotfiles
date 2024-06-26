{
  config,
  pkgs,
  ...
}: let
  run_gnome = pkgs.writeShellScriptBin "run_gnome" ''
    export DISPLAY=:0
    export XDG_SESSION_TYPE=wayland
    ${pkgs.dbus}/bin/dbus-run-session ${pkgs.gnome.gnome-session}/bin/gnome-session
  '';

  choiceSelectorPy =
    pkgs.writers.writePython3Bin "choiceSelector.py" {
      makeWrapperArgs = ["--prefix PATH : ${pkgs.fzf}/bin"];
    } ''
      import subprocess


      DISPLAYS = {
          "Hyprland": "Hyprland",
          "qtile": "startx ${config.home.homeDirectory}/.nix-profile/bin/qtile start",
          "Gnome": "run_gnome",
          "Steam": "steam-gamescope",
      }


      def select_display():
          fzf = subprocess.Popen(
              ["fzf"],
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
in {
  home = {
    packages = [run_gnome];
    file."login.sh" = {
      text = /*bash*/ ''
        #!/bin/sh

        choice=$(${pkgs.lib.getExe choiceSelectorPy})
        exec $choice
      '';
      executable = true;
    };
  };
}
