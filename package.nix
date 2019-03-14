{ stdenv, fetchurl, lolcat, jp2a
, version }:

stdenv.mkDerivation rec {
  inherit version;

  bareName = "hello-kitty";
  name     = "${bareName}-${version}";

  buildInputs = [ jp2a lolcat ];

  src = fetchurl {
    url    = https://upload.wikimedia.org/wikipedia/commons/c/cf/Hello-kitty.jpg;
    sha256 = "1glmph02z50h2xf0faaa55jkqwrfpbv7crx927xrf2xppx9vi5mv";
  };

  doCheck = true;
  phases = [ "buildPhase" "installPhase" "checkPhase" ];

  buildPhase = ''
    cat <<EOF > $bareName
    #!${stdenv.shell}

    set -e

    mapfile -t ascii_art <<ASCIIART
    $(jp2a $src | lolcat --force)
    ASCIIART

    echo ${version}
    printf "%s\n" "\''${ascii_art[@]}"

    EOF
  '';

  installPhase = "install -D $bareName $out/bin/$bareName";

  checkPhase = "$out/bin/$bareName";

  passthru.docker = {
    name       = bareName;
    tag        = version;
    config.Cmd = [ bareName ];
  };
}
