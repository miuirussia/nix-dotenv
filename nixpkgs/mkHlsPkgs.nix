{ ghcVersion, sources }: let
  hlsPkgs = import sources.nix-hls {
    inherit sources;
    unstable = true;
    config = {
      inherit ghcVersion;
      haskell-nix.useMaterialization = false;
      haskell-nix.checkMaterialization = false;
      haskell-nix.hackage.index = {
        state = "2020-11-11T00:00:00Z";
        sha256 = "c8f87a190b33cfadbc08ddcd687d224845155e41b23600dddd94a8716b408be5";
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
