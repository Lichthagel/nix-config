{unstablePkgs, ...}: {
  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      enter_accept = true;
    };
    package = unstablePkgs.atuin;
  };
}
