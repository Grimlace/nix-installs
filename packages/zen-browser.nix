{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname   = "zen-browser";
  version = "1.0.2-b.5";

  src = pkgs.fetchurl {
    url    = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-x86_64.tar.bz2";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    # deja este hash falso, corre nix build y nix te da el correcto
  };

  sourceRoot = ".";

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems ];

  buildInputs = with pkgs; [
    gtk3 glib dbus libGL
    xorg.libX11 xorg.libXcb
    alsa-lib libpulseaudio
  ];

  # el .desktop file es lo que fuzzel y rofi usan para encontrar la app
  desktopItems = [
    (pkgs.makeDesktopItem {
      name            = "zen-browser";
      desktopName     = "Zen Browser";
      exec            = "zen %u";
      icon            = "zen-browser";
      comment         = "Zen Browser";
      categories      = [ "Network" "WebBrowser" ];
      mimeTypes       = [ "text/html" "x-scheme-handler/http" "x-scheme-handler/https" ];
      startupWMClass  = "zen-browser";
    })
  ];

  installPhase = ''
    mkdir -p $out/lib/zen $out/bin $out/share/icons/hicolor/128x128/apps

    cp -r zen/* $out/lib/zen/

    # icono para el launcher
    cp $out/lib/zen/browser/chrome/icons/default/default128.png \
       $out/share/icons/hicolor/128x128/apps/zen-browser.png

    makeWrapper $out/lib/zen/zen $out/bin/zen \
      --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath buildInputs}"
  '';
}
