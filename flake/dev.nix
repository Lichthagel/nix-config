{ self, inputs, ... }:
{
  perSystem =
    {
      self',
      system,
      pkgs,
      unstablePkgs,
      inputs',
      ...
    }:
    {
      checks = {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = "${self}";
          hooks = {
            # nix
            deadnix = {
              enable = true;
              excludes = [ "^template\/.*" ];
            };
            nil.enable = true;
            nixfmt = {
              enable = true;
              package = self'.formatter;
            };
            statix.enable = true;

            # shell
            shellcheck.enable = true;
            shfmt.enable = true;

            # lua
            luacheck.enable = true;
            lua-ls.enable = true;
            stylua.enable = true;

            # yaml
            check-yaml.enable = true;
            sort-simple-yaml.enable = true;
            yamllint.enable = true;

            # toml
            check-toml.enable = true;

            # json
            check-json.enable = true;

            # git
            check-merge-conflicts.enable = true;
            commitizen.enable = true;

            # other
            prettier = {
              enable = true;
              excludes = [ "flake.lock" ];
            };
            trim-trailing-whitespace = {
              enable = true;
              excludes = [ ".*\.patch" ];
            };
          };
        };
      };

      devShells.default = pkgs.mkShell {
        inherit (self'.checks.pre-commit-check) shellHook;

        packages =
          with pkgs;
          [
            self'.formatter
            just
            nil
            nixd
            nix-output-monitor
            nvd
            inputs'.agenix.packages.default
            lego
          ]
          ++ self'.checks.pre-commit-check.enabledPackages;
      };

      formatter = unstablePkgs.nixfmt-rfc-style;
    };
}
