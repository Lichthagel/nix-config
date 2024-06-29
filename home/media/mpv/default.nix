{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}:
let
  cfg = config.licht.media.mpv;
in
{
  options = {
    licht.media.mpv = {
      enable = lib.mkEnableOption "my mpv configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mpv =
      let
        mpv-discord-version = "1.6.1";
        mpv-discord-src = pkgs.fetchFromGitHub {
          owner = "tnychn";
          repo = "mpv-discord";
          rev = "v${mpv-discord-version}";
          sha256 = "sha256-P1UaXGboOiqrXapfLzJI6IT3esNtflkQkcNXt4Umukc=";
        };
      in
      {
        enable = true;
        catppuccin.enable = true;
        config = {
          border = true;
          cscale = "ewa_lanczossharp";
          deband = true;
          demuxer-max-bytes = "256m";
          fbo-format = "rgba16hf";
          geometry = "50%+50%+50%";
          gpu-api = "vulkan";
          interpolation = true;
          keep-open = true;
          osc = false;
          osd-bar = false;
          osd-duration = 2000;
          osd-font-size = 25;
          osd-font = "Noto Sans";
          profile = "gpu-hq";
          scale = "ewa_lanczos";
          scale-blur = 0.981251;
          screenshot-directory = "~/Bilder/Screenshots"; # TODO
          screenshot-format = "webp";
          screenshot-template = "%tY-%tm/%tY-%tm-%td_%tH-%tM-%tS";
          screenshot-webp-compression = 6;
          screenshot-webp-lossless = true;
          sub-font = "Lexend";
          sub-font-size = 43;
          tscale = "oversample";
          video-sync = "display-resample";
          vo = "gpu-next";
          volume = 70;
        };
        package = pkgs.mpv-unwrapped.wrapper {
          mpv = pkgs.mpv-unwrapped.override {
            ffmpeg = pkgs.ffmpeg-full;
            lua = pkgs.luajit;
          };
          scripts = import ./scripts.nix {
            inherit
              pkgs
              unstablePkgs
              mpv-discord-version
              mpv-discord-src
              ;
          };
        };
        scriptOpts = import ./script-opts.nix {
          inherit
            config
            lib
            pkgs
            mpv-discord-version
            mpv-discord-src
            ;
        };
      };

    xdg.configFile = {
      "mpv/input.conf".source = ./input.conf;
      "mpv/shaders".source =
        let
          anime4k = pkgs.fetchzip {
            url = "https://github.com/bloc97/Anime4K/releases/download/v4.0.1/Anime4K_v4.0.zip";
            sha256 = "sha256-9B6U+KEVlhUIIOrDauIN3aVUjZ/gQHjFArS4uf/BpaM=";
            stripRoot = false;
          };
          fsrcnnx-x2-16-0-4-1 = pkgs.fetchurl {
            url = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/1.1/FSRCNNX_x2_16-0-4-1.glsl";
            sha256 = "sha256-1aJKJx5dmj9/egU7FQxGCkTCWzz393CFfVfMOi4cmWU=";
          };
          fsrcnnx-x2-8-0-4-1 = pkgs.fetchurl {
            url = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/1.1/FSRCNNX_x2_8-0-4-1.glsl";
            sha256 = "sha256-6ADbxcHJUYXMgiFsWXckUz/18ogBefJW7vYA8D6Nwq4=";
          };
          fsrcnnx-checkpoint-params = pkgs.fetchurl {
            url = "https://github.com/igv/FSRCNN-TensorFlow/releases/download/1.1/checkpoints_params.7z";
            sha256 = "sha256-h5B7DU0W5B39rGaqC9pEqgTTza5dKvUHTFlEZM1mfqo=";
          };
          ssimdownscaler = pkgs.fetchurl {
            url = "https://gist.githubusercontent.com/igv/36508af3ffc84410fe39761d6969be10/raw/575d13567bbe3caa778310bd3b2a4c516c445039/SSimDownscaler.glsl";
            sha256 = "sha256-AEq2wv/Nxo9g6Y5e4I9aIin0plTcMqBG43FuOxbnR1w=";
          };
          krigbilateral = pkgs.fetchurl {
            url = "https://gist.githubusercontent.com/igv/a015fc885d5c22e6891820ad89555637/raw/038064821c5f768dfc6c00261535018d5932cdd5/KrigBilateral.glsl";
            sha256 = "sha256-ikeYq7d7g2Rvzg1xmF3f0UyYBuO+SG6Px/WlqL2UDLA=";
          };
        in
        pkgs.stdenvNoCC.mkDerivation {
          name = "mpv-shaders";

          dontUnpack = true;

          buildPhase = ''
            runHook preBuild

            mkdir -p $out
            cp -r ${anime4k}/* $out
            cp ${fsrcnnx-x2-16-0-4-1} $out/${fsrcnnx-x2-16-0-4-1.name}
            cp ${fsrcnnx-x2-8-0-4-1} $out/${fsrcnnx-x2-8-0-4-1.name}
            ${pkgs.p7zip}/bin/7z e -o$out ${fsrcnnx-checkpoint-params} FSRCNNX_x2_8-0-4-1_LineArt.glsl
            cp ${ssimdownscaler} $out/${ssimdownscaler.name}
            cp ${krigbilateral} $out/${krigbilateral.name}

            runHook postBuild
          '';
        };
    };
  };
}
