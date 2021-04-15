{ pkgs, sources, ... }:

let
  buildVimPluginFrom2Nix = pkgs.vimUtils.buildVimPluginFrom2Nix;
  buildVimPlugin = pkgs.vimUtils.buildVimPlugin;
in {
  vimspector = buildVimPlugin {
    name = "vimspector";
    src = sources.vimspector;

    buildInputs = [ pkgs.python3 pkgs.git pkgs.cacert pkgs.nodejs-14_x ];
    buildPhase = ''
      export HOME=$PWD
      npm config set prefix $PWD/.npm
      npm config set cache $PWD/.npm-cache
      ./install_gadget.py --enable-rust --force-enable-node --force-enable-chrome
    '';
  };

  purescript-vim = buildVimPluginFrom2Nix {
    name = "purescript-vim";
    src = sources.purescript-vim;
  };

  vim-styled-components = buildVimPluginFrom2Nix {
    name = "vim-styled-components";
    src = sources.vim-styled-components;
  };

  vim-rust = buildVimPluginFrom2Nix {
    name = "vim-rust";
    src = sources."rust.vim";
  };

  vim-sandwich = buildVimPluginFrom2Nix {
    name = "vim-sandwich";
    src = sources.vim-sandwich;
  };

  vim-javascript = buildVimPluginFrom2Nix {
    name = "vim-javascript";
    src = sources.vim-javascript;
  };

  vim-jsx = buildVimPluginFrom2Nix {
    name = "vim-jsx";
    src = sources.vim-jsx;
  };

  nginx-vim = buildVimPluginFrom2Nix {
    name = "nginx-vim";
    src = sources.nginx-vim;
  };

  vim-toml = buildVimPluginFrom2Nix {
    name = "vim-toml";
    src = sources.vim-toml;
  };

  dhall-vim = buildVimPluginFrom2Nix {
    name = "dhall-vim";
    src = sources.dhall-vim;
  };

  tabular = buildVimPluginFrom2Nix {
    name = "tabular";
    src = sources.vim-tabular;
  };

  postcss-syntax-vim = buildVimPluginFrom2Nix {
    name = "postcss-syntax-vim";
    src = sources.postcss-syntax-vim;
  };

  vim-languages = buildVimPluginFrom2Nix {
    name = "vim-languages";
    src = sources.vim-languages;
  };

  vim-xkbswitch = buildVimPluginFrom2Nix {
    name = "vim-xkbswitch";
    src = sources.vim-xkbswitch;
  };

  vim-rooter = buildVimPluginFrom2Nix {
    name = "vim-rooter";
    src = sources.vim-rooter;
  };

  vim-airline = buildVimPluginFrom2Nix {
    name = "vim-airline";
    src = sources.vim-airline;
  };

  vim-js = buildVimPluginFrom2Nix {
    name = "vim-js";
    src = sources.vim-js;
  };

  vim-jsx-pretty = buildVimPluginFrom2Nix {
    name = "vim-jsx-pretty";
    src = sources.vim-jsx-pretty;
  };

  vim-lsp = buildVimPluginFrom2Nix {
    name = "vim-lsp";
    src = sources.vim-lsp;
  };

  vista-vim = buildVimPluginFrom2Nix {
    name = "vista-vim";
    src = sources.vista-vim;
  };

  deoplete-nvim = buildVimPluginFrom2Nix {
    name = "deoplete-nvim";
    src = sources.deoplete-nvim;
  };

  deoplete-vim-lsp = buildVimPluginFrom2Nix {
    name = "deoplete-vim-lsp";
    src = sources.deoplete-vim-lsp;
  };

  vim-json5 = buildVimPluginFrom2Nix {
    name = "json5.vim";
    src = sources."json5.vim";
  };
}
