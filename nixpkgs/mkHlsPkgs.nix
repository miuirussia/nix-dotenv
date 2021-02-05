{ ghcVersion, sources }: let
  hlsPkgs = import ./hls.nix {
    inherit sources;
    unstable = true;
    config = {
      inherit ghcVersion;
      haskell-nix.useMaterialization = false;
      haskell-nix.checkMaterialization = false;
      haskell-nix.hackage.index = {
        state = "2021-02-04T00:00:00Z";
        sha256 = "83c35b3e5aff0e3720b49f0259aadc3a248ec6e94f9c35e8c2bc6ae926bafe70";
      };
      # An alternative to adding `--sha256` comments into the
      # cabal.project file:
      #   sha256map =
      #     { "https://github.com/jgm/pandoc-citeproc"."0.17"
      #         = "0dxx8cp2xndpw3jwiawch2dkrkp15mil7pyx7dvd810pwc22pm2q"; };
      haskell-nix.hackage.sha256map = {
        "https://github.com/mpickering/apply-refact.git"."4fbd3a3a9b408bd31080848feb6b78e13c3eeb6d" = "106jnfr0mbv1p0xfpy19sd2bk222f4737pb291rqllzpcqii8h60";
        "https://github.com/alanz/ghc-exactprint.git"."6748e24da18a6cea985d20cc3e1e7920cb743795" = "18r41290xnlizgdwkvz16s7v8k2znc7h215sb1snw6ga8lbv60rb";
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
