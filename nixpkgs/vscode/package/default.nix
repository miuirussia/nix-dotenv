{ fetchurl, vscodium }:

vscodium.overrideAttrs (_: {
  version = builtins.readFile ./version;
  src = fetchurl (builtins.fromJSON (builtins.readFile ./source.json));
  installPhase = ''
    mkdir -p "$out/Applications/VSCodium.app" $out/bin
    cp -r ./* "$out/Applications/VSCodium.app"
    ln -s "$out/Applications/VSCodium.app/Contents/Resources/app/bin/codium" $out/bin/codium
  '';
})
