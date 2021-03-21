{ pkgs, sources, ... }:

{
  vimspector = pkgs.vimUtils.buildVimPlugin {
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

  intero-neovim = pkgs.vimUtils.buildVimPlugin {
    name = "intero-neovim";
    src = sources.intero-neovim;
  };

  purescript-vim = pkgs.vimUtils.buildVimPlugin {
    name = "purescript-vim";
    src = sources.purescript-vim;
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

  vim-airline = pkgs.vimUtils.buildVimPlugin {
    name = "vim-airline";
    patches = [./patches/vim-airline.patch];
    src = sources.vim-airline;
  };

  vim-js = pkgs.vimUtils.buildVimPlugin {
    name = "vim-js";
    src = sources.vim-js;
  };

  vim-jsx-pretty = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jsx-pretty";
    src = sources.vim-jsx-pretty;
  };

  vim-lsp = pkgs.vimUtils.buildVimPlugin {
    name = "vim-lsp";
    src = sources.vim-lsp;
  };

  asyncomplete = pkgs.vimUtils.buildVimPlugin {
    name = "asyncomplete.vim";
    src = sources."asyncomplete.vim";
  };

  asyncomplete-lsp = pkgs.vimUtils.buildVimPlugin {
    name = "asyncomplete-lsp.vim";
    src = sources."asyncomplete-lsp.vim";
  };

  asyncomplete-buffer = pkgs.vimUtils.buildVimPlugin {
    name = "asyncomplete-buffer.vim";
    src = sources."asyncomplete-buffer.vim";
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
