{ sources }:

let
  haskellNix = import (sources."haskell.nix") {};
  iohkArgs = haskellNix.nixpkgsArgs // {
    overlays = haskellNix.nixpkgsArgs.overlays ++ [
      (
        self: super: {
          haskell-nix = super.haskell-nix // {
            compiler = super.haskell-nix.compiler // {
              ghc844 = super.haskell-nix.compiler.ghc844.overrideAttrs (
                prev: {
                  src = prev.src.overrideAttrs (
                    prevSrc: {
                      patches = prevSrc.patches ++ [
                        ./ghc/fix-ghc844.diff
                      ];
                    }
                  );
                }
              );
            };
          };
        }
      )
    ];
  };
  iohkPkgs = import sources.nixpkgs-unstable iohkArgs;
  mkHlsPkgs = import ./mkHlsPkgs.nix;
  hlsPkgs865 = mkHlsPkgs { ghcVersion = "ghc865"; inherit sources; };
  hlsPkgs884 = mkHlsPkgs { ghcVersion = "ghc884"; inherit sources; };
  hlsPkgs8103 = mkHlsPkgs { ghcVersion = "ghc8103"; inherit sources; };
  hlsPkgs8104 = mkHlsPkgs { ghcVersion = "ghc8104"; inherit sources; };
in
{
  # allowBroken = true;
  allowUnfree = true;

  packageOverrides = pkgs: let
    nodejs-14_x = pkgs.nodejs-14_x.overrideAttrs (
      prev: {
        patches = prev.patches ++ [
          ./node/usable-repl-fix.patch
        ];
      }
    );
  in
    {
      tmuxinator = pkgs.callPackage ./tmuxinator/default.nix {};
      reason-language-server = pkgs.callPackage ./reason-language-server/default.nix { inherit sources; };
      reattach-to-user-namespace = pkgs.reattach-to-user-namespace.overrideAttrs (
        prev: {
          version = "2.8";
          src = sources.reattach-to-user-namespace;
        }
      );
      jetbrains-mono = pkgs.callPackage ./jetbrains-mono/default.nix { inherit sources; };

      kitty = pkgs.kitty.overrideAttrs (
        prev: {
          postInstall = prev.postInstall + (
            if pkgs.stdenv.isDarwin then ''
              cp -f "${./kitty/kitty.icns}" "$out/Applications/kitty.app/Contents/Resources/kitty.icns"
            '' else ""
          );
        }
      );

      niv = (import sources.niv {}).niv;

      nix-tools = iohkPkgs.haskell-nix.nix-tools.ghc8102;

      nix-cache-tools = import ./nix-cache-tools;

      haskell-nix = iohkPkgs.haskell-nix;

      hls-ghc865 = hlsPkgs865.server;
      hls-ghc884 = hlsPkgs884.server;
      hls-ghc8103 = hlsPkgs8103.server;
      hls-ghc8104 = hlsPkgs8104.server;
      hls-wrapper = hlsPkgs8104.wrapper;

      haskell = pkgs.haskell // {
        compiler = pkgs.haskell.compiler // {
          ghc844 = iohkPkgs.haskell-nix.compiler.ghc844;
        };
      };

      neovim-nightly = let
        tree-sitter = (pkgs.callPackage ./tree-sitter/default.nix { inherit sources; });
      in
        pkgs.neovim-unwrapped.overrideAttrs (
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

      flow = pkgs.writeShellScriptBin "flow"
        ''
          lookup() {
            local file="''${1}"
            local curr_path="''${2}"
            [[ -z "''${curr_path}" ]] && curr_path="''${PWD}"

            # Search recursively upwards for file.
            until [[ "''${curr_path}" == "/" ]]; do
              if [[ -e "''${curr_path}/''${file}" ]]; then
                echo "''${curr_path}/''${file}"
                break
              else
                curr_path=$(dirname "''${curr_path}")
              fi
            done
          }

          FLOW_EXEC=$(lookup "node_modules/.bin/flow")

          [[ -z "''${FLOW_EXEC}" ]] && FLOW_EXEC="${pkgs.flow}/bin/flow"
          $FLOW_EXEC "$@"
        '';


      nodePackages = pkgs.nodePackages // (pkgs.callPackage ./nodePackages/default.nix { nodejs = pkgs.nodejs-14_x; });

      wrapNeovimUnstable = pkgs.wrapNeovimUnstable.override { nodejs = nodejs-14_x; };
      neovimUtils = pkgs.neovimUtils.override { nodejs = pkgs.nodejs-14_x; };

      inherit nodejs-14_x;
    };
}
