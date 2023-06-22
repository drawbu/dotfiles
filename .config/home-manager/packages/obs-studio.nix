{ config
, lib
, stdenv
, fetchFromGitHub
, addOpenGLRunpath
, cmake
, fdk_aac
, ffmpeg_4
, jansson
, libjack2
, libxkbcommon
, libpthreadstubs
, libXdmcp
, qtbase
, qtsvg
, speex
, libv4l
, x264
, curl
, wayland
, xorg
, pkg-config
, libvlc
, mbedtls
, wrapGAppsHook
, scriptingSupport ? true
, luajit
, swig
, python3
, alsaSupport ? stdenv.isLinux
, alsa-lib
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio
, libcef
, pciutils
, pipewireSupport ? stdenv.isLinux
, pipewire
, libdrm
, libajantv2
, librist
, libva
, srt
, qtwayland
, wrapQtAppsHook
}:

let
  inherit (lib) optional optionals;

in
stdenv.mkDerivation rec {
  pname = "obs-studio";
  version = "29.0.2";

  src =

let
  versions = if stdenv.isLinux then {
    stable = "0.0.27";
    ptb = "0.0.42";
    canary = "0.0.158";
    development = "0.0.216";
  } else {
    stable = "0.0.273";
    ptb = "0.0.59";
    canary = "0.0.283";
    development = "0.0.8778";
  };
  version = versions.${branch};
  src = if stdenv.isDarwin then fetchurl {
        url = "https://dl-development.discordapp.net/apps/osx/${version}/DiscordDevelopment.dmg";
        sha256 = "sha256-K4rlShYhmsjT2QHjb6+IbCXJFK+9REIx/gW68bcVSVc=";
      } else fetchFromGitHub {
      owner = "obsproject";
      repo = "obs-studio";
      rev = version;
      sha256 = "sha256-TIUSjyPEsKRNTSLQXuLJGEgD989hJ5GhOsqJ4nkKVsY=";
      fetchSubmodules = true;
    };

  meta = with lib; {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
    maintainers = with maintainers; [ jb55 MP2E V miangraham ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-darwin" ];
    mainProgram = "obs";
  };
  package =
    if stdenv.isLinux
    then ./linux.nix
    else ./darwin.nix;
