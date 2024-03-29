{
  osConfig,
  lib,
  pkgs,
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
            version = "1.87.2";

            src = pkgs.fetchurl {
              name = "VSCode_${version}_linux-x64.tar.gz";
              url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
              sha256 = "sha256-wul83GP/G8v7sQwie1OYYj0h8h5IcQj6HXQNq+fTeYU=";
            };
          }
        ).fhs
      else
        pkgs.vscode.fhs;
  };

  home.packages = [
    pkgs.nixfmt-rfc-style
    pkgs.nil
  ];

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
