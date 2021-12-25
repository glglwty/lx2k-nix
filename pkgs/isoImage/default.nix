{ nixos, lib, path, linuxPackages_lx2k }:

{
  isoImage = (nixos ({ lib, ... }: {
    imports = [ (path + /nixos/modules/installer/cd-dvd/installation-cd-minimal.nix) ];

    # use vendor kernel
    boot.kernelPackages = linuxPackages_lx2k;

    # disable anything we don't need, like zfs
    #boot.initrd.supportedFilesystems = lib.mkForce [ "ext4" ];
    #boot.supportedFilesystems = lib.mkForce [ "ext4" ];
    boot.supportedFilesystems = [ "zfs" ];
    boot.initrd.supportedFilesystems = ["zfs"]; # boot from zfs

    # take from upstream
    boot.kernelParams = [
      "console=ttyAMA0,115200"
      "earlycon=pl011,mmio32,0x21c0000"
      "pci=pcie_bus_perf"
      "arm-smmu.disable_bypass=0" # TODO: remove once firmware supports it
    ];
  })).config.system.build.isoImage;
}
