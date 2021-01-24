{ system ? "aarch64-linux"
, pkgs ? import <nixpkgs> {
    overlays = [
      (import ./overlay.nix)
    ];
    inherit system;
    ${if system == "aarch64-linux" then null else "crossSystem"} = "aarch64-linux";
  },
  ddrSpeed ? 3200
}:

{
  inherit (pkgs) linux_lx2k lx2k;
}

