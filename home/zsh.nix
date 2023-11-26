{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    shellAliases = {
      cat = "bat";
      #hx = "helix";
    };
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "zsh-users/zsh-completions"
        "MichaelAquilina/zsh-you-should-use"
        "zdharma-continuum/fast-syntax-highlighting"
        "chrissicool/zsh-256color"
        "belak/zsh-utils path:editor"
        "ohmyzsh/ohmyzsh path:plugins/git-commit"
        "ohmyzsh/ohmyzsh path:plugins/gitfast"
        "ohmyzsh/ohmyzsh path:plugins/npm kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/nvm"
        "ohmyzsh/ohmyzsh path:plugins/pip kind:defer"
        "ohmyzsh/ohmyzsh path:plugins/pipenv"
        "ohmyzsh/ohmyzsh path:plugins/podman"
        "ohmyzsh/ohmyzsh path:plugins/pylint"
      ];
    };
  };
}
