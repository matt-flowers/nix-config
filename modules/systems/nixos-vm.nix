{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos.nixos-vm = lib.mkMerge [
    (self.factory.desktop-user {
      username = "matt";
      isAdmin = true;
    })
    {
      home-manager.users.matt = {
        programs.git.settings.user = {
          name = "matt";
          email = "00250945+matt-flowers@users.noreply.github.com";
        };
      };
    }
  ];

  flake.nixosConfigurations.nixos-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.settings
      inputs.self.modules.nixos.vm
      inputs.self.modules.nixos.core
      inputs.self.modules.nixos.desktop
      inputs.self.modules.nixos.nixos-vm
      {
        networking.hostName = "nixos-vm";
        impermanence.enable = true;
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/var/lib/libvirt"
            "/etc/NetworkManager/system-connections"
            "/etc/nixos"
            "/root/.ssh"
          ];
        };
      }
    ];
  };
}
