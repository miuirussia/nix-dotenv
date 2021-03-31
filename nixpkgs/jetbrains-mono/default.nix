{ pkgs, lib, sources, ... }:

let
  version = "master";
  fetchGitHubFiles = pkgs.callPackage ./build-support/fetchgithubfiles { };
  font-patcher-repo = {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "ac5a5f0b591170dbecfcd503aa22a564cd88be1d";
  };
  font-patcher-src = fetchGitHubFiles {
    name = "nerdfonts-patcher-${font-patcher-repo.rev}-src";
    inherit (font-patcher-repo) owner repo rev;
    paths = [
      "font-patcher"
      "src/glyphs"
    ];
    sha256 = "1yf12p4dsfy5pqnmn28q7pbadr63dpymmx8xzck21sbwl5qhlfzm";
  };
  font-patcher = pkgs.stdenvNoCC.mkDerivation {
    name = "nerdfonts-patcher-${font-patcher-repo.rev}";

    src = font-patcher-src;

    phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];
    propagatedBuildInputs = [
      (pkgs.python3.withPackages (ps: with ps; [ fontforge fonttools configparser ]))
      pkgs.ttfautohint
    ];

    buildPhase = ''
      substituteInPlace font-patcher \
        --replace '__dir__ + "/src/glyphs/"' "\"$out/share/nerdfonts/glyphs/\""
    '';

    installPhase = ''
      install -m 755 -D font-patcher $out/bin/nerdfonts-patcher
      install -m 644 -D src/glyphs/* -t $out/share/nerdfonts/glyphs/
    '';
  };
in
pkgs.stdenv.mkDerivation {
  name = "JetBrainsMono-${version}";

  src = sources.JetBrainsMono;

  buildInputs = [pkgs.fontforge font-patcher];

  buildPhase = ''
    export PYTHONIOENCODING=utf8
    for filename in ./fonts/ttf/*.ttf; do
      fontforge -script ${font-patcher}/bin/nerdfonts-patcher $filename --careful -out ./out
    done
  '';

  installPhase = ''
    mkdir -p $out/share/fonts $out/share/fonts/truetype $out/share/fonts/woff2
    cp ./out/*.ttf -d $out/share/fonts/truetype
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
