{ lib, self, ... }:
{
  programs.ssh = {
    enable = true;

    serverAliveInterval = 60;

    matchBlocks = lib.mkMerge [
      {
        box = {
          hostname = "box.lichthagel.de";
          user = "licht";
        };
        orgit = {
          hostname = "git.or.rwth-aachen.de";
          identityFile = "~/.ssh/id_ed25519_rwth";
        };
        organ = {
          hostname = "organ.or.rwth-aachen.de";
          user = "jgatzweiler";
          identityFile = "~/.ssh/id_ed25519_rwth";
        };
      }
      (
        let
          orlabs = (lib.forEach (lib.range 1 12) (v: "orlab${lib.fixedWidthString 2 "0" (toString v)}"));
        in
        lib.genAttrs orlabs (
          name:
          lib.hm.dag.entryAfter [ "organ" ] {
            hostname = "${name}.or.rwth-aachen.de";
            user = "jgatzweiler";
            proxyJump = "organ";
            identityFile = "~/.ssh/id_ed25519_rwth";
          }
        )
      )
      (lib.genAttrs
        [
          "login18-1"
          "login18-2"
          "login18-3"
          "login18-4"
          "login23-1"
          "login23-2"
          "login23-3"
          "login23-4"
        ]
        (name: {
          hostname = "${name}.hpc.itc.rwth-aachen.de";
          user = builtins.readFile (self + /secrets/rwth_tim);
          identityFile = "~/.ssh/id_ed25519_rwth";
        })
      )
    ];
  };
}
