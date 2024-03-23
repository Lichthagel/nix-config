{
  osConfig,
  lib,
  pkgs,
  ctp,
  inputs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "licht";
  home.homeDirectory = "/home/licht";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    nix-tree
    keepassxc
    yubioath-flutter
    tutanota-desktop
    (obsidian.overrideAttrs (
      oldAttrs:
      lib.optionalAttrs (osConfig.i18n.inputMethod.enabled == "fcitx5") {
        installPhase =
          builtins.replaceStrings
            [ ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}"'' ]
            [
              ''--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}}" --add-flags --enable-wayland-ime''
            ]
            oldAttrs.installPhase;
      }
    ))
    thunderbird
    zoom-us

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/jens/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    helix = {
      enable = true;
      settings = {
        theme = "catppuccin_${ctp.flavor}";
        editor = {
          line-number = "relative";
          cursorline = true;
          color-modes = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
        };
      };
    };
  };

  services.syncthing.enable = true;

  services.pueue = {
    enable = true;
    settings = {
      daemon = {
        default_parallel_tasks = 4;
      };
    };
  };

  xdg.enable = osConfig.services.xserver.enable;

  catppuccin = {
    accent = ctp.accent;
    flavour = ctp.flavor;
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ./wezterm
    ./vscode.nix
    ./neovim.nix
    ./gh.nix
    ./shell
    ./discord.nix
    ./kde.nix
    ./firefox.nix
    # ./gtk.nix
    ./git.nix
    ./fonts.nix
    ./spotify.nix
    ./gpg.nix
    ./mpv
    ./ssh.nix
  ];
}
