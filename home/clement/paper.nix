{ config, lib, pkgs, ... }:
let
  package = pkgs.appimageTools.wrapType2 rec {
    pname = "paper-desktop";
    version = "0.5.19";

    # the URL always serves the latest build: bump both on hash mismatch
    src = pkgs.fetchurl {
      url = "https://download.paper.design/linux/appImage/x64";
      name = "${pname}-${version}.AppImage";
      hash = "sha256-YKZUYnYHCJ8ARLLPjEY20bAZ2Qdx0PrsrteDdLJa4Es=";
    };

    extraInstallCommands =
      let
        contents = pkgs.appimageTools.extract { inherit pname version src; };
      in
      ''
        install -Dm755 ${contents}/resources/app.asar.unpacked/dist/cli-bin/linux-x64/paper $out/bin/paper
        mkdir -p $out/share
        cp -r ${contents}/usr/share/icons $out/share/icons
        install -Dm644 ${contents}/paper-desktop.desktop $out/share/applications/paper-desktop.desktop
        substituteInPlace $out/share/applications/paper-desktop.desktop \
          --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=paper-desktop'
      '';

    meta = {
      description = "Design tool with an MCP server for agents";
      homepage = "https://paper.design";
      license = lib.licenses.unfree;
      mainProgram = "paper-desktop";
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  };
in
{
  home.packages = lib.optionals config.mod.profiles.desktop.enable [ package ];

  programs.mcp.servers.paper.url = "https://mcp.paper.design";
}
