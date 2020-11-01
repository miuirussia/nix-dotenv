{ pkgs ? import <nixpkgs> {} }:

let
  sources       = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs          = import sources.nixpkgs-stable { config = nixpkgsConfig; };
in pkgs.buildEnv {
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
    tmux
    tmuxinator
    tree
    w3m
    watchman
    wget
    xz
    youtube-dl
    zlib
    zsh-completions

    rustup

    neovim-nightly

    nodejs-12_x
    (yarn.override { nodejs = nodejs-12_x; })
    nodePackages.eslint_d
    nodePackages.node2nix
    nodePackages.prettier

    purescriptPackages.pulp
    purescriptPackages.purescript
    purescriptPackages.purescript-psa
    purescriptPackages.purescript-language-server
    purescriptPackages.spago

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
  ];
}
