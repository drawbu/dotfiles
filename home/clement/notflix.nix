{
  stdenvNoCC,
  fetchFromGitHub,
  nodePackages,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "notflix";
  version = src.rev;

  src = fetchFromGitHub {
    owner = "Bugswriter";
    repo = pname;
    rev = "018943da49dfb8467189709505564404319f0712";
    hash = "sha256-rl0yB5H/S0YX/pRxvJjjzcA6dkbhTKjXx8gkK/47pW4=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${pname} $out/bin/
  '';

  postPatch = ''
    substituteInPlace ${pname} \
      --replace "peerflix -l -k \$magnet" "${nodePackages.peerflix}/bin/peerflix \"\$magnet\" --list --vlc" \
      --replace "https://1337x.to" "https://www.1337xx.to" \
  '';
}
