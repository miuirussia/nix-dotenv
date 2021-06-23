{ version }:

let
  pkgs = import <nixpkgs> {};
  sources = import ./sources;
  hlsPackage = import sources.hls-nix { inherit sources; ghcVersion = "ghc${version}"; checkMaterialization = true; };
in
pkgs.buildEnv {
  name = "hls-ghc${version}";
  paths = with hlsPackage; [
    ghc
    hls
    hls-wrapper
    hls-wrapper-nix
  ];
}
