self: super: {
  linuxPackages_lx2k = super.linuxPackagesFor self.linux_lx2k;
  linux_lx2k = self.buildLinux {
    # nix-prefetch-github https://github.com/SolidRun/linux-stable linux-5.10.y-cex7
    src = super.fetchFromGitHub {
      owner = "SolidRun";
      repo = "linux-stable";
      rev = "4c71505dce5df9254daacb96c7a869741289a461";
      sha256 = "1mqv6xvijrafkjf03bwjvfrcvd4h4576zbv8jpipfjzcxg6894zf";
    };
    version = "5.10.23";
    kernelPatches = [ ];
    structuredExtraConfig = with super.lib.kernel; {
      CGROUP_FREEZER = yes;
    };
  };
  lx2k = self.lib.makeScope self.newScope (self: with self; {
    ddrSpeed = 2400;

    rcw = self.callPackage ./pkgs/rcw { };

    atf = self.callPackage ./pkgs/atf { };

    ddr-phy-bin = self.callPackage ./pkgs/ddr-phy-bin { };

    uefi = self.callPackage ./pkgs/uefi { };

    qoriq-mc-bin = self.callPackage ./pkgs/qoriq-mc-bin { };

    mc-utils = self.callPackage ./pkgs/mc-utils { };

    edk2 = callPackage ./pkgs/edk2 { };

    tianocore = callPackage ./pkgs/tianocore { };

    isoImage = self.callPackage ./pkgs/isoImage { };

  });

  lx2k-2400 = self.lx2k;
  lx2k-2600 = self.lx2k.overrideScope' (_: _: { ddrSpeed = 2600; });
  lx2k-2900 = self.lx2k.overrideScope' (_: _: { ddrSpeed = 2900; });
  lx2k-3200 = self.lx2k.overrideScope' (_: _: { ddrSpeed = 3200; });
}
