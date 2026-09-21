{
  inputs,
  self,
  ...
}:
{
  flake.modules.nixos.vm = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserHomeDirectory = true;
    home-manager.users.matt = self.modules.homeManager.matt;
  };
}
