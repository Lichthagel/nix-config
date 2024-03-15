{
  osConfig,
  pkgs,
  ...
}: {
  programs.gpg = {
    enable = true;
    settings = {
      charset = "utf-8";
      use-agent = true;
      no-comments = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage =
      if osConfig.services.xserver.enable
      then pkgs.pinentry-qt
      else pkgs.pinentry-curses;
  };

  home.packages = with pkgs; [
    (
      if osConfig.services.xserver.enable
      then pinentry.qt
      else pinentry.curses
    )
  ];
}
