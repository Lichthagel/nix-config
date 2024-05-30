{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.requireFile {
  name = "topographical-catppuccin.jpg";
  url = "https://discord.com/channels/907385605422448742/1243778552000811028";
  sha256 = "sha256-bk0RgaWLZiE1NG+0Z4ObhsL+5OQ4DTRKHTxKBS+FvYA=";
}
