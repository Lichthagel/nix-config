{
  pkgs,
  ctp,
  ...
}: {
  imports = [
    ./atuin.nix
    ./starship
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    fd
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };

    bat = {
      enable = true;
      themes = let
        ctpsrc = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
      in {
        "catppuccin-${ctp.flavor}" = {
          src = ctpsrc;
          file = "Catppuccin-${ctp.flavor}.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        prettybat
      ];
      config = {
        theme = "catppuccin-${ctp.flavor}";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
      enableAliases = true;
      icons = true;
    };

    fzf = {
      enable = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      colors = {
        "bg+" = "#363a4f";
        bg = "#24273a";
        spinner = "#f4dbd6";
        hl = "#ed8796";
        fg = "#cad3f5";
        header = "#ed8796";
        info = "#c6a0f6";
        pointer = "#f4dbd6";
        marker = "#f4dbd6";
        "fg+" = "#cad3f5";
        prompt = "#c6a0f6";
        "hl+" = "#ed8796";
      };
    };

    ripgrep = {
      enable = true;
    };

    skim = {
      enable = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = ["--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"];
    };

    tealdeer.enable = true;

    zoxide.enable = true;
  };
}
