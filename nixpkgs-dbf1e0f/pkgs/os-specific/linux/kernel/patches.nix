{ stdenv, fetchurl }:

let

  makeTuxonicePatch = { version, kernelVersion, sha256,
    url ? "http://tuxonice.nigelcunningham.com.au/downloads/all/tuxonice-for-linux-${kernelVersion}-${version}.patch.bz2" }:
    { name = "tuxonice-${kernelVersion}";
      patch = stdenv.mkDerivation {
        name = "tuxonice-${version}-for-${kernelVersion}.patch";
        src = fetchurl {
          inherit url sha256;
        };
        phases = [ "installPhase" ];
        installPhase = ''
          source $stdenv/setup
          bunzip2 -c $src > $out
        '';
      };
    };

  grsecPatch = { grversion ? "3.1", kversion, revision, branch, sha256 }:
    { name = "grsecurity-${grversion}-${kversion}";
      inherit grversion kversion revision;
      patch = fetchurl {
        url = "http://grsecurity.net/${branch}/grsecurity-${grversion}-${kversion}-${revision}.patch";
        inherit sha256;
      };
      features.grsecurity = true;
    };

in

rec {

  bridge_stp_helper =
    { name = "bridge-stp-helper";
      patch = ./bridge-stp-helper.patch;
    };

  no_xsave =
    { name = "no-xsave";
      patch = ./no-xsave.patch;
      features.noXsave = true;
    };

  mips_fpureg_emu =
    { name = "mips-fpureg-emulation";
      patch = ./mips-fpureg-emulation.patch;
    };

  mips_fpu_sigill =
    { name = "mips-fpu-sigill";
      patch = ./mips-fpu-sigill.patch;
    };

  mips_ext3_n32 =
    { name = "mips-ext3-n32";
      patch = ./mips-ext3-n32.patch;
    };

  tuxonice_3_10 = makeTuxonicePatch {
    version = "2013-11-07";
    kernelVersion = "3.10.18";
    sha256 = "00b1rqgd4yr206dxp4mcymr56ymbjcjfa4m82pxw73khj032qw3j";
  };

  grsecurity_stable = grsecPatch
    { kversion  = "3.14.44";
      revision  = "201506082249";
      branch    = "stable";
      sha256    = "11lclmiyg37bq3sgf6d6lky5yngr15hgmgkilrhy3081ifnsf7ax";
    };

  grsecurity_unstable = grsecPatch
    { kversion  = "4.0.5";
      revision  = "201506082251";
      branch    = "test";
      sha256    = "03im0gq8b2n6fdxvrdd5iyi1viwl83zfjwqbamqyvkhmi2vbvhwk";
    };

  grsec_fix_path =
    { name = "grsec-fix-path";
      patch = ./grsec-path.patch;
    };

  crc_regression =
    { name = "crc-backport-regression";
      patch = ./crc-regression.patch;
    };

}