{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let

  sources = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://soloist-builds.spotifycdn.com/soloist_release_x86_64.tar.gz";
      hash = "sha256-UOeNe8bR1rNeIjEXIMDD2fWAtZE3zR3neq/INFPT/vY=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://soloist-builds.spotifycdn.com/soloist_release_arm64.tar.gz";
      hash = "";
    };
  };
  package = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "soloist";
    version = "1.3.8.43";

    strictDeps = true;
    __structuredAttrs = true;

    src =
      sources.${pkgs.stdenv.hostPlatform.system}
        or (throw "Unsupported system: ${pkgs.stdenv.hostPlatform.system}");

    sourceRoot = ".";

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [ pkgs.stdenv.cc.cc.lib ];

    installPhase = ''
      runHook preInstall

      install -Dm755 soloist $out/bin/soloist
      install -Dm644 THIRD_PARTY_LICENSES.txt $out/share/licenses/soloist/THIRD_PARTY_LICENSES.txt

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/soloist \
        --prefix LD_LIBRARY_PATH : "${
          lib.makeLibraryPath [
            pkgs.pipewire
            pkgs.libpulseaudio
          ]
        }"
    '';

    nativeInstallCheckInputs = [ pkgs.versionCheckHook ];
    doInstallCheck = true;

    meta = {
      description = "Headless Spotify Connect client for Linux";
      homepage = "https://developer.spotify.com/documentation/soloist";
      license = lib.licenses.unfree;
      mainProgram = "soloist";
      maintainers = with lib.maintainers; [ drawbu ];
      platforms = builtins.attrNames sources;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    };
  });
in
{
  programs.onepassword-secrets.secrets.soloistApiKey = {
    path = ".config/soloist/api-key";
    reference = "op://nixos/Soloist/token";
  };

  home.packages = [ package ];

  systemd.user.services.soloist = {
    Unit = {
      Description = "Spotify Soloist";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = pkgs.writeShellScript "soloist" ''
        exec ${lib.getExe package} \
          --device-name ${lib.escapeShellArg osConfig.networking.hostName} \
          --api-key "$(<${config.programs.onepassword-secrets.secretPaths.soloistApiKey})"
      '';
      Restart = "always";
      RestartSec = 5;
    };
  };
}
