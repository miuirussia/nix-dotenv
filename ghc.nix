{ version ? "865" }:

let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-unstable { config = nixpkgsConfig; };
in {
  original = pkgs.haskell.compiler."ghc${version}";
  hix = pkgs.haskell-nix.compiler."ghc${version}";
}
