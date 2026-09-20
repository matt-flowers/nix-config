{
  inputs,
  ...
}:
{
  flake.overlays.unstable-packages = final: prev: {
    unstable = import inputs.nixpkgs-unstalble {
      inherit (final) system;
      config.allowUnfree = final.config.allowUnfree;
    };
  };

  flake.overlays.additional-packages = final: prev: {
    #
  };

  perSystem =
    {
      self',
      system,
      pkgs,
      ...
    }:
    {
      packages = {
        nixos-options-doc =
          let
            eval = inputs.nixpkgs.lib.evalModules {
              modules = [
                { _module.check = false; }
                inputs.self.modules.nixos.core
                inputs.self.modules.nixos.desktop
              ];
            };
            cleanEval = inputs.nixpkgs.lib.filterAttrsRecursive (n: v: n != "_module") eval;
            optionsDoc = pkgs.nixosOptionsDoc { inherit (cleanEval) options; };
          in
          pkgs.runCommand "OPTIONS.md" { } ''
            cp ${optionsDoc.optionsCommonMark} $out
          '';

        home-manager-options-doc =
          let
            eval = inputs.nixpkgs.lib.evalModules {
              modules = [
                { _module.check = false; }
                inputs.self.modules.homeManager.secrets
                #
              ];
            };
            cleanEval = inputs.nixpkgs.lib.filterAttrsRecursive (n: v: n != "_module") eval;
            optionsDoc = pkgs.nixosOptionsDoc { inherit (cleanEval) options; };
          in
          pkgs.runCommand "OPTIONS.md" { } ''
            cp ${optionsDoc.optionsCommonMark} $out
          '';
      };
    };
}
