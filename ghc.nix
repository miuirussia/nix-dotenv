{ version ? "865" }:

let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-unstable { config = nixpkgsConfig; };
in {
  hix = pkgs.haskell-nix.compiler."ghc${version}";
}
