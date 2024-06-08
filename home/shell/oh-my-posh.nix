{ config, lib, ... }:
let
  cfg = config.programs.oh-my-posh.licht;
in
{
  options.programs.oh-my-posh.licht = {
    enable = lib.mkEnableOption "oh-my-posh";
  };

  config = lib.mkIf cfg.enable {
    programs.oh-my-posh = {
      enable = true;
      settings = {
        "$schema" = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/master/themes/schema.json";
        version = 2;

        palette =
          let
            palette =
              (lib.importJSON "${config.catppuccin.sources.palette}/palette.json").${config.catppuccin.flavor};

            colors = lib.mapAttrs (_: value: value.hex) (
              palette.colors // { accent = palette.colors.${config.catppuccin.accent}; }
            );
          in
          colors;

        blocks = [
          {
            alignment = "left";
            segments = [
              {
                foreground = "p:overlay0";
                style = "plain";
                template = "╭";
                type = "text";
              }
              {
                foreground = "p:lavender";
                style = "plain";
                template = "{{ .Icon }} ";
                type = "os";
              }
              {
                foreground = "p:red";
                style = "plain";
                template = " ";
                type = "root";
              }
              {
                foreground = "p:rosewater";
                style = "plain";
                template = "{{ if or .Root (ne .UserName \"${config.home.username}\") }}<d>{{ .UserName }}</d> {{ end }} {{ if .SSHSession }}<p:flamingo>󰢹 {{ .HostName }}</> {{ end }}"; # TODO include host when ssh in different color
                type = "session";
              }
              {
                foreground = "p:pink";
                properties = {
                  style = "full";
                  mapped_locations = {
                    "/mnt/d/Projects" = " ";
                    "~/Projects" = " ";
                    "D:/Projects" = " ";
                  };
                };
                style = "plain";
                template = "<i>{{ .Path }}</i> ";
                type = "path";
              }
              {
                foreground = "p:peach";
                properties = {
                  branch_icon = " ";
                  branch_identical_icon = "";
                  branch_ahead_icon = "󰁝";
                  branch_behind_icon = "󰁅";
                  branch_gone_icon = "󰃹";
                  commit_icon = "󰜘 ";
                  tag_icon = "󰓹 ";
                  rebase_icon = " ";
                  cherry_pick_icon = " ";
                  revert_icon = " ";
                  merge_icon = "󰘭 ";
                  no_commits_icon = " ";
                  fetch_status = true;
                };
                style = "plain";
                template = "{{ .HEAD }} {{ if .BranchStatus }}{{ .BranchStatus }} {{ end }}{{ if .Working.Changed }}{{ .Working.String }} {{ end }}{{ if .Staging.Changed }}{{ .Staging.String }} {{ end }}";
                type = "git";
              }
              {
                foreground = "p:yellow";
                style = "plain";
                template = " {{ if .Error }}{{ .Error }}{{ else }}{{ if .Version }}{{.Version}} {{ end }}{{ end }}";
                type = "project";
              }
              {
                foreground = "p:sapphire";
                style = "plain";
                template = " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ";
                type = "cmake";
              }
              {
                foreground = "p:green";
                style = "plain";
                properties = {
                  extensions = [ "deno.json" ];
                };
                template = "🦕 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ";
                type = "deno";
              }
              {
                foreground = "p:green";
                style = "plain";
                properties = {
                  extensions = [ "package.json" ];
                };
                template = "{{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}󰎙 {{ .Full }} ";
                type = "node";
              }
              {
                foreground = "p:lavender";
                style = "plain";
                template = "󰳐 {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ";
                type = "nx";
              }
              {
                foreground = "p:yellow";
                style = "plain";
                template = " {{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Full }} {{ end }}";
                type = "python";
              }
              {
                foreground = "p:flamingo";
                style = "plain";
                template = " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }} ";
                type = "rust";
              }
              {
                foreground = "p:blue";
                style = "plain";
                template = "{{ if .Env.IN_NIX_SHELL }} {{ .Env.name }} {{ end }}";
                type = "text";
              }
              {
                foreground = "p:overlay0";
                style = "plain";
                template = "{{ .FormattedMs }} ";
                type = "executiontime";
              }
            ];
            type = "prompt";
          }
          {
            alignment = "left";
            newline = true;
            segments = [
              {
                style = "plain";
                foreground = "p:overlay0";
                template = "╰";
                type = "text";
              }
              {
                style = "plain";
                foreground = "p:text";
                foreground_templates = [
                  "{{if gt .Code 0}}p:red{{end}}"
                  "{{if eq .Code 0}}p:green{{end}}"
                ];
                template = "";
                type = "text";
              }
            ];
            type = "prompt";
          }
        ];
        "transient_prompt" = {
          "foreground" = "p:text";
          "template" = "  ";
        };
        final_space = true;
      };
    };
  };
}
