{
  inputs,
  ...
}:
{
  flake.modules.nixos.localisation =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      options = {
        localisation.enable = lib.mkEnableOption "localisation settings for Chicago";
      };

      config = lib.mkIf config.localisation.enable {
        time.timeZone = lib.mkDefault "America/Chicago";
        i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
        console.keyMap = lib.mkDefault "us";
      };
    };
}
