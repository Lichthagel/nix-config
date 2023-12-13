{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package =
      (pkgs.vscode.overrideAttrs rec {
        version = "1.85.1";

        src = pkgs.fetchurl (
          let
            plat =
              {
                x86_64-linux = "linux-x64";
                x86_64-darwin = "darwin";
                aarch64-linux = "linux-arm64";
                aarch64-darwin = "darwin-arm64";
                armv7l-linux = "linux-armhf";
              }
              .${pkgs.system}
              or pkgs.throwSystem;

            archive_fmt =
              if pkgs.stdenv.isDarwin
              then "zip"
              else "tar.gz";
          in {
            name = "VSCode_${version}_${plat}.${archive_fmt}";
            url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
            sha256 = "sha256-AWadaeVnpSkDNrHS97Lw8YFunXCZAEuBom+PQO4Xyfw=";
          }
        );
      })
      .fhs;
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
