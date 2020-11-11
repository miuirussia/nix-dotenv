let
  sources = import ../sources;
  nixpkgsUnstable = import sources.nixpkgs-unstable {};
  haskellNix = import (sources."haskell.nix") {};
  nixpkgsSrc = haskellNix.sources.nixpkgs;
  nixpkgsArgs = haskellNix.nixpkgsArgs;
  iohkPkgs = import nixpkgsSrc nixpkgsArgs;
  mkHlsPkgs = { ghcVersion }: let
    hlsPkgs = import sources.nix-hls {
      inherit sources;
      unstable = true;
      config = {
        inherit ghcVersion;
        haskell-nix.useMaterialization = false;
        haskell-nix.checkMaterialization = false;
        haskell-nix.hackage.index = {
            state = "2020-11-10T05:11:46Z";
            sha256 = "19gpp5bdgx9gkz6rqxfhv0hf4llzli7q5xd6acw18sgl6iaaxq0p";
        };
        haskell-nix.nixpkgs-pin = "nixpkgs-2009";
        haskell-nix.plan = { };
      };
    };
  in {
    server = hlsPkgs.hls-renamed;
    wrapper = hlsPkgs.hls-wrapper;
  };
  hlsPkgs865  = mkHlsPkgs { ghcVersion = "ghc865"; };
  hlsPkgs884  = mkHlsPkgs { ghcVersion = "ghc884"; };
  hlsPkgs8102 = mkHlsPkgs { ghcVersion = "ghc8102"; };
in {
# allowBroken = true;
  allowUnfree = true;

  packageOverrides = pkgs: {
    tmuxinator = pkgs.callPackage ./tmuxinator/default.nix { };
    reason-language-server = pkgs.callPackage ./reason-language-server/default.nix { inherit sources; };
    reattach-to-user-namespace = pkgs.reattach-to-user-namespace.overrideAttrs (prev: {
      version = "2.8";
      src = sources.reattach-to-user-namespace;
    });
    jetbrains-mono = pkgs.callPackage ./jetbrains-mono/default.nix { inherit sources; };

    kitty = pkgs.kitty.overrideAttrs (prev: {
      postInstall = prev.postInstall + (if pkgs.stdenv.isDarwin then ''
        cp -f "${./kitty/kitty.icns}" "$out/Applications/kitty.app/Contents/Resources/kitty.icns"
      '' else "");
    });

    niv = (import sources.niv {}).niv;

    nix-tools = iohkPkgs.haskell-nix.nix-tools.ghc865;

    haskell-nix = iohkPkgs.haskell-nix;

    hls-ghc865 = hlsPkgs865.server;
    hls-ghc884 = hlsPkgs884.server;
    hls-ghc8102 = hlsPkgs8102.server;
    hls-wrapper = hlsPkgs8102.wrapper;

    haskellPackages_u = nixpkgsUnstable.haskellPackages;

    neovim-nightly = let
      tree-sitter = (pkgs.callPackage ./tree-sitter/default.nix { inherit sources; });
    in nixpkgsUnstable.neovim-unwrapped.overrideAttrs (
      prev: {
        pname = "neovim-nightly";
        version = "master";

        buildInputs = prev.buildInputs ++ [
          tree-sitter
        ];

        src = pkgs.fetchFromGitHub {
          inherit (sources.neovim) owner repo rev sha256;
        };
      }
    );

    nodePackages = pkgs.nodePackages // (pkgs.callPackage ./nodePackages/default.nix { });

    nodejs-12_x = pkgs.nodejs-12_x.overrideAttrs (prev: {
      patches = prev.patches ++ [
        ./node/usable-repl-fix.patch
      ];
    });
  };
}
