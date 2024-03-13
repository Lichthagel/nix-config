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
    du-dust
    glow
    skate
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
          rev = "e5c2f64eab91deb1750233cd64356b26cb985a21";
          sha256 = "sha256-zWRk6HaQl+2M9LuFTjz56jGzHQ8nuG7w1JXYe3cLxH4=";
        };
      in {
        "Catppuccin ${ctp.flavorCapitalized}" = {
          src = ctpsrc;
          file = "themes/Catppuccin ${ctp.flavorCapitalized}.tmTheme";
        };
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        prettybat
      ];
      config = {
        theme = "Catppuccin ${ctp.flavorCapitalized}";
      };
    };

    btop = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    eza = {
      enable = true;
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

    zellij = {
      enable = true;
      settings = {
        theme = "catppuccin-${ctp.flavor}";
        copy_command = "wl-copy";
        pane_frames = false;
        ui.pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };
      };
    };

    zoxide.enable = true;
  };

  xdg.configFile = let
    catppuccin-btop = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "btop";
      rev = "1.0.0";
      sha256 = "sha256-J3UezOQMDdxpflGax0rGBF/XMiKqdqZXuX4KMVGTxFk=";
    };
  in {
    "btop/themes/catppuccin_${ctp.flavor}.theme".source = "${catppuccin-btop}/themes/catppuccin_${ctp.flavor}.theme";
  };
}
