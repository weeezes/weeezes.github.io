{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc883" }:
let
  nixpkgs-pinned = import (builtins.fetchTarball {
    name = "nixos-20.09pre226442";
    url = "https://github.com/nixos/nixpkgs/archive/6405edf2dca7f6faaa29266136dfa7f8f969b511.tar.gz";
    sha256 = "069skn0ayxmhdlw1xcj92cij7wydkk2bndkcyk4vvhms16p9wj46";
  }) {};
in
  nixpkgs-pinned.pkgs.haskell.packages.${compiler}.callPackage ./weeezes-pages.nix { }