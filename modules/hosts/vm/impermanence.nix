{
  inputs,
  ...
}:
{
  flake.modules.nixos.vm = {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    fileSystems."/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "size=2G"
        "mode=755"
      ];
    };

    environment.persistence."/persist" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
      ];
      files = [
        "/etc/machine-id"
      ];
    };
  };
}
