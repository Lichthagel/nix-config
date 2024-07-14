{
  pkgs,
  mpv-discord-version,
  mpv-discord-src,
}:
[
  pkgs.mpvScripts.uosc
  pkgs.mpvScripts.thumbfast
  (pkgs.stdenvNoCC.mkDerivation {
    name = "dynamic-crop";

    src = pkgs.fetchFromGitHub {
      owner = "Ashyni";
      repo = "mpv-scripts";
      rev = "1fadd5ea3e31818db33c9372c40161db6fc1bdd3";
      sha256 = "sha256-nC0Iw+9PSGxc3OdYhEmFVa49Sw+rIbuFhgZvAphP4cM=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/mpv/scripts
      cp dynamic-crop.lua $out/share/mpv/scripts

      runHook postInstall
    '';

    passthru.scriptName = "dynamic-crop.lua";
  })
  (pkgs.stdenvNoCC.mkDerivation {
    name = "mpv-copyTime";

    src = pkgs.fetchFromGitHub {
      owner = "Arieleg";
      repo = "mpv-copyTime";
      rev = "10b53d507085ba2deda301b6fab3397eee275b71";
      sha256 = "sha256-7yYwHTpNo4UAaQdMVF5n//Hnk8+O+x1Q5MXG6rfFNpc=";
    };

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/mpv/scripts
      cp copyTime.lua $out/share/mpv/scripts

      runHook postInstall
    '';

    passthru.scriptName = "copyTime.lua";
  })
  (pkgs.stdenvNoCC.mkDerivation {
    name = "blur-edges";

    src = pkgs.fetchFromGitHub {
      owner = "occivink";
      repo = "mpv-scripts";
      rev = "d0390c8e802c2e888ff4a2e1d5e4fb040f855b89";
      sha256 = "sha256-pc2aaO7lZaoYMEXv5M0WI7PtmqgkNbdtNiLZZwVzppM=";
    };

    patches = [ ./blur-edges.patch ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/mpv/scripts
      cp scripts/blur-edges.lua $out/share/mpv/scripts

      runHook postInstall
    '';

    passthru.scriptName = "blur-edges.lua";
  })
  # (pkgs.stdenvNoCC.mkDerivation {
  #   name = "status-line";

  #   src = pkgs.fetchurl {
  #     url = "https://raw.githubusercontent.com/mpv-player/mpv/5ea390c07f166ad1186b409176dd4e27d93b6f92/TOOLS/lua/status-line.lua";
  #     sha256 = "sha256-f626+0y9H1V3GoOBXodOH6f6rRDSOeIL3ypE7Oyhic4=";
  #   };

  #   dontUnpack = true;

  #   installPhase = ''
  #     runHook preInstall

  #     mkdir -p $out/share/mpv/scripts
  #     cp $src $out/share/mpv/scripts/status-line.lua

  #     runHook postInstall
  #   '';

  #   passthru.scriptName = "status-line.lua";
  # })
  # (pkgs.stdenvNoCC.mkDerivation {
  #   name = "mpv-discordRPC";

  #   src = pkgs.fetchFromGitHub {
  #     owner = "cniw";
  #     repo = "mpv-discordRPC";
  #     rev = "9a060308fd05e6752981592d0a9e92b5e149fdc9";
  #     sha256 = "sha256-n6NMyaRtR7a/WvHKHCLxLxC8vdK1cAqvnkqhY0M83x4=";
  #   };

  #   propagatedBuildInputs = with pkgs; [ discord-rpc ];

  #   patches = [ ./mpv-discordRPC.patch ];

  #   postPatch = ''
  #     substituteInPlace mpv-discordRPC/lua-discordRPC.lua \
  #       --replace "ffi.load(\"discord-rpc\")" "ffi.load(\"${pkgs.discord-rpc}/lib/libdiscord-rpc.so\")"
  #   '';

  #   installPhase = ''
  #     runHook preInstall

  #     mkdir -p $out/share/mpv/scripts
  #     cp -r mpv-discordRPC $out/share/mpv/scripts/

  #     runHook postInstall
  #   '';

  #   passthru.scriptName = "mpv-discordRPC";
  # })
  (pkgs.stdenvNoCC.mkDerivation {
    pname = "mpv-discord";
    version = mpv-discord-version;

    src = mpv-discord-src;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/mpv
      cp -r scripts $out/share/mpv

      runHook postInstall
    '';

    passthru.scriptName = "discord.lua";
  })
]
