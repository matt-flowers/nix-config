{
  self,
  inputs,
  ...
}:
{
  config.flake.factory.desktop-user =
    {
      username,
      isAdmin,
    }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          users.users."${username}" = {
            initialPassword = lib.mkDefault "password";
            isNormalUser = true;
            home = "/home/${username}";
            extraGroups = [
              "networkmanager"
              "docker"
              "libvirtd"
            ]
            ++ lib.optionals isAdmin [
              "wheel"
            ];
          };

          home-manager.users."${username}" = {
            imports = [
              #
            ];
          };
        }

        (lib.mkIf (config.secrets.enable && config.secrets.passwords.enable) {
          sops.secrets."passwords/${username}".neededForUsers = true;
          users.users.${username} = {
            initialPassword = null;
            hashedPasswordFile = config.sops.secrets."passwords/${username}".path;
          };
        })

        (lib.mkIf config.impermanence.enable {
          environment.persistence."/persist".users.${username} = {
            directories = [
              "Desktop"
              "Documents"
              "Downloads"
              "Music"
              "Pictures"
              "Videos"
              "nix-config"
              {
                directory = ".ssh";
                mode = "0700";
              }
              {
                directory = ".local/share/keyrings";
                mode = "0700";
              }
              ".local/share/flatpak"
              ".config"
              ".var"
              ".vscode-oss/extensions"
            ];
            files = [
              ".bash_history"
            ];
          };
        })
      ];
    };
}
