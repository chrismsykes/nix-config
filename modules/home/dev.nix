{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.dev;
in
{
  options.my.dev.enable = lib.mkEnableOption "the full dev toolbox (kubernetes, language runtimes, media tools)";

  config = lib.mkIf cfg.enable {
    home.packages =
      # From unstable so kubectl doesn't lag your clusters' versions.
      (with pkgs.unstable; [
        k9s
        kubectl
        kubectx
        kubernetes-helm
        kustomize
        stern
      ])
      ++ (with pkgs; [
        ffmpeg
        yt-dlp

        # Default runtimes for quick scripts outside any project. Real projects pin their own
        # toolchain in a flake devShell; see templates/ and "Project environments" in README.md.
        go
        nodejs
        temurin-bin-21
      ]);
  };
}
