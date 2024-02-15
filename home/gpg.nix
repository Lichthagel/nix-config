{...}: {
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
  };
}
