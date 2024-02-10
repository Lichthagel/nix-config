{
  osConfig,
  lib,
  pkgs,
  flake-utils,
  ...
}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package =
      # I don't really use other systems, so I only override the x86_64-linux package.
      if pkgs.system == flake-utils.lib.system.x86_64-linux
      then
        ((pkgs.vscode.override
            (lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
              commandLineArgs = [
                "--enable-wayland-ime"
              ];
            }))
          .overrideAttrs rec {
            version = "1.86.1";

            src = pkgs.fetchurl {
              name = "VSCode_${version}_linux-x64.tar.gz";
              url = "https://update.code.visualstudio.com/${version}/linux-x64/stable";
              sha256 = "sha256-joPyv5uhSBRy7C9x5jUuIU7NnK3zhoj18TaGinv6zlk=";
            };
          })
        .fhs
      else pkgs.vscode.fhs;
  };

  home.packages = [
    pkgs.alejandra
    pkgs.rnix-lsp
    pkgs.nil
  ];

  home.sessionVariables = {
    EDITOR = "code";
    VISUAL = "code";
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
