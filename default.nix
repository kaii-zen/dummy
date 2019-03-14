{ pkgs ? import <nixpkgs> {}
, version ? "dev" }:

pkgs.callPackage ./package.nix { inherit version; }
