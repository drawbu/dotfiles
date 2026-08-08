{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mod.profiles.gaming.enable {
    home.packages = with pkgs; [
      prismlauncher
      lunar-client
      heroic
      dwarf-fortress
      r2modman
      vulkan-tools
    ];

    programs.mangohud = {
      enable = true;
      settings = {
        fps = true;
        frametime = true;
        frame_timing = true;
        cpu_stats = true;
        cpu_temp = true;
        gpu_stats = true;
        gpu_temp = true;
        vram = true;
        ram = true;
      };
    };
  };
}
