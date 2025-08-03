# source: https://github.com/NixOS/nixpkgs/issues/217996
{
  pkgs,
  ...
}:
let
  pname = "vuescan";
  version = "9.8";
  desktopItem = pkgs.makeDesktopItem {
    name = "VueScan";
    desktopName = "VueScan";
    genericName = "Scanning Program";
    comment = "Scanning Program";
    icon = "vuescan";
    terminal = false;
    type = "Application";
    startupNotify = true;
    categories = [
      "Graphics"
      "Utility"
    ];
    keywords = [
      "scan"
      "scanner"
    ];

    exec = "vuescan";
  };
in
pkgs.stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = pkgs.fetchurl {
    url = "https://www.hamrick.com/files/vuex6498.tgz";
    hash = "sha256-ryO54vyVjhq66No+Ktj7PRm38knudZ6x0JlLmRcFhbI=";
  };

  # Stripping breaks the program
  dontStrip = true;

  nativeBuildInputs = [
    pkgs.gnutar
    pkgs.autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    glibc
    gtk3
    libgudev
  ];

  unpackPhase = ''
    tar xfz $src
  '';

  installPhase = ''
    install -m755 -D VueScan/vuescan $out/bin/vuescan

    mkdir -p $out/share/icons/hicolor/scalable/apps/
    cp VueScan/vuescan.svg $out/share/icons/hicolor/scalable/apps/vuescan.svg

    mkdir -p $out/lib/udev/rules.d/
    cp VueScan/vuescan.rul $out/lib/udev/rules.d/60-vuescan.rules

    mkdir -p $out/share/applications/
    ln -s ${desktopItem}/share/applications/* $out/share/applications
  '';
}
