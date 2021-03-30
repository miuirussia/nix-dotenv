{ sources, pkgs }:

let
  extensions = ([
    (pkgs.callPackage ./codelldb { })
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "vscode-theme-onedark";
      publisher = "akamud";
      version = "2.2.3";
      sha256 = "1m6f6p7x8vshhb03ml7sra3v01a7i2p3064mvza800af7cyj3w5m";
    }
    {
      name = "base16-themes";
      publisher = "AndrsDC";
      version = "1.4.5";
      sha256 = "0qxxhhjr2hj60spy7cv995m1px5z6m2syhxsnfl1wj2aqkwp32cs";
    }
    {
      name = "vscode-neovim";
      publisher = "asvetliakov";
      version = "0.0.78";
      sha256 = "0a3zwp1w8ak985327cmjw28i7zlxcj1a6jwb750vd867hhqfw9bp";
    }
    {
      name = "Nix";
      publisher = "bbenoist";
      version = "1.0.1";
      sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
    }
    {
      name = "toml";
      publisher = "be5invis";
      version = "0.5.1";
      sha256 = "1r1y6krqw5rrdhia9xbs3bx9gibd1ky4bm709231m9zvbqqwwq2j";
    }
    {
      name = "dhall-lang";
      publisher = "dhall";
      version = "0.0.4";
      sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
    }
    {
      name = "gitlens";
      publisher = "eamodio";
      version = "11.3.0";
      sha256 = "0py8c5h3pp99r0q9x2dgh1ryp05dbndyc5ipp999z3x1xvwnfrlv";
    }
    {
      name = "github-vscode-theme";
      publisher = "GitHub";
      version = "3.0.0";
      sha256 = "1a77mbx75xfsfdlhgzghj9i7ik080bppc3jm8c00xp6781987fpa";
    }
    {
      name = "haskell";
      publisher = "haskell";
      version = "1.2.0";
      sha256 = "0vxsn4s27n1aqp5pp4cipv804c9cwd7d9677chxl0v18j8bf7zly";
    }
    {
      name = "nix-ide";
      publisher = "jnoortheen";
      version = "0.1.10";
      sha256 = "0c9x3br92rpsmc7d0i3c8rnvhyvwz7hvrrfd3sds9p168lz87gli";
    }
    {
      name = "language-haskell";
      publisher = "justusadam";
      version = "3.4.0";
      sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
    }
    {
      name = "rust-analyzer";
      publisher = "matklad";
      version = "0.2.538";
      sha256 = "0ivf8yxs17x10z6q44ij3vpamwzga0wiqfg9hzp3bs6mff9szfmb";
    }
    {
      name = "vscode-docker";
      publisher = "ms-azuretools";
      version = "1.11.0";
      sha256 = "141800jcxslqa5nbwcdj4mwnysa42mxligvc073gf225ns984vfr";
    }
    {
      name = "remote-containers";
      publisher = "ms-vscode-remote";
      version = "0.163.2";
      sha256 = "0dvs5f1a4mnbg509hphp5wchn1n79r0rsf7qjv0wgs9phlrlaijs";
    }
    {
      name = "remote-ssh";
      publisher = "ms-vscode-remote";
      version = "0.65.1";
      sha256 = "0xg6p1x479lmm1chn69hd7b43p708hb9p7c4aqbmqf0d96xgsa9r";
    }
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.65.1";
      sha256 = "0ajbn3iyhxajj7v6j5sh74j9bm6qh2sx0964vlillbiwr5i845f0";
    }
    {
      name = "debugger-for-chrome";
      publisher = "msjsdiag";
      version = "4.12.12";
      sha256 = "0nkzck3i4342dhswhpg4b3mn0yp23ipad228hwdf23z8b19p4b5g";
    }
    {
      name = "ide-purescript";
      publisher = "nwolverson";
      version = "0.24.0";
      sha256 = "1z20hlzwhhi9yzdb8v5iqj7rbf3m5f6xg5p2mc188j85b4gp4jcm";
    }
    {
      name = "language-purescript";
      publisher = "nwolverson";
      version = "0.2.4";
      sha256 = "16c6ik09wj87r0dg4l0swl2qlqy48jkavpp5i90l166x2mjw2b7w";
    }
    {
      name = "rust";
      publisher = "rust-lang";
      version = "0.7.8";
      sha256 = "039ns854v1k4jb9xqknrjkj8lf62nfcpfn0716ancmjc4f0xlzb3";
    }
    {
      name = "crates";
      publisher = "serayuzgur";
      version = "0.5.7";
      sha256 = "1q19mb686mpgvx129bq226a2kfynaz942sp870b1i50hvxnshiw3";
    }
    {
      name = "vscode-nginx";
      publisher = "william-voyek";
      version = "0.7.2";
      sha256 = "0s4akrhdmrf8qwn6vp8kc31k5hx2k2wml5mcashfc09hxiqsf2cq";
    }
  ];
in pkgs.vscode-with-extensions.override {
  vscode = pkgs.vscodium;
  vscodeExtensions = extensions;
}
