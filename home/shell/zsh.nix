{ pkgs, ... }:
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
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    autosuggestion.enable = true;
    enableCompletion = true;
    defaultKeymap = "emacs";
    shellAliases = {
      cat = "bat";
      zh = "z $PWD";
    };
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
  };

  xdg.configFile = {
    "fsh".source = "${catppuccin-zsh-fsh}/share/zsh/site-functions/themes";
  };
}
