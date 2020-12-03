{ version ? "865" }:

let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-stable { config = nixpkgsConfig; };
in
pkgs.buildEnv {
  name = "hls-" + version;
  paths = [
    pkgs."hls-ghc${version}"
  ];
}
