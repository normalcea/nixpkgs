{
  lib,
  pkgs,
  config,
  options,
  ...
}:
let
  cfg = config.programs.bazaar;
  opt = options.programs.bazaar;
in
{
  options.programs.bazaar = {
    enable = lib.mkEnableOption "Bazaar, a Flathub app store";
    package = lib.options.mkPackageOption pkgs "bazaar" { };
    curationSettings = lib.mkOption {
      type = lib.types.externalPath;
      default = "";
      description = ''
        Path to the YAML-based configuration file for the content
        curation section in Bazaar.
      '';
    };
    blockList = lib.mkOption {
      type = lib.types.externalPath;
      default = "";
      description = ''
        Path to the YAML-based blocklist file for content blocking in
        Bazaar.
      '';
    };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      visible = false;
      readOnly = true;
      description = "Resulting customized Bazaar package with paths applied.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ opt.finalPackage ];
    systemd.packages = [ opt.finalPackage ];

    programs.bazaar.finalPackage = pkgs.bazaar.override {
      contentConfigPath = cfg.curationSettings;
      blocklistPath = cfg.blockList;
    };
  };

  meta.maintainers = with lib.maintainers; [ normalcea ];
}
