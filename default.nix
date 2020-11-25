{ pkgs ? import <nixpkgs> {} }:

let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-stable { config = nixpkgsConfig; };
  plugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix { inherit sources; inherit pkgs; };
in
pkgs.buildEnv {
  name = "nix-env";
  paths = with pkgs; [
    aria
    autoconf
    automake
    bat
    coreutils
    curl
    ddgr
    exa
    fd
    ffmpeg
    findutils
    fontforge
    fswatch
    fzf
    gnugrep
    gnupatch
    gnused
    gnutar
    googler
    hexyl
    htop
    httpie
    imgcat
    jq
    lazygit
    lldb
    ncdu
    niv
    ranger
    reason-language-server
    reattach-to-user-namespace
    rename
    rnix-lsp
    rsync
    shellcheck
    speedtest-cli
    stlink
    tldr
    tmuxinator
    tree
    w3m
    watchman
    wget
    xz
    youtube-dl
    zlib
    zsh-completions

    cascadia-code
    jetbrains-mono

    rustup

    (
      wrapNeovim neovim-nightly {
        withNodeJs = true;

        extraPython3Packages = (
          ps: with ps; [
            black
            flake8
            jedi
          ]
        );

        configure = {
          plug.plugins = with plugins; [
            dhall-vim
            editorconfig-vim
            fzf-vim
            fzfWrapper
            haskell-vim
            indentLine
            neoformat
            nginx-vim
            postcss-syntax-vim
            purescript-vim
            tabular
            vim-airline
            vim-airline-themes
            vim-better-whitespace
            vim-cursorword
            vim-devicons
            vim-javascript
            vim-json5
            vim-jsx
            vim-languages
            vim-lastplace
            vim-markdown
            vim-nix
            vim-rooter
            vim-rust
            vim-sandwich
            vim-startify
            vim-styled-components
            vim-toml
            vista-vim

            # coc
            vim-coc

            # coc plugins
            coc-calc
            coc-css
            coc-diagnostic
            coc-emmet
            coc-flow
            coc-git
            coc-highlight
            coc-json
            coc-pairs
            coc-python
            # coc-rls
            coc-rust-analyzer
            coc-snippets
            coc-spell-checker
            # coc-cspell-dicts
            coc-syntax
            coc-tsserver
            coc-vimlsp
            coc-yaml

            #themes
            base16-vim
          ];
        };
      }
    )

    nodejs-12_x
    (yarn.override { nodejs = nodejs-12_x; })
    nodePackages.eslint_d
    nodePackages.node2nix
    nodePackages.prettier
    nodePackages.prettier_d_slim

    nodePackages.pulp
    nodePackages.purescript
    nodePackages.purescript-psa
    nodePackages.purescript-language-server
    nodePackages.spago

    hls-ghc865
    hls-ghc884
    hls-ghc8102
    hls-wrapper

    haskellPackages_u.brittany
    haskellPackages_u.cachix
    haskellPackages_u.dhall-lsp-server
    haskellPackages_u.ghcid
    haskellPackages_u.hlint
    haskellPackages_u.hoogle
    haskellPackages_u.stack

    nix-tools

    gitAndTools.diff-so-fancy
    nix-prefetch-git

    #programs from home-manager
    direnv
    starship
    zsh
    git
    kitty
    tmux
  ];
}
