{ lib }:
{
  mainBar =
    let
      workspacesCommon = {
        "active-only" = false;
        "all-outputs" = false;
        "format" = "{icon}";
        "on-click" = "activate";
        "format-icons" = lib.fold (elem: acc: acc // elem) { } (
          lib.forEach (lib.range 0 4) (i: {
            "${builtins.toString ((10 * i) + 1)}" = "一";
            "${builtins.toString ((10 * i) + 2)}" = "二";
            "${builtins.toString ((10 * i) + 3)}" = "三";
            "${builtins.toString ((10 * i) + 4)}" = "四";
            "${builtins.toString ((10 * i) + 5)}" = "五";
            "${builtins.toString ((10 * i) + 6)}" = "六";
            "${builtins.toString ((10 * i) + 7)}" = "七";
            "${builtins.toString ((10 * i) + 8)}" = "八";
            "${builtins.toString ((10 * i) + 9)}" = "九";
            "${builtins.toString ((10 * i) + 10)}" = "十";
          })
        );
      };
    in
    {
      layer = "top";
      position = "top";
      modules-left = [
        "mpris"
        # "hyprland/window"
        "sway/mode"
      ];
      modules-center = [
        "hyprland/workspaces"
        "sway/workspaces"
      ];
      modules-right = [
        "custom/notification"
        "backlight"
        "battery"
        "bluetooth"
        # power profiles
        # "upower"
        # "wlr/taskbar"
        "tray"
        # "cpu"
        # "memory"
        # "disk"
        # "keyboard-state"
        "pulseaudio"
        "network"
        "privacy"
        "clock"
      ];

      "hyprland/workspaces" = workspacesCommon // {
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
        "show-special" = false;
      };

      "sway/workspaces" = workspacesCommon // {
        "on-scroll-up" = "swaymsg workspace next";
        "on-scroll-down" = "swaymsg workspace prev";
        "show-special" = true;
      };

      "backlight" = {
        format = "{percent}% {icon}";
        # format-icons = [
        #   "󰛩"
        #   "󱩎"
        #   "󱩏"
        #   "󱩐"
        #   "󱩑"
        #   "󱩒"
        #   "󱩓"
        #   "󱩔"
        #   "󱩕"
        #   "󱩖"
        # ];
      };

      "mpris" = {
        "format" = "{player_icon} {artist} - {title}";
        "format-paused" = "{status_icon}";
        "player-icons" = {
          "chromium" = " ";
          "default" = " ";
          "firefox" = " ";
          "kdeconnect" = " ";
          "mopidy" = " ";
          "mpv" = "󰐹 ";
          "spotify" = " ";
          "vlc" = "󰕼 ";
        };
        "status-icons" = {
          "paused" = " ";
          "playing" = " ";
          "stopped" = " ";
        };
      };

      "network" = {
        "format-ethernet" = "󰈀";
        "format-wifi" = "{essid} ({signalStrength}%) ";
        "tooltip-format" = "{ipaddr}/{cidr} via {gwaddr} on {ifname}";
      };

      "custom/notification" = {
        "tooltip" = false;
        "format" = " {icon} ";
        "format-icons" = {
          "notification" = "<span foreground='red'><sup></sup></span>";
          "none" = "";
          "dnd-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-none" = "";
          "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "inhibited-none" = "";
          "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
          "dnd-inhibited-none" = "";
        };
        "return-type" = "json";
        "exec-if" = "which swaync-client";
        "exec" = "swaync-client -swb";
        "on-click" = "swaync-client -t -sw";
        "on-click-right" = "swaync-client -d -sw";
        "escape" = true;
      };
    };
}
