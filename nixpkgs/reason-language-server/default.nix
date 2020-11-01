{ sources, stdenv }:

stdenv.mkDerivation rec {
  pname = "reason-language-server";
  version = "1.7.8";

  src = sources.reason-language-server;

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r reason-language-server $out/bin/reason-language-server
  '';

  meta = with stdenv.lib; {
    description = "A language server for reason, in reason";
    homepage = "https://github.com/jaredly/reason-language-server/releases";
    platforms = [ "x86_64-darwin" ];
  };
}
