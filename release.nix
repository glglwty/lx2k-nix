{ system ? "aarch64-linux" # cross-compilation doesn't work currently
, pkgs ? import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
      (self: super: {
        lx2k = super.lx2k.overrideScope' (self: super: {
          rcw = super.rcw.override { inherit ddrSpeed; };
        });
      })
    ];
    inherit system;
    ${if system == "aarch64-linux" then null else "crossSystem"} = "aarch64-linux";
  },
  ddrSpeed ? 3200
}:

{
  inherit (pkgs) linux_lx2k lx2k;

  isoImage = (pkgs.nixos ( { lib, ... }: {
    imports = [ (pkgs.path + /nixos/modules/installer/cd-dvd/installation-cd-minimal.nix) ];

    # use vendor kernel
    boot.kernelPackages = pkgs.linuxPackages_lx2k_mainline;

    # disable anything we don't need, like zfs
    boot.initrd.supportedFilesystems = lib.mkForce [ "ext4" ];
    boot.supportedFilesystems = lib.mkForce [ "ext4" ];

    # take from upstream
    boot.kernelParams = lib.mkForce [
      "console=ttyAMA0,115200" "earlycon=pl011,mmio32,0x21c0000" "pci=pcie_bus_perf"
      "arm-smmu.disable_bypass=0" # TODO: remove once firmware supports it
    ];
  })).config.system.build.isoImage;
}
