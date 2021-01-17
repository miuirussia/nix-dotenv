{ pkgs, sources, ... }:

let
  nodejs = pkgs.nodejs-14_x;
  yarn = (pkgs.yarn.override { inherit nodejs; });
  yarnFlags = [
    "--offline"
    "--frozen-lockfile"
    "--ignore-engines"
  ];
  mkCocModule = { pname, src, patches ? [], buildInputs ? [], command ? "build" }: let
    pkgInfo = builtins.fromJSON (builtins.readFile (src + "/package.json"));
    version = pkgInfo.version;
    deps = pkgs.mkYarnModules {
      inherit version pname yarnFlags;

      name = "${pname}-modules-${version}";
      packageJSON = src + "/package.json";
      yarnLock = src + "/yarn.lock";
    };
  in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit version pname src;

      buildInputs = with pkgs; [
        openssl
        git
        nodePackages.typescript
        cacert
      ] // buildInputs;

      patches = patches;

      configurePhase = ''
        mkdir -p node_modules
        ln -s ${deps}/node_modules/* node_modules/
        ln -s ${deps}/node_modules/.bin node_modules/
      '';

      buildPhase = ''
        if [ -f "esbuild.js" ]; then
          NODE_ENV=production ${yarn}/bin/yarn node esbuild.js
        else
          NODE_ENV=production ${yarn}/bin/yarn ${command}
        fi
      '';
    };
in
{
  vim-coc = let
    pname = "coc-unstable";
    pkgInfo = builtins.fromJSON (builtins.readFile (src + "/package.json"));
    version = pkgInfo.version;
    src = sources.coc-unstable;
    deps = pkgs.mkYarnModules {
      inherit version pname yarnFlags;
      name = "${pname}-modules-${version}";
      packageJSON = src + "/package.json";
      yarnLock = src + "/yarn.lock";
    };
  in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      inherit version pname src;

      name = pname + "-" + version;

      dependencies = [ pkgs.nodejs-14_x ];

      configurePhase = ''
        mkdir -p node_modules
        ln -s ${deps}/node_modules/* node_modules/
        ln -s ${deps}/node_modules/.bin node_modules/
      '';

      buildPhase = ''
        NODE_ENV=production ${yarn}/bin/yarn build
      '';

      postFixup = ''
        substituteInPlace $target/autoload/coc/util.vim \
          --replace "'yarnpkg'" "'${yarn}/bin/yarnpkg'" \
          --replace "'node'" "'${pkgs.nodejs-14_x}/bin/node'"
        substituteInPlace $target/autoload/health/coc.vim \
          --replace "'yarnpkg'" "'${yarn}/bin/yarnpkg'"
      '';
    };

  vim-coc-release = pkgs.vimUtils.buildVimPlugin {
    name = "vim-coc-release";
    src = sources.coc-release;
  };

  coc-css = mkCocModule {
    pname = "coc-css";
    src = sources.coc-css;
  };

  coc-diagnostic = mkCocModule {
    pname = "coc-diagnostic";
    src = sources.coc-diagnostic;
  };

  coc-eslint = mkCocModule {
    pname = "coc-eslint";
    src = sources.coc-eslint;
  };

  coc-flow = mkCocModule {
    pname = "coc-flow";
    src = sources.coc-flow;
  };

  coc-git = mkCocModule {
    pname = "coc-git";
    src = sources.coc-git;
  };

  coc-highlight = mkCocModule {
    pname = "coc-highlight";
    src = sources.coc-highlight;
  };

  coc-json = mkCocModule {
    pname = "coc-json";
    src = sources.coc-json;
  };

  coc-pairs = mkCocModule {
    pname = "coc-pairs";
    src = sources.coc-pairs;
  };

  coc-prettier = mkCocModule {
    pname = "coc-prettier";
    src = sources.coc-prettier;
  };

  coc-python = mkCocModule {
    pname = "coc-python";
    buildInputs = [
      pkgs.python
      pkgs.python3
    ];
    src = sources.coc-python;
  };

  coc-rls = mkCocModule {
    pname = "coc-rls";
    src = sources.coc-rls;
  };

  coc-rust-analyzer = mkCocModule {
    pname = "coc-rust-analyzer";
    src = sources.coc-rust-analyzer;
  };

  coc-emmet = mkCocModule {
    pname = "coc-emmet";
    src = sources.coc-emmet;
  };

  coc-vimlsp = mkCocModule {
    pname = "coc-vimlsp";
    src = sources.coc-vimlsp;
  };

  coc-yaml = mkCocModule {
    pname = "coc-yaml";
    src = sources.coc-yaml;
  };

  coc-spell-checker = mkCocModule {
    pname = "coc-spell-checker";
    src = sources.coc-spell-checker;
  };

  coc-calc = mkCocModule {
    pname = "coc-calc";
    src = sources.coc-calc;
  };

  vimspector = pkgs.vimUtils.buildVimPlugin {
    name = "vimspector";
    src = sources.vimspector;

    buildInputs = [ pkgs.python3 pkgs.git pkgs.cacert nodejs ];
    buildPhase = ''
      export HOME=$PWD
      npm config set prefix $PWD/.npm
      npm config set cache $PWD/.npm-cache
      ./install_gadget.py --enable-rust --force-enable-node --force-enable-chrome
    '';
  };

  purescript-vim = pkgs.vimUtils.buildVimPlugin {
    name = "purescript-vim";
    src = sources.purescript-vim;
  };

  coc-syntax = pkgs.vimUtils.buildVimPlugin {
    name = "coc-syntax";
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
