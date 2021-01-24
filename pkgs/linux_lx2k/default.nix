{ stdenv
, runCommand
, fetchgit
, linuxManualConfig
, features ? { }
, kernelPatches ? self.linux_4_19.kernelPatches ++ (
      map
        (p: {
          name = builtins.baseNameOf p;
          patch = p;
        }) [
        ./patches/0001-arm64-dts-lx2160a-add-lx2160acex7-device-tree-build.patch
        ./patches/0002-arm64-dts-lx2160a-add-lx2160acex7-device-tree.patch
        ./patches/0004-pci-accept-pcie-base-class-id-0x0.patch
        ./patches/0005-arm64-dts-lx2160a-cex7-add-ltc3882-support.patch
        ./patches/0006-arm64-dts-lx2160a-cex7-add-on-module-eeproms.patch
      ]
    )
, randstructSeed ? null
}:

# Additional features cannot be added to this kernel
assert features == { };
let
  passthru = { features = { }; };

  drv = linuxManualConfig ({
    inherit stdenv kernelPatches;

    src = fetchgit {
      url = "https://source.codeaurora.org/external/qoriq/qoriq-components/linux";
      rev = "LSDK-19.09-V4.19";
      sha256 = "03ckcl8sfrmm0305j15i2bxyg4yhnwz5a8i5hcxb4l9gb0j1crv6";
    };

    version = "4.19.68";
    modDirVersion = "4.19.68";

    configfile = ./config;

    allowImportFromDerivation = true; # Let nix check the assertions about the config
  } // stdenv.lib.optionalAttrs (randstructSeed != null) { inherit randstructSeed; });

in
stdenv.lib.extendDerivation true passthru drv
