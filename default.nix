{ system ? "aarch64-linux"
, pkgs ? import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
    ];
    inherit system;
    ${if system == "aarch64-linux" then null else "crossSystem"} = "aarch64-linux";
  }
}:

{
  inherit (pkgs) linux_lx2k linuxPackages_lx2k lx2k lx2k-2400 lx2k-2600 lx2k-2900 lx2k-3200;
}
