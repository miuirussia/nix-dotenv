let
  pkgs = import <nixpkgs> {};

  all-nix-deps = pkgs.writeShellScriptBin "all-nix-deps" ''
    set -eu
    set -f
    export IFS=' '

    nix-store -qR --include-outputs $@ $(nix-store -q --deriver $@)
  '';

  upload-nix = pkgs.writeShellScriptBin "upload-nix" ''
    set -eu
    set -f
    export IFS=' '

    STORE_PRIVATE_KEY=''$(mktemp)
    echo ''${NIX_UPLOAD_SECRET_KEY:?Please, define binary cache secret key} > $STORE_PRIVATE_KEY

    STORE_URL=''${NIX_UPLOAD_STORE_URL:?Please, define binary cache url. Example: s3://nix-cache?profile=default&endpoint=s3.server.m}

    echo "Signing store paths..."
    nix sign-paths --recursive --key-file ''${STORE_PRIVATE_KEY} $@
    rm $STORE_PRIVATE_KEY
    echo "Uploading store paths..."
    nix copy --to ''${STORE_URL} $@
    echo "...done!"
  '';
in
pkgs.symlinkJoin {
  name = "nix-cache-tools";
  paths = [
    all-nix-deps
    upload-nix
  ];
}
