{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
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
}
