{
  config,
  osConfig,
  lib,
  pkgs,
  inputs',
  ...
}:
let
  cfg = config.licht.graphical.hyprland;
in
{
  options.licht.graphical.hyprland = {
    enable = lib.mkEnableOption "my Hyprland configuration" // {
      default = osConfig.licht.graphical.hyprland.enable;
    };

    perMonitorWorkspaces = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable per-monitor workspaces";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ nwg-look ];

    services.playerctld.enable = true;

    licht.autostart.systemd = lib.mkDefault true;

    systemd.user.targets.hyprland-session.Unit.Wants = lib.mkIf config.licht.autostart.systemd [
      "autostart.target"
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = osConfig.programs.hyprland.package;

      catppuccin.enable = true;

      plugins = lib.optional cfg.perMonitorWorkspaces (
        inputs'.split-monitor-workspaces.packages.split-monitor-workspaces.overrideAttrs (_: {
          buildInputs =
            with pkgs;
            let
              hyprland = config.wayland.windowManager.hyprland.package;
            in
            [
              hyprland.dev
              pango
              cairo
            ]
            ++ hyprland.buildInputs;
        })
      );

      settings = {
        autogenerated = false;

        # See https://wiki.hyprland.org/Configuring/Monitors/
        monitor = lib.mkDefault (builtins.throw "monitor is required");

        # Execute your favorite apps at launch
        exec-once = [
          "${pkgs.kdePackages.kwallet}/bin/kwalletd6"
          "${pkgs.networkmanagerapplet}/bin/nm-applet"
          "hyprctl setcursor ${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}"
        ] ++ (lib.optional config.services.mako.enable "${config.services.mako.package}/bin/mako");

        # Set programs that you use
        "$terminal" = "${pkgs.foot}/bin/foot";
        "$fileManager" = "${pkgs.kdePackages.dolphin}/bin/dolphin";
        "$menu" = "${pkgs.tofi}/bin/tofi-drun --drun-launch=true";

        # Set default env vars.
        env = [
          "XCURSOR_SIZE,24"
          "QT_QPA_PLATFORMTHEME,qt6ct"
        ];

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input = {
          kb_layout = "de";
          kb_variant = "neo_qwertz";
          # kb_model = "";
          # kb_options = "";
          # kb_rules = "";

          follow_mouse = true;

          touchpad.natural_scroll = true;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          gaps_in = 2;
          gaps_out = 2;
          border_size = 2;
          "col.active_border" = "rgba($pinkAlphaee) rgba($tealAlphaee) 45deg";
          "col.inactive_border" = "rgba($crustAlphaaa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
          rounding = 5;

          blur = {
            enabled = true;
            size = 10;
            passes = 2;
          };

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "rgba(1a1a1aee)";
        };

        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = [ "easeInOutCirc, 0.85, 0, 0.15, 1" ];

          animation = [
            "windows, 1, 7, easeInOutCirc"
            "windowsOut, 1, 7, easeInOutCirc, popin 80%"
            "border, 1, 3, easeInOutCirc"
            "borderangle, 1, 8, easeInOutCirc"
            "fade, 1, 7, easeInOutCirc"
            "workspaces, 1, 6, default"
            "specialWorkspace, 1, 3, easeInOutCirc, slidefadevert"
          ];
        };

        dwindle = {
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
          new_is_master = true;
        };

        gestures = {
          workspace_swipe = true;
        };

        misc = {
          force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
        };

        windowrulev2 =
          [
            "suppressevent maximize,class:.*" # You'll probably like this.
            "float,class:^org\.keepassxc\.KeePassXC$"
            "opacity 0.9,workspace:special:magic"
          ]
          ++ (
            let
              rules = lib.cartesianProduct {
                rule = [
                  "float"
                  "keepaspectratio"
                  "pin"
                ];
                window = [
                  "class:^firefox$,title:Bild-im-Bild"
                  "class:^firefox$,title:Picture-in-Picture"
                ];
              };
            in
            lib.forEach rules ({ rule, window }: "${rule}, ${window}")
          )
          ++ (
            let
              matchers = [ "class:^(org.wezfurlong.wezterm)$" ];
            in
            lib.concatLists (
              lib.forEach matchers (matcher: [
                "opacity 0.85,focus:0,${matcher}"
                "opacity 0.9,focus:1,${matcher}"
              ])
            )
          );

        layerrule = [
          "blur,waybar"
          "blur,launcher"
        ];

        "$mainMod" = "SUPER";

        bind =
          [
            "$mainMod, Q, exec, $terminal"
            "$mainMod, C, killactive,"
            "$mainMod, M, exit,"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, F, exec, firefox"
            "$mainMod, V, togglefloating,"
            "$mainMod, R, exec, $menu"
            "$mainMod, P, pseudo," # dwindle
            "$mainMod, J, togglesplit," # dwindle

            # Move focus with mainMod + arrow keys
            "$mainMod, left, movefocus, l"
            "$mainMod, right, movefocus, r"
            "$mainMod, up, movefocus, u"
            "$mainMod, down, movefocus, d"
          ]
          ++ (
            let
              cmd = if cfg.perMonitorWorkspaces then "split-workspace" else "workspace";
            in
            [
              # Switch workspaces with mainMod + [0-9]
              "$mainMod, 1, ${cmd}, 1"
              "$mainMod, 2, ${cmd}, 2"
              "$mainMod, 3, ${cmd}, 3"
              "$mainMod, 4, ${cmd}, 4"
              "$mainMod, 5, ${cmd}, 5"
              "$mainMod, 6, ${cmd}, 6"
              "$mainMod, 7, ${cmd}, 7"
              "$mainMod, 8, ${cmd}, 8"
              "$mainMod, 9, ${cmd}, 9"
              "$mainMod, 0, ${cmd}, 10"

              # Scroll through existing workspaces with mainMod + scroll
              "$mainMod, mouse_down, ${cmd}, e+1"
              "$mainMod, mouse_up, ${cmd}, e-1"
            ]
          )
          ++ (
            let
              cmd = if cfg.perMonitorWorkspaces then "split-movetoworkspace" else "movetoworkspace";
            in
            [
              # Move active window to a workspace with mainMod + SHIFT + [0-9]
              "$mainMod SHIFT, 1, ${cmd}, 1"
              "$mainMod SHIFT, 2, ${cmd}, 2"
              "$mainMod SHIFT, 3, ${cmd}, 3"
              "$mainMod SHIFT, 4, ${cmd}, 4"
              "$mainMod SHIFT, 5, ${cmd}, 5"
              "$mainMod SHIFT, 6, ${cmd}, 6"
              "$mainMod SHIFT, 7, ${cmd}, 7"
              "$mainMod SHIFT, 8, ${cmd}, 8"
              "$mainMod SHIFT, 9, ${cmd}, 9"
              "$mainMod SHIFT, 0, ${cmd}, 10"
            ]
          )
          ++ [
            # Example special workspace (scratchpad)
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"

            # Resize windows with mainMod + SHIFT + arrow keys
            "$mainMod SHIFT, left, resizeactive, -10% 0%"
            "$mainMod SHIFT, right, resizeactive, 10% 0%"
            "$mainMod SHIFT, up, resizeactive, 0% -10%"
            "$mainMod SHIFT, down, resizeactive, 0% 10%"
          ];

        bindm = [
          # Move/resize windows with mainMod + LMB/RMB and dragging
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindl = [
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"
          ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ];

        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
        ];
      };
    };

    services.hyprpaper = {
      enable = true;
      settings =
        let
          wallpaper = config.licht.wallpaper;
        in
        {
          ipc = "on";
          splash = false;
          splash_offset = 2.0;

          preload = [ "${wallpaper}" ];

          wallpaper = [ ",${wallpaper}" ];
        };
    };
  };
}
