self: super: {
  linux_lx2k = super.callPackage ./pkgs/linux_lx2k { };
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
    # A different UEFI must be prepared depending on the RAM speed.
    rcw = {
      ddr-2400 = self.callPackage ./pkgs/rcw { ddrSpeed = 2400; };
      ddr-2600 = self.callPackage ./pkgs/rcw { ddrSpeed = 2600; };
      ddr-2900 = self.callPackage ./pkgs/rcw { ddrSpeed = 2900; };
      ddr-3200 = self.callPackage ./pkgs/rcw { ddrSpeed = 3200; };
    };

    atf = {
      ddr-2400 = self.callPackage ./pkgs/atf { rcw = rcw.ddr-2400; };
      ddr-2600 = self.callPackage ./pkgs/atf { rcw = rcw.ddr-2600; };
      ddr-2900 = self.callPackage ./pkgs/atf { rcw = rcw.ddr-2900; };
      ddr-3200 = self.callPackage ./pkgs/atf { rcw = rcw.ddr-3200; };
    };

    ddr-phy-bin = {
      ddr-2400 = self.callPackage ./pkgs/ddr-phy-bin { atf = atf.ddr-2400; };
      ddr-2600 = self.callPackage ./pkgs/ddr-phy-bin { atf = atf.ddr-2600; };
      ddr-2900 = self.callPackage ./pkgs/ddr-phy-bin { atf = atf.ddr-2900; };
      ddr-3200 = self.callPackage ./pkgs/ddr-phy-bin { atf = atf.ddr-3200; };
    };

    uefi = {
      ddr-2400 = self.callPackage ./pkgs/uefi { atf = atf.ddr-2400; ddr-phy-bin = ddr-phy-bin.ddr-2400; };
      ddr-2600 = self.callPackage ./pkgs/uefi { atf = atf.ddr-2600; ddr-phy-bin = ddr-phy-bin.ddr-2600; };
      ddr-2900 = self.callPackage ./pkgs/uefi { atf = atf.ddr-2900; ddr-phy-bin = ddr-phy-bin.ddr-2900; };
      ddr-3200 = self.callPackage ./pkgs/uefi { atf = atf.ddr-3200; ddr-phy-bin = ddr-phy-bin.ddr-3200; };
    };


    qoriq-mc-bin = self.callPackage ./pkgs/qoriq-mc-bin { };

    mc-utils = self.callPackage ./pkgs/mc-utils { };

    edk2 = callPackage ./pkgs/edk2 { };

    tianocore = callPackage ./pkgs/tianocore { };

    isoImage = self.callPackage ./pkgs/isoImage { };
  });
}
