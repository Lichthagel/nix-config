{
  osConfig,
  lib,
  pkgs,
  unstablePkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package =
      # I don't really use other systems, so I only override the x86_64-linux package.
      if pkgs.system == "x86_64-linux" then
        (
          (pkgs.vscode.override (
            lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
              commandLineArgs = [ "--enable-wayland-ime" ];
            }
          )).overrideAttrs
          rec {
            version = "1.88.0";

            src = pkgs.fetchurl {
              name = "VSCode_${version}_linux-x64.tar.gz";
              url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
              sha256 = "sha256-rq8WUApP3LDbhV9gvovK20o2QbZikHwhnDf7JdcdKE8=";
            };
          }
        ).fhs
      else
        pkgs.vscode.fhs;
  };

  home.packages = [
    unstablePkgs.nixfmt-rfc-style
    pkgs.nil
  ];

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
