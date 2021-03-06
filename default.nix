let
  sources = import ./sources;
  nixpkgsConfig = import ./nixpkgs/config.nix;
  pkgs = import sources.nixpkgs-unstable { config = nixpkgsConfig; };
  plugins = pkgs.vimPlugins // pkgs.callPackage ./custom-plugins.nix { inherit sources; inherit pkgs; };
in
  with pkgs;
  buildEnv {
    name = "nix-env";
    paths = [
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
        let
          pluginList = with plugins; [
            dhall-vim
            editorconfig-vim
            fzf-vim
            fzfWrapper
            haskell-vim
            indentLine
            intero-neovim
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
            vim-styled-components
            vim-toml
            vimspector
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
            coc-spell-checker
            # coc-cspell-dicts
            coc-syntax
            coc-tsserver
            coc-vimlsp
            coc-yaml

            #themes
            base16-vim
          ];

          filter = pkgs.lib.filter;

          pluginConfig = p:
            if p ? plugin && (p.config or "") != "" then ''
              " ${p.plugin.pname} {{{
              ${p.config}
              " }}}
            '' else
              "";

          moduleConfigure = {
            packages.kdevlab = {
              start = filter (f: f != null) (
                map
                  (x: if x ? plugin && x.optional == true then null else (x.plugin or x))
                  pluginList
              );
              opt = filter (f: f != null)
                (
                  map (x: if x ? plugin && x.optional == true then x.plugin else null)
                    pluginList
                );
            };
            customRC = pkgs.lib.concatMapStrings pluginConfig pluginList;
          };

          extraPackages = with pkgs; [
            nodejs-14_x
            yarn
            git
          ];


          neovimConfig = neovimUtils.makeNeovimConfig {
            withPython2 = true;
            withPython3 = true;
            withNodeJs = true;
            viAlias = true;
            vimAlias = true;

            extraPython3Packages = (
              ps: with ps; [
                black
                flake8
                jedi
              ]
            );

            plugins = pluginList;

            configure = moduleConfigure;
          };

        in
          wrapNeovimUnstable neovim-nightly (
            neovimConfig // {
              wrapperArgs = (lib.escapeShellArgs neovimConfig.wrapperArgs) + " " + "--set NVIM_LOG_FILE /dev/null --suffix PATH : \"${pkgs.lib.makeBinPath extraPackages}\"";
            }
          )
      )

      nodejs-14_x
      (yarn.override { nodejs = nodejs-14_x; })
      nodePackages.eslint_d
      nodePackages.node2nix
      nodePackages.prettier-eslint-cli
      nodePackages.fx
      nodePackages.neovim

      # purescript
      nodePackages.pulp
      nodePackages.purescript
      nodePackages.purescript-psa
      nodePackages.purescript-language-server
      nodePackages.spago

      (hiPrio nixFlakes)


      # haskell packages
      hls-wrapper

      haskellPackages.brittany
      haskellPackages.cachix
      # haskellPackages.dhall-lsp-server
      haskellPackages.ghcid
      haskellPackages.hlint
      haskellPackages.hoogle
      haskellPackages.stack
      nix-tools

      gitAndTools.diff-so-fancy
      nix-prefetch-git

      #programs from home-manager
      direnv
      starship
      zsh
      gitAndTools.gitFull
      kitty
      tmux
    ];
  }
