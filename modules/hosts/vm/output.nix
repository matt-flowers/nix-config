{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      self.modules.nixos.vm
    ];
  };
}
