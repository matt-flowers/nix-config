{
  inputs,
  ...
}:
{
  flake.modules.nixos.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      config = {
        programs.niri.enable = true;

        services.greetd = {
          enable = true;
          settings.default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session";
            user = "greeter";
          };
        };

        services.upower.enable = true;
        services.power-profiles-daemon.enable = true;

        environment.systemPackages = [
          pkgs.noctalia-shell
        ];

        home-manager.sharedModules = [
          {
            imports = [
              inputs.self.modules.homeManager.niri
            ];
          }
        ];
      };
    };
}
