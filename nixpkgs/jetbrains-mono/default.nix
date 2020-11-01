{ pkgs, lib, sources, ... }:

let
  version = "master";
in
pkgs.stdenv.mkDerivation {
  name = "JetBrainsMono-${version}";

  src = sources.JetBrainsMono;

  installPhase = ''
    mkdir -p $out/share/fonts $out/share/fonts/truetype $out/share/fonts/woff2
    cp ./fonts/ttf/*.ttf -d $out/share/fonts/truetype
    cp ./fonts/webfonts/*.woff2 -d $out/share/fonts/woff2
  '';

  meta = with lib; {
    description = "A typeface made for developers";
    homepage = "https://jetbrains.com/mono/";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.all;
  };
}
