{ pkgs, sources, ... }:

let
  yarn = (pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; });
  yarn2nix = pkgs.callPackage (sources.yarn2nix) { pkgs = pkgs; nodejs = pkgs.nodejs-12_x; yarn = yarn; };
  mkCocModule = { pname, version, src, patches ? [], command ? "build" }: let
    deps = yarn2nix.mkYarnModules rec {
      inherit version pname;
      name = "${pname}-modules-${version}";
      packageJSON = src + "/package.json";
      yarnLock = src + "/yarn.lock";
    };
  in pkgs.vimUtils.buildVimPluginFrom2Nix {
    inherit version pname src;

    buildInputs = [ pkgs.openssl pkgs.git pkgs.nodePackages.typescript ];

    patches = patches;

    configurePhase = ''
      mkdir -p node_modules
      ln -s ${deps}/node_modules/* node_modules/
      ln -s ${deps}/node_modules/.bin node_modules/
    '';

    buildPhase = ''
      GIT_SSL_NO_VERIFY=true ${yarn}/bin/yarn ${command}
    '';
  };
in {
  vim-coc-release = pkgs.vimUtils.buildVimPlugin {
    name = "vim-coc-release";
    src = sources."coc.nvim";
  };

  coc-css = mkCocModule {
    pname = "coc-css";
    version = "1.2.2";
    src = sources.coc-css;
  };

  coc-diagnostic = mkCocModule {
    pname = "coc-diagnostic";
    version = "1.4.2";
    src = sources.coc-diagnostic;
  };

  coc-eslint = mkCocModule {
    pname = "coc-eslint";
    version = "1.2.4";
    src = sources.coc-eslint;
  };

  coc-flow = mkCocModule {
    pname = "coc-flow";
    version = "0.1.2";
    src = sources.coc-flow;
  };

  coc-git = mkCocModule {
    pname = "coc-git";
    version = "1.6.16";
    src = sources.coc-git;
  };

  coc-highlight = mkCocModule {
    pname = "coc-highlight";
    version = "1.2.5";
    src = sources.coc-highlight;
  };

  coc-json = mkCocModule {
    pname = "coc-json";
    version = "1.2.4";
    src = sources.coc-json;
  };

  coc-pairs = mkCocModule {
    pname = "coc-pairs";
    version = "1.2.20";
    src = sources.coc-pairs;
  };

  coc-prettier = mkCocModule {
    pname = "coc-prettier";
    version = "1.1.11";
    src = sources.coc-prettier;
  };

  coc-python = mkCocModule {
    pname = "coc-python";
    version = "1.2.7";
    src = sources.coc-python;
  };

  coc-rls = mkCocModule {
    pname = "coc-rls";
    version = "1.1.4";
    src = sources.coc-rls;
  };

  coc-rust-analyzer = mkCocModule {
    pname = "coc-rust-analyzer";
    version = "0.7.14";
    src = sources.coc-rust-analyzer;
  };

  coc-snippets = mkCocModule {
    pname = "coc-snippets";
    version = "2.1.17";
    src = sources.coc-snippets;
  };

  coc-emmet = mkCocModule {
    pname = "coc-emmet";
    version = "1.1.6";
    src = sources.coc-emmet;
  };

  coc-vimlsp = mkCocModule {
    pname = "coc-vimlsp";
    version = "0.4.4";
    src = sources.coc-vimlsp;
  };

  coc-yaml = mkCocModule {
    pname = "coc-yaml";
    version = "1.0.4";
    src = sources.coc-yaml;
  };

  coc-spell-checker = mkCocModule {
    pname = "coc-spell-checker";
    version = "1.2.0";
    src = sources.coc-spell-checker;
  };

  coc-calc = mkCocModule {
    pname = "coc-calc";
    version = "2.0.0";
    src = sources.coc-calc;
  };

  purescript-vim = pkgs.vimUtils.buildVimPlugin {
    name = "purescript-vim";
    version = "1.0.0";
    src = sources.purescript-vim;
  };

  coc-syntax = pkgs.vimUtils.buildVimPlugin {
    name = "coc-syntax";
    version = "1.2.4";
    src = sources.coc-syntax;
  };

  vim-styled-components = pkgs.vimUtils.buildVimPlugin {
    name = "vim-styled-components";
    src = sources.vim-styled-components;
  };

  vim-rust = pkgs.vimUtils.buildVimPlugin {
    name = "vim-rust";
    src = sources."rust.vim";
  };

  vim-sandwich = pkgs.vimUtils.buildVimPlugin {
    name = "vim-sandwich";
    src = sources.vim-sandwich;
  };

  vim-javascript = pkgs.vimUtils.buildVimPlugin {
    name = "vim-javascript";
    src = sources.vim-javascript;
  };

  vim-jsx = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jsx";
    src = sources.vim-jsx;
  };

  nginx-vim = pkgs.vimUtils.buildVimPlugin {
    name = "nginx-vim";
    src = sources.nginx-vim;
  };

  vim-toml = pkgs.vimUtils.buildVimPlugin {
    name = "vim-toml";
    src = sources.vim-toml;
  };

  dhall-vim = pkgs.vimUtils.buildVimPlugin {
    name = "dhall-vim";
    src = sources.dhall-vim;
  };

  tabular = pkgs.vimUtils.buildVimPlugin {
    name = "tabular";
    src = sources.vim-tabular;
  };

  postcss-syntax-vim = pkgs.vimUtils.buildVimPlugin {
    name = "postcss-syntax-vim";
    src = sources.postcss-syntax-vim;
  };

  vim-languages = pkgs.vimUtils.buildVimPlugin {
    name = "vim-languages";
    src = sources.vim-languages;
  };

  vim-xkbswitch = pkgs.vimUtils.buildVimPlugin {
    name = "vim-xkbswitch";
    src = sources.vim-xkbswitch;
  };

  vim-rooter = pkgs.vimUtils.buildVimPlugin {
    name = "vim-rooter";
    src = sources.vim-rooter;
  };

  vista-vim = pkgs.vimUtils.buildVimPlugin {
    name = "vista-vim";
    src = sources.vista-vim;
  };

  vim-json5 = pkgs.vimUtils.buildVimPlugin {
    name = "json5.vim";
    src = sources."json5.vim";
  };
}
