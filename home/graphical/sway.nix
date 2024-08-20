{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.wayland.windowManager.sway.licht;
in
{
  options.wayland.windowManager.sway.licht = {
    enable = lib.mkEnableOption "sway" // {
      default = osConfig.programs.sway.licht.enable;
    };

    perMonitorWorkspaces = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable per-monitor workspaces";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nwg-look
      sway-contrib.grimshot
    ];

    programs.swaylock.enable = true;

    licht.autostart.systemd = lib.mkDefault true;

    systemd.user.targets.sway-session.Unit.Wants = lib.mkIf config.licht.autostart.systemd [
      "autostart.target"
    ];

    wayland.windowManager.sway = {
      enable = true;
      catppuccin.enable = true;
      systemd = {
        enable = true;
        xdgAutostart = true;
      };
      xwayland = true;
      wrapperFeatures = {
        gtk = true;
      };

      config = {
        startup = lib.mkMerge [
          [
            { command = "${pkgs.kdePackages.kwallet}/bin/kwalletd6"; }
            { command = "${pkgs.networkmanagerapplet}/bin/nm-applet"; }
          ]
          (lib.mkIf cfg.perMonitorWorkspaces [ { command = "${lib.getExe pkgs.swaysome} init 1"; } ])
        ];
        menu = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";
        terminal = "${config.programs.wezterm.package}/bin/wezterm";
        input = {
          "type:keyboard" = {
            xkb_layout = "de";
            xkb_variant = "neo_qwertz";
          };
          "type:touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
          };
        };
        modifier = "Mod4";
        keybindings =
          let
            modifier = config.wayland.windowManager.sway.config.modifier;
            swaysome = lib.getExe pkgs.swaysome;
          in
          lib.mkMerge [
            (lib.mkIf cfg.perMonitorWorkspaces (
              lib.mkOptionDefault {
                "${modifier}+1" = "exec ${swaysome} focus 1";
                "${modifier}+2" = "exec ${swaysome} focus 2";
                "${modifier}+3" = "exec ${swaysome} focus 3";
                "${modifier}+4" = "exec ${swaysome} focus 4";
                "${modifier}+5" = "exec ${swaysome} focus 5";
                "${modifier}+6" = "exec ${swaysome} focus 6";
                "${modifier}+7" = "exec ${swaysome} focus 7";
                "${modifier}+8" = "exec ${swaysome} focus 8";
                "${modifier}+9" = "exec ${swaysome} focus 9";
                "${modifier}+0" = "exec ${swaysome} focus 0";

                "${modifier}+Shift+1" = "exec ${swaysome} move 1";
                "${modifier}+Shift+2" = "exec ${swaysome} move 2";
                "${modifier}+Shift+3" = "exec ${swaysome} move 3";
                "${modifier}+Shift+4" = "exec ${swaysome} move 4";
                "${modifier}+Shift+5" = "exec ${swaysome} move 5";
                "${modifier}+Shift+6" = "exec ${swaysome} move 6";
                "${modifier}+Shift+7" = "exec ${swaysome} move 7";
                "${modifier}+Shift+8" = "exec ${swaysome} move 8";
                "${modifier}+Shift+9" = "exec ${swaysome} move 9";
                "${modifier}+Shift+0" = "exec ${swaysome} move 0";

                "${modifier}+Alt+1" = "exec ${swaysome} focus-group 1";
                "${modifier}+Alt+2" = "exec ${swaysome} focus-group 2";
                "${modifier}+Alt+3" = "exec ${swaysome} focus-group 3";
                "${modifier}+Alt+4" = "exec ${swaysome} focus-group 4";
                "${modifier}+Alt+5" = "exec ${swaysome} focus-group 5";
                "${modifier}+Alt+6" = "exec ${swaysome} focus-group 6";
                "${modifier}+Alt+7" = "exec ${swaysome} focus-group 7";
                "${modifier}+Alt+8" = "exec ${swaysome} focus-group 8";
                "${modifier}+Alt+9" = "exec ${swaysome} focus-group 9";
                "${modifier}+Alt+0" = "exec ${swaysome} focus-group 0";

                "${modifier}+Alt+Shift+1" = "exec ${swaysome} move-to-group 1";
                "${modifier}+Alt+Shift+2" = "exec ${swaysome} move-to-group 2";
                "${modifier}+Alt+Shift+3" = "exec ${swaysome} move-to-group 3";
                "${modifier}+Alt+Shift+4" = "exec ${swaysome} move-to-group 4";
                "${modifier}+Alt+Shift+5" = "exec ${swaysome} move-to-group 5";
                "${modifier}+Alt+Shift+6" = "exec ${swaysome} move-to-group 6";
                "${modifier}+Alt+Shift+7" = "exec ${swaysome} move-to-group 7";
                "${modifier}+Alt+Shift+8" = "exec ${swaysome} move-to-group 8";
                "${modifier}+Alt+Shift+9" = "exec ${swaysome} move-to-group 9";
                "${modifier}+Alt+Shift+0" = "exec ${swaysome} move-to-group 0";

                "${modifier}+o" = "exec ${swaysome} next-output";
                "${modifier}+Shift+o" = "exec ${swaysome} prev-output";
                "${modifier}+Alt+o" = "exec ${swaysome} workspace-group-next-output";
                "${modifier}+Alt+Shift+o" = "exec ${swaysome} workspace-group-prev-output";
              }
            ))
            (lib.mkOptionDefault {
              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
              "XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";
              "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
              "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
              "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
              "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";

              "Print" =
                let
                  screenshot = pkgs.writeShellScript "screenshot" ''
                    filename=$(date +"%Y-%m-%d_%H-%M-%S").png
                    folder=~/Pictures/Screenshots/$(date +"%Y-%m")
                    mkdir -p $folder
                    file=$folder/$filename

                    ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save anything $file
                  '';
                in
                "exec ${screenshot}";
              "Shift+Print" =
                let
                  screenshot = pkgs.writeShellScript "screenshot" ''
                    filename=$(date +"%Y-%m-%d_%H-%M-%S").png
                    folder=~/Pictures/Screenshots/$(date +"%Y-%m")
                    mkdir -p $folder
                    file=$folder/$filename

                    ${pkgs.grim}/bin/grim -g "2360,0 2560x1440" $file
                  '';
                in
                "exec ${screenshot}";
            })
          ];
        bars = [ ];
        gaps = {
          inner = 5;
          outer = 5;
        };
        output = {
          "*" = {
            "bg" = "${config.licht.wallpaper} fill";
          };
        };
        colors = {
          focused = {
            border = "\$${config.catppuccin.accent}";
            background = "$mantle";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "\$${config.catppuccin.accent}";
          };
          focusedInactive = {
            border = "$base";
            background = "$mantle";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$base";
          };
          unfocused = {
            border = "$base";
            background = "$mantle";
            text = "$text";
            indicator = "$rosewater";
            childBorder = "$base";
          };
          urgent = {
            border = "$maroon";
            background = "$mantle";
            text = "$text";
            indicator = "$overlay0";
            childBorder = "$maroon";
          };
          placeholder = {
            border = "$overlay0";
            background = "$mantle";
            text = "$text";
            indicator = "$overlay0";
            childBorder = "$overlay0";
          };
          background = "$base";
        };
        fonts = {
          names = [
            "Noto Sans"
            "Noto Sans CJK JP"
            "Symbols Nerd Font"
          ];
          size = 8.0;
        };
        window.commands = [
          {
            criteria = {
              app_id = "firefox";
              title = "Bild-im-Bild|Picture-in-Picture";
            };
            command = "floating enable, sticky enable";
          }
          {
            criteria.app_id = "org.keepassxc.KeePassXC";
            command = "floating enable";
          }
        ];
      };
    };
  };
}
