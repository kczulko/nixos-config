{ lib, stdenv, glibc, fetchurl, cups, dpkg, gnused, gawk, makeWrapper, ghostscript, file
, a2ps, coreutils, perl, gnugrep, which
}:

# it doesn't work :( but it's close... I think :)

let

  version = "3.0.0-1";
  model = "dcpj105";

  lprdeb = fetchurl {
    url = "https://download.brother.com/welcome/dlf100912/${model}lpr-${version}.i386.deb";
    sha256 = "1577lmp76pszh2hxrlqw9hh08z0gbl14s5vi9nnlyv1izgzmkr9x";
  };

  cupsdeb = fetchurl {
    # https://download.brother.com/welcome/dlf100913/dcpj105cupswrapper-3.0.0-1.i386.deb
    url = "https://download.brother.com/welcome/dlf100913/${model}cupswrapper-${version}.i386.deb";
    sha256 = "00gc4ak17h8jbakwsgrzvv85mrpcp6hm2q32cy7bbwnl5k6gsanb";
  };

in
stdenv.mkDerivation {
  name = "cups-brother-${model}";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ cups ghostscript dpkg a2ps ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    dpkg-deb -x ${cupsdeb} $out
    dpkg-deb -x ${lprdeb} $out

    dir=$out/opt/brother/Printers/dcpj105

    substituteInPlace $dir/lpd/filterdcpj105 \
      --replace /opt "$out/opt"
    wrapProgram $dir/lpd/filterdcpj105 \
      --prefix PATH ":" ${ lib.makeBinPath [ ghostscript a2ps file gnused gnugrep coreutils which ] }

    substituteInPlace $dir/lpd/psconvertij2 \
      --replace '`which gs`' "${ghostscript}/bin/gs"
    wrapProgram $dir/lpd/psconvertij2 \
      --prefix PATH : ${lib.makeBinPath [ gnused gawk ]}

    patchelf --set-interpreter ${glibc.out}/lib/ld-linux.so.2 $dir/lpd/brdcpj105filter
    patchelf --set-interpreter ${glibc.out}/lib/ld-linux.so.2 $out/usr/bin/brprintconf_dcpj105

    patchelf --set-interpreter ${glibc.out}/lib/ld-linux.so.2 "$dir/cupswrapper/brcupsconfpt1"

    mkdir -p $out/lib/cups/filter/
    ln -s $dir/lpd/filterdcpj105 $out/lib/cups/filter/brother_lpdwrapper_dcpj105
    mkdir -p $out/share/cups/model
    ln -s $dir/cupswrapper/brother_dcpj105_printer_en.ppd $out/share/cups/model/
    '';

}
