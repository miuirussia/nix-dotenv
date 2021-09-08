{ version }:

let
  pkgs = import <nixpkgs> {};
  sources = import ./sources;
  mkHlsPackage = ghcVersion: (import sources.hls-nix).lib."${builtins.currentSystem}"."${ghcVersion}";
in
pkgs.buildEnv {
  name = "hls-ghc${version}";
  paths = with (mkHlsPackage "ghc${version}"); [
    ghc
    hls
    hls-wrapper
    hls-wrapper-nix
  ];
}
