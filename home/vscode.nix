{
  lib,
  pkgs,
  nix-vscode-extensions,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace; [
      github.copilot
      jnoortheen.nix-ide
      kamadorueda.alejandra
    ];
    mutableExtensionsDir = true;
  };

  home.packages = [
    pkgs.alejandra
    pkgs.rnix-lsp
  ];

  home.sessionVariables = {
    EDITOR = "code";
    VISUAL = "code";
  };

  xdg.mimeApps.defaultApplications."text/plain" = "code.desktop";
}
