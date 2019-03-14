{ nixpkgs ? <nixpkgs>
, src ? builtins.fetchGit ./.
, declInput ? {}
}:

let
  pkgs = import nixpkgs {};

  jobsets.master = {
    enabled          = true;
    hidden           = false;
    description      = "build master branch";
    nixexprinput     = "src";
    nixexprpath      = "release.nix";
    checkinterval    = 30;
    schedulingshares = 100;
    enableemail      = true;
    emailoverride    = "shay.bergmann@iohk.io";
    keepnr           = 10;

    inputs = {
      src = {
        type             = "git";
        value            = "https://github.com/kreisys/dummy.git master";
        emailresponsible = false;
      };

      nixpkgs = {
        type             = "git";
        value            = "https://github.com/NixOS/nixpkgs-channels.git nixos-18.09";
        emailresponsible = false;
      };
    };
  };

in {
  jobsets = pkgs.runCommand "spec.json" {} ''
    cat <<EOF
    JSON
    ${builtins.toJSON declInput}
    /JSON
    EOF
    cp ${pkgs.writeText "spec.json" (builtins.toJSON jobsets)} $out
  '';
}
