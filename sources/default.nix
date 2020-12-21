let

    srcs = import ./sources.nix;

    lib = (import srcs.nixpkgs { config = {}; overlays = []; }).lib;

    isDarwin = builtins.elem builtins.currentSystem lib.systems.doubles.darwin;

    sources = builtins.fromJSON
        (builtins.readFile ./sources.json);

    pkgs = import (import ./sources.nix).nixpkgs {
        config = {};
        overlays = [];
    };

    fromGitHub = source: name:
        with source; pkgs.fetchFromGitHub {
            inherit owner repo rev name sha256;
            fetchSubmodules = true;
        };

    mkPatchedNixpkgs = { src }:
      pkgs.stdenv.mkDerivation {
        name = "nixpkgs-${src.branch}-patched";
        patches = [
          ./nixpkgs.patch
        ] ++ lib.optional (isDarwin && src.branch == "nixpkgs-20.09-darwin") [
          (pkgs.fetchpatch {
            name = "big-sur-fix.patch";
            url = "https://github.com/NixOS/nixpkgs/pull/105799.patch";
            sha256 = "1i0c2v9q4mdl06r8dd5a9lw9wpjm38iivci3md69vx4m1rvwkw6n";
          })
        ];

        inherit src;

        installPhase = ''
          mkdir -p $out
          cp -r . $out
        '';

        doCheck = false;
        dontFixup = true;
      };

    darwinizedSrcs =
        if isDarwin
        then srcs // {
          nixpkgs-stable = mkPatchedNixpkgs {
            src = srcs.nixpkgs-stable-darwin;
          };
        }
        else srcs // {
          nixpkgs-stable = mkPatchedNixpkgs {
            src = srcs.nixpkgs-stable-linux;
          };
        };

    overrides = {
        hls-stable =
            let s = sources.hls-stable;
            in fromGitHub s "haskell-hls-${s.branch}-src";
        hls-unstable =
            let s = sources.hls-unstable;
            in fromGitHub s "haskell-hls-${s.branch}-src";
        nixpkgs-unstable =
            mkPatchedNixpkgs {
              src = srcs.nixpkgs-unstable;
            };

        coc-unstable =
            let
              src = srcs.coc-unstable;
            in pkgs.stdenv.mkDerivation {
              name = "coc-unstable";

              inherit src;

              buildPhase = ''
                sed -i 's/stringify(options.query)/stringify(options.query as any)/' src/model/fetch.ts
                sed -i 's/cp\.execSync(\x27git rev-parse HEAD\x27, {encoding: \x27utf8\x27})/\x27${src.rev}\x27/' webpack.config.js
              '';

              installPhase = ''
                mkdir -p $out
                cp -r . $out
              '';

              doCheck = false;
              dontFixup = true;
            };
    };

in darwinizedSrcs // overrides
