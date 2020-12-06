let
  sources = import ../sources;
  nixpackages = import ./package.nix;
in
  nixpackages { inherit sources; }
