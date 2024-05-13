{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    delta = {
      enable = true;
      catppuccin.enable = true;
    };
    extraConfig = {
      credential.helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      credential.credentialStore = "secretservice";

      init.defaultBranch = "main";

      core.fsmonitor = true;
    };
    aliases = {
      co = "checkout";
    };
  };

  home.packages = [ pkgs.git-crypt ];
}
