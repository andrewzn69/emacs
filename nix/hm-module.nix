{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.emacs = {
    enable = true;
    package = import ./emacs.nix pkgs;
  };

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    # pdf tools finds epdfinfo on PATH
    (import ./epdfinfo.nix pkgs)
  ]
  # skip git when programs.git already installs it, two git pkgs can collide
  ++ lib.optional (!config.programs.git.enable) pkgs.git;

  # fonts from home.packages get found, needed outside nixos
  fonts.fontconfig.enable = true;
}
