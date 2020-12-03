{ ghcVersion, sources }: let
  hlsPkgs = import ./hls.nix {
    inherit sources;
    unstable = true;
    nixpkgsSrcUnstable = true;
    config = {
      inherit ghcVersion;
      haskell-nix.useMaterialization = false;
      haskell-nix.checkMaterialization = false;
      haskell-nix.hackage.index = {
        state = "2020-11-13T00:00:00Z";
        sha256 = "4f7c4c50823b2cf7605929cc0ae0ecbeee2c05c88461b3608d1c3cafbeb05470";
      };
      # An alternative to adding `--sha256` comments into the
      # cabal.project file:
      #   sha256map =
      #     { "https://github.com/jgm/pandoc-citeproc"."0.17"
      #         = "0dxx8cp2xndpw3jwiawch2dkrkp15mil7pyx7dvd810pwc22pm2q"; };
      haskell-nix.hackage.sha256map = {
        "https://github.com/bubba/brittany.git"."c59655f10d5ad295c2481537fc8abf0a297d9d1c" = "1rkk09f8750qykrmkqfqbh44dbx1p8aq1caznxxlw8zqfvx39cxl";
        "https://github.com/bubba/hie-bios.git"."cec139a1c3da1632d9a59271acc70156413017e7" = "1iqk55jga4naghmh8zak9q7ssxawk820vw8932dhympb767dfkha";
      };
      haskell-nix.nixpkgs-pin = "nixpkgs-2009";
      haskell-nix.plan = {};
    };
  };
in
{
  server = hlsPkgs.hls-renamed;
  wrapper = hlsPkgs.hls-wrapper;
}
