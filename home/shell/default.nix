{ pkgs, ctp, ... }:
{
  imports = [
    ./atuin.nix
    ./starship
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    fd
    du-dust
    skate
    trashy
    croc
  ];

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
    };

    bat = {
      enable = true;
      catppuccin.enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        prettybat
      ];
    };

    btop = {
      enable = true;
      catppuccin.enable = true;
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
      catppuccin.enable = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
    };

    ripgrep = {
      enable = true;
    };

    skim = {
      enable = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      defaultOptions = [
        "--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"
      ];
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
}
