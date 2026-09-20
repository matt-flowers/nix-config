{
  inputs,
  ...
}:
{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.self.modules.nixos.audio
        inputs.self.modules.nixos.bluetooth
        inputs.self.modules.nixos.niri
        inputs.self.modules.nixos.kde-connect
        inputs.self.modules.nixos.printing
        inputs.self.modules.nixos.virtualisation
      ];
      
      config = {
        services.flatpak.enable = true;
        bootloader.pretty = lib.mkDefault true;
        audio.enable = lib.mkDefault true;
        bluetooth.enable = lib.mkDefault true;
        kde-connect.enable = lib.mkDefault true;
        printing.enable = lib.mkDefault true;
        virtualisation.enable = lib.mkDefault true;

        home-manager.sharedModules = [
          {
            imports = [
              inputs.nix-flatpak.homeManagerModules.nix-flatpak
            ];
          }
        ];
      };
    };
}
