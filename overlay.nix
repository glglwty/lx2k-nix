self: super: {
  linux_lx2k = super.callPackage ./linux_lx2k {
    kernelPatches = self.linux_4_19.kernelPatches ++ (
      map (p: {
        name = builtins.baseNameOf p;
        patch = p;
      }) [
        ./patches/linux/0001-arm64-dts-lx2160a-add-lx2160acex7-device-tree-build.patch
        ./patches/linux/0002-arm64-dts-lx2160a-add-lx2160acex7-device-tree.patch
        ./patches/linux/0004-pci-accept-pcie-base-class-id-0x0.patch
        ./patches/linux/0005-arm64-dts-lx2160a-cex7-add-ltc3882-support.patch
        ./patches/linux/0006-arm64-dts-lx2160a-cex7-add-on-module-eeproms.patch
      ]
    );
  };

  linuxPackages_lx2k = self.linuxPackagesFor self.linux_lx2k;

  linuxPackages_lx2k_mainline = super.linuxPackagesFor self.linux_lx2k_mainline;
  linux_lx2k_mainline = self.buildLinux {
    src = super.fetchFromGitHub {
      owner = "SolidRun";
      repo = "linux-stable";
      rev = "bc1160fd43de6bc9a09e25c027a057e1376e5b9a";
      sha256 = "1cq36vpsd68g144gn7f3jjkl2bwibqv7nrrrjgvkdj1lfijcwm14";
    };
    version = "5.10.5";
    kernelPatches = [];
  };

  lx2k = self.lib.makeScope self.newScope (self: with self; {
    uboot = self.callPackage ./u-boot { };

    rcw = self.callPackage ./rcw { };

    atf = self.callPackage ./atf { };

    ddr-phy-bin = self.callPackage ./ddr-phy-bin { };

    qoriq-mc-bin = self.callPackage ./qoriq-mc-bin { };

    mc-utils = self.callPackage ./mc-utils { };
  });

  ubootImage = self.lx2k.callPackage ./ubootImage.nix { };
}
