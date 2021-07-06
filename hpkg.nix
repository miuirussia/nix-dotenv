{ name }:

let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-unstable { config = nixpkgsConfig; };
in
pkgs.haskellPackages."${name}"
