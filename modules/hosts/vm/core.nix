{
  flake.modules.nixos.vm = {
    networking.hostName = "vm";

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "26.05";
  };
}
