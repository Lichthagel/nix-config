{
  options,
  osConfig,
  pkgs,
  ...
}:
{
  programs.gpg = {
    enable = true;
    settings = {
      charset = "utf-8";
      use-agent = true;
      no-comments = true;
    };
  };

  services.gpg-agent =
    {
      enable = true;
      enableSshSupport = true;
    }
    // (
      if options.services.gpg-agent ? pinentryPackage then
        {
          pinentryPackage =
            if osConfig.services.xserver.enable then pkgs.pinentry-qt else pkgs.pinentry-curses;
        }
      else
        { pinentryFlavor = if osConfig.services.xserver.enable then "qt" else "curses"; }
    );

  home.packages = with pkgs; [
    (if osConfig.services.xserver.enable then pinentry.qt else pinentry.curses)
  ];
}
