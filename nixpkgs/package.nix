{ sources }:

let
  haskell-nix = import sources."haskell.nix" { inherit sources; };

  hpkgs = import sources.nixpkgs-unstable haskell-nix.nixpkgsArgs;

  hix = haskell-nix.hix;

  fetchGitHubFiles = hpkgs.callPackage ./build-support/fetchgithubfiles {};

  font-patcher-repo = {
    owner = "ryanoasis";
    repo = "nerd-fonts";
    rev = "ac5a5f0b591170dbecfcd503aa22a564cd88be1d";
  };

  font-patcher-src = fetchGitHubFiles {
    name = "font-patcher-${font-patcher-repo.rev}-src";
    inherit (font-patcher-repo) owner repo rev;
    paths = [
      "font-patcher"
      "src/glyphs"
    ];
    sha256 = "1yf12p4dsfy5pqnmn28q7pbadr63dpymmx8xzck21sbwl5qhlfzm";
  };

  font-patcher = hpkgs.stdenvNoCC.mkDerivation {
    name = "font-patcher-${font-patcher-repo.rev}";

    src = font-patcher-src;

    phases = [ "unpackPhase" "buildPhase" "installPhase" "fixupPhase" ];
    propagatedBuildInputs = with hpkgs; [
      (python3.withPackages (ps: with ps; [ fontforge fonttools configparser ]))
      ttfautohint
    ];

    buildPhase = ''
      substituteInPlace font-patcher \
        --replace '__dir__ + "/src/glyphs/"' "\"$out/share/nerdfonts/glyphs/\""
    '';

    installPhase = ''
      install -m 755 -D font-patcher $out/bin/font-patcher
      install -m 644 -D src/glyphs/* -t $out/share/nerdfonts/glyphs/
    '';
  };
in
{
  # allowBroken = true;
  allowUnfree = true;

  packageOverrides = pkgs: let
    nodejs = pkgs.nodejs-14_x;
  in
    {
      vscode-custom = import ./vscode/default.nix { inherit sources; inherit pkgs; };
      reason-language-server = pkgs.callPackage ./reason-language-server/default.nix { inherit sources; };
      reattach-to-user-namespace = pkgs.reattach-to-user-namespace.overrideAttrs (
        prev: {
          version = "2.8";
          src = sources.reattach-to-user-namespace;
        }
      );
      jetbrains-mono = pkgs.callPackage ./jetbrains-mono/default.nix { inherit sources; inherit font-patcher; };

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

      nix-tools = hpkgs.haskell-nix.nix-tools.ghc8107;

      nix-cache-tools = import ./nix-cache-tools;

      haskell-nix = hpkgs.haskell-nix;

      hls = let
        mkHlsPackage = ghcVersion: (import sources.hls-nix).lib."${builtins.currentSystem}"."${ghcVersion}";

        hls865 = mkHlsPackage "ghc865";
        hls884 = mkHlsPackage "ghc884";
        hls8106 = mkHlsPackage "ghc8106";
        hls8107 = mkHlsPackage "ghc8107";
      in
        pkgs.buildEnv {
          name = "haskell-language-server";

          paths = [
            hls865.hls-renamed
            hls884.hls-renamed
            hls8106.hls-renamed
            hls8107.hls-renamed
            hls8107.hls-wrapper
            hls8107.hls-wrapper-nix
          ];
        };

      haskell = let
        mkGhcPackage = ghcVersion: (import sources.hls-nix).lib."${builtins.currentSystem}"."${ghcVersion}".ghc;
      in
        pkgs.haskell // {
          compiler = pkgs.haskell.compiler // {
            ghc865 = mkGhcPackage "ghc865";
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


      nodePackages = pkgs.nodePackages // (pkgs.callPackage ./nodePackages/default.nix { inherit nodejs; });

      wrapNeovimUnstable = pkgs.wrapNeovimUnstable.override { inherit nodejs; };
      neovimUtils = pkgs.neovimUtils.override { inherit nodejs; };

      inherit font-patcher hix;
    };
}
