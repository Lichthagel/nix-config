{ unstablePkgs, ... }:
{
  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      enter_accept = true;
      history_filter = [
        "^/etc/profiles" # Programs calling programs by full path. E.g. GitLens calling git.
        "TOKEN="
        "token="
        "SECRET="
        "secret="
      ];
    };
    package = unstablePkgs.atuin;
  };
}
