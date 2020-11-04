{ pkgs, lib, sources, ... }:

let
  version = "master";
in
pkgs.stdenv.mkDerivation {
  name = "tree-sitter";

  src = sources.tree-sitter;

  postBuild = ''
    mkdir -p $out/lib $out/include
    cp -r ./libtree-sitter* $out/lib
    cp -r ./lib/include/* $out/include
  '';

  dontInstall = true;

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "A parser generator tool and an incremental parsing library";
    longDescription = ''
      Tree-sitter is a parser generator tool and an incremental parsing library.
      It can build a concrete syntax tree for a source file and efficiently update the syntax tree as the source file is edited.
      Tree-sitter aims to be:
      * General enough to parse any programming language
      * Fast enough to parse on every keystroke in a text editor
      * Robust enough to provide useful results even in the presence of syntax errors
      * Dependency-free so that the runtime library (which is written in pure C) can be embedded in any application
    '';
    license = licenses.mit;
    maintainers = [ maintainers.Profpatsch ];
  };
}
