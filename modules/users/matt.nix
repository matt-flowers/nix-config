let
  userName = "matt";
in
{
  flake.modules.nixos.vm = {
    users.users.${userName} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };

    environment.persistence."/persist".users.${userName} = {
      directories = [
        "Downloads"
      ];
    };
  };

  flake.modules.homeManager.${userName} = {
    home.username = userName;
    home.homeDirectory = "/home/${userName}";
    home.stateVersion = "26.05";
  };
}
