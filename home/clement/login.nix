{
  pkgs,
  lib,
  ...
}:
let
  choiceSelectorPy =
    pkgs.writers.writePython3Bin "choiceSelector.py"
      {
        makeWrapperArgs = [ "--prefix PATH : ${pkgs.fzf}/bin" ];
      }
      ''
        import subprocess


        DISPLAYS = {
            "Hyprland": "Hyprland",
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
  loginScript = pkgs.writeShellApplication {
    name = "login.sh";
    text = # bash
      ''
        choice=$(${lib.getExe choiceSelectorPy})
        exec $choice
      '';
  };
in
{
  home.packages = [ loginScript ];
}
