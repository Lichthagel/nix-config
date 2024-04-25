{ config, lib, ... }:
let
  cfg = config.licht.autostart;
in
{
  options.licht.autostart = {
    systemd = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Create systemd target autostart and user services";
    };

    forceNoXdg = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Fail if $HOME/.config/autostart/ is not empty";
    };

    entries = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            description = lib.mkOption {
              type = lib.types.str;
              description = "Description of the entry";
            };

            command = lib.mkOption {
              type = lib.types.str;
              description = "Command to run";
            };

            graphical = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether this command requires a graphical session";
            };
          };
        }
      );
      default = [ ];
      description = "List of commands to run at startup";
    };
  };

  config = {
    systemd.user = lib.mkIf cfg.systemd {
      targets.autostart = {
        Unit = {
          Description = "Autostart target";
          RefuseManualStart = false;
        };
      };

      services = lib.mapAttrs (name: value: {
        Unit = lib.mkMerge [
          { Description = value.description; }
          (lib.mkIf value.graphical {
            After = [ "graphical-session.target" ];
            Requires = [ "graphical-session.target" ];
          })
        ];

        Service = {
          Type = "simple";
          ExecStart = value.command;
        };

        Install = {
          WantedBy = [ "autostart.target" ];
        };
      }) cfg.entries;
    };

    home.activation = lib.mkIf cfg.forceNoXdg {
      checkNoXdgAutostart = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
        if [ -n "$(ls -A $HOME/.config/autostart/)" ]; then
          echo "error: $HOME/.config/autostart/ is not empty" >&2
          exit 1
        fi
      '';
    };
  };
}
