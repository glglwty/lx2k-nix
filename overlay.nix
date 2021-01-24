self: super: {
  linux_lx2k = super.callPackage ./pkgs/linux_lx2k {};
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
    kernelPatches = [ ];
    structuredExtraConfig = with super.lib.kernel; {
      CGROUP_FREEZER = yes;
    };
  };
  lx2k = self.lib.makeScope self.newScope (self: with self; {
    rcw = self.callPackage ./pkgs/rcw { };

    atf = self.callPackage ./pkgs/atf { };

    ddr-phy-bin = self.callPackage ./pkgs/ddr-phy-bin { };

    qoriq-mc-bin = self.callPackage ./pkgs/qoriq-mc-bin { };

    mc-utils = self.callPackage ./pkgs/mc-utils { };

    edk2 = callPackage ./pkgs/edk2 { };
    tianocore = callPackage ./pkgs/tianocore { };

    uefi = callPackage ./pkgs/uefi { };
    isoImage = self.callPackage ./pkgs/isoImage { };
  });
  ubootImage = self.lx2k.callPackage ./pkgs/ubootImage { };
}
