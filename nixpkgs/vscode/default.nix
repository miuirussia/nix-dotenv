{ sources, pkgs }:

with builtins;

let
  extensions = ([
    (pkgs.callPackage ./codelldb { })
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace (fromJSON (readFile ./extensions.json));
in pkgs.vscode-with-extensions.override {
  vscode = pkgs.vscodium;
  vscodeExtensions = extensions;
}
