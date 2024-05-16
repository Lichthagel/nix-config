{ options, pkgs, ... }:
let
  catppuccin-zsh-fsh = pkgs.stdenvNoCC.mkDerivation {
    name = "catppuccin-zsh-fsh";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "zsh-fsh";
      rev = "7cdab58bddafe0565f84f6eaf2d7dd109bd6fc18";
      sha256 = "sha256-31lh+LpXGe7BMZBhRWvvbOTkwjOM77FPNaGy6d26hIA=";
    };
    phases = [ "buildPhase" ];
    buildPhase = ''
      mkdir -p $out/share/zsh/site-functions/themes
      ls $src/themes
      cp $src/themes/* $out/share/zsh/site-functions/themes/
    '';
  };
  ohmyzsh-src = pkgs.fetchFromGitHub {
    owner = "ohmyzsh";
    repo = "ohmyzsh";
    rev = "12cd3b3e399d39b2b458fdd8f1f6286250253476";
    sha256 = "sha256-G8Hf+FocHEEjguk8C6Hf97PSDl6msWUOx+dzMjveYYI=";
  };
in
{
  programs.zsh =
    {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      defaultKeymap = "emacs";
      plugins = [
        {
          name = "zsh-you-should-use";
          src = pkgs.zsh-you-should-use;
          file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
        }
        {
          name = "zsh-nix-shell";
          src = pkgs.zsh-nix-shell;
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
        }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
        {
          name = "zsh-fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
        {
          name = "gitfast";
          src = ohmyzsh-src;
          file = "plugins/gitfast/gitfast.plugin.zsh";
        }
        {
          name = "podman";
          src = ohmyzsh-src;
          file = "plugins/podman/podman.plugin.zsh";
        }
      ];
      initExtra = ''
        # disable sort when completing `git checkout`
        zstyle ':completion:*:git-checkout:*' sort false
        # set descriptions format to enable group support
        # NOTE: don't use escape sequences here, fzf-tab will ignore them
        zstyle ':completion:*:descriptions' format '[%d]'
        # set list-colors to enable filename colorizing
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
        zstyle ':completion:*' menu no
        # preview directory's content with eza when completing cd or zoxide
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -1 --color=always $realpath'
        # switch group using `<` and `>`
        zstyle ':fzf-tab:*' switch-group '<' '>'
      '';
    }
    // (
      if (options.programs.zsh ? autosuggestion) then
        { autosuggestion.enable = true; }
      else
        { enableAutosuggestions = true; }
    );

  xdg.configFile = {
    "fsh".source = "${catppuccin-zsh-fsh}/share/zsh/site-functions/themes";
  };
}
