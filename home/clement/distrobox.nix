{pkgs, ...}: {
  home.packages = [pkgs.distrobox];

  xdg.configFile = {
    "distrobox/distrobox.conf".text = ''
      container_always_pull="1"
      container_generate_entry=1
      container_manager="podman"
    '';

    "distrobox/distrobox.ini" = {
      text = pkgs.lib.generators.toINI {} {
        arch = {
          image = "archlinux:latest";
          pull = true;
          root = false;
          replace = false;
        };

        fedora = {
          image = "fedora:latest";
          pull = true;
          root = false;
          replace = false;
        };
      };
      onChange = ''
        distrobox assemble create --file $out
      '';
    };
  };
}
