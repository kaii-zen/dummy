{ src, nixpkgs }:

let
  pkgs = import nixpkgs {};

  jobs = rec {
    package = pkgs.callPackage ./. { version = src.shortRev; };

    docker-image = pkgs.dockerTools.buildImage (package.docker // {
      contents = package;
    });
  };
in jobs

