{
  # source,
  stdenv,
  lib,
  writeShellScript,
  addDriverRunpath,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  cups,
  dbus,
  desktop-file-utils,
  fetchurl,
  gtk3,
  hicolor-icon-theme,
  libffi,
  libglvnd,
  libgcrypt,
  libpulseaudio,
  libva,
  libxkbcommon,
  mesa,
  nss,
  pciutils,
  qt6,
  systemd,
  vulkan-loader,
  xdg-utils,
  libxscrnsaver,
  commandLineArgs ? [ ],
  liberation_ttf,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "helium-browser-bin";
  version = "0.10.5.1";

  src = fetchTarball {
    url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-x86_64_linux.tar.xz";
    sha256 = "sha256-IDnhpxnP1xKcPE/P01Lq67/4pWHvW7Io/AuPa6zJk4E=";
  };

  inherit commandLineArgs;

  heliumRoot = "$out/libexec/${finalAttrs.pname}";

  heliumWrapper = writeShellScript "helium-flags-wrapper" ''
    HERE="''${HELIUM_HOME:?HELIUM_HOME is not set}"

    #XDG_CONFIG_HOME="''${XDG_CONFIG_HOME:-"$HOME/.config"}"

    SYS_CONF="/etc/helium-browser-flags.conf"
    USR_CONF="''${XDG_CONFIG_HOME}/helium-browser-flags.conf"

    FLAGS=()

    append_flags_file() {
      local file="$1"
      [[ -r "$file" ]] || return 0
      local line safe_line
      while IFS= read -r line; do
        [[ "$line" =~ ^[[:space:]]*(#|$) ]] && continue
        case "$line" in
          *\$\(*|*\`*)
            echo "Warning: ignoring unsafe line in $file: $line" >&2
            continue
            ;;
        esac
        set -f
        safe_line=''${line//$/\\$}
        safe_line=''${safe_line//~/\\~}
        eval "set -- $safe_line"
        set +f
        for token in "$@"; do
          FLAGS+=("$token")
        done
      done < "$file"
    }

    append_flags_file "$SYS_CONF"
    append_flags_file "$USR_CONF"

    if [[ -n "''${HELIUM_USER_FLAGS:-}" ]]; then
      read -r -a ENV_FLAGS <<< "$HELIUM_USER_FLAGS"
      FLAGS+=("''${ENV_FLAGS[@]}")
    fi

    exec < /dev/null
    exec > >(exec cat)
    exec 2> >(exec cat >&2)

    exec "$HERE/helium" "''${FLAGS[@]}" "$@"
  '';

  ungoogledChromiumLicense = fetchurl {
    url = "https://raw.githubusercontent.com/imputnet/helium-linux/${finalAttrs.version}/LICENSE.ungoogled_chromium";
    hash = "sha256-lTmzlOQXmVJpiJS9Yu9lZraASrD/Ng3POlEc+vf3jE0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    cups
    dbus
    desktop-file-utils
    gtk3
    hicolor-icon-theme
    libffi
    libglvnd
    libgcrypt
    libpulseaudio
    libva
    libxkbcommon
    mesa
    nss
    pciutils
    qt6.qtbase
    liberation_ttf
    systemd
    vulkan-loader
    xdg-utils
    libxscrnsaver
  ];

  #  dontStrip = true;

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
  ];

  installPhase = ''
    runHook preInstall

    install -dm755 "${finalAttrs.heliumRoot}"
    shopt -s dotglob
    mv ./* "${finalAttrs.heliumRoot}/"
    shopt -u dotglob

    rm -f "${finalAttrs.heliumRoot}/libvulkan.so.1"
    ln -s "${vulkan-loader}/lib/libvulkan.so.1" "${finalAttrs.heliumRoot}/libvulkan.so.1"

    find "${finalAttrs.heliumRoot}" -type f -name '*.so*' -exec chmod 0644 {} +

    install -dm755 "${finalAttrs.heliumRoot}/resources/ublock"
    cat > "${finalAttrs.heliumRoot}/resources/ublock/managed_storage.json" <<'EOF'
    {
      "type": "object",
      "properties": {}
    }
    EOF

    install -Dm644 "${finalAttrs.heliumRoot}/helium.desktop" "$out/share/applications/helium.desktop"
    sed -i \
      -e 's/^Name=Helium$/Name=Helium Browser/' \
      -e 's/^Exec=helium %U$/Exec=helium-browser %U/' \
      -e 's/^Exec=helium --incognito$/Exec=helium-browser --incognito/' \
      -e 's/^Exec=helium$/Exec=helium-browser/' \
      -e 's/^Icon=helium$/Icon=helium-browser/' \
      "$out/share/applications/helium.desktop"

    install -Dm644 "${finalAttrs.heliumRoot}/product_logo_256.png" "$out/share/pixmaps/helium-browser.png"
    install -Dm644 "${finalAttrs.heliumRoot}/product_logo_256.png" "$out/share/icons/hicolor/256x256/apps/helium-browser.png"
    install -Dm644 "$ungoogledChromiumLicense" "$out/share/licenses/${finalAttrs.pname}/LICENSE.ungoogled_chromium"
    makeWrapper "$heliumWrapper" "$out/bin/helium-browser" \
      --set-default CHROME_VERSION_EXTRA "nixpkgs" \
      --set-default CHROME_WRAPPER "$out/bin/helium-browser" \
      --append-flags "''${commandLineArgs[*]}" \
      --set HELIUM_HOME "${finalAttrs.heliumRoot}" \
      --prefix LD_LIBRARY_PATH : "${finalAttrs.heliumRoot}:${finalAttrs.heliumRoot}/lib:${finalAttrs.heliumRoot}/lib.target:${
        lib.makeLibraryPath [
          addDriverRunpath.driverLink
          libglvnd
          mesa
          vulkan-loader
        ]
      }"

    runHook postInstall
  '';

  postFixup = ''
    rm -f "${finalAttrs.heliumRoot}/libvulkan.so.1"
    ln -s "${vulkan-loader}/lib/libvulkan.so.1" "${finalAttrs.heliumRoot}/libvulkan.so.1"
  '';

  meta = with lib; {
    description = "Private, fast, and honest web browser based on Chromium";

    homepage = "https://github.com/imputnet/helium-linux";

    mainProgram = "helium-browser";
    platforms = platforms.linux;
    license = [
      licenses.gpl3Only
      licenses.bsd3
    ];
  };

})
