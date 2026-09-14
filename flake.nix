{
  description = "portable emacs config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # nix run starts emacs with the cfg pinned in this flake, no clone needed
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          emacs = import ./nix/emacs.nix pkgs;
        in
        {
          default = pkgs.writeShellApplication {
            name = "emacs";
            # git for straight and magit, epdfinfo for pdf tools, only on this emacs path
            runtimeInputs = [
              pkgs.git
              (import ./nix/epdfinfo.nix pkgs)
            ];
            text = ''
              exec ${emacs}/bin/emacs --init-directory ${self} "$@"
            '';
          };
        }
      );

      homeManagerModules.default = import ./nix/hm-module.nix;
    };
}
