{
  config,
  osConfig,
  lib,
  pkgs,
  unstablePkgs,
  ...
}:
let
  cfg = config.licht.editors.vscode;
in
{
  options.licht.editors.vscode = {
    enable = lib.mkEnableOption "my vscode configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = true;
      package =
        # I don't really use other systems, so I only override the x86_64-linux package atm.
        if pkgs.system == "x86_64-linux" then
          (
            (pkgs.vscode.override (
              lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
                # TODO breaks code cli
                # commandLineArgs = "--enable-wayland-ime";
              }
            )).overrideAttrs
            rec {
              version = "1.89.0";

              src = pkgs.fetchurl {
                name = "VSCode_${version}_linux-x64.tar.gz";
                url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
                sha256 = "sha256-vGDY57xMuEJrmJBwQ0ufnAKt1GR16jEDKt5/fva9wUM=";
              };
            }
          ).fhs
        else
          pkgs.vscode.fhs;
    };

    # TODO move somewhere else
    home.packages = [
      unstablePkgs.nixfmt-rfc-style
      pkgs.nil
      pkgs.nixd
    ];

    licht.unfreePackages = map lib.getName [
      "code"
      config.programs.vscode.package
    ];
  };
}
