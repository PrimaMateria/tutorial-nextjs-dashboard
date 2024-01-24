{
  description = "Development environment for Customer Dashboard";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    devToolkit.url = "github:primamateria/dev-toolkit-nix";
    # devToolkit.url = "/home/primamateria/dev/dev-toolkit-nix";
  };
  outputs = inputs@{ self, nixpkgs, utils, ... }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

      in
      with inputs.devToolkit.profiles.${system}; {
        devShell = pkgs.mkShell rec {
          name = "nix.shell.cuda";

          packages =
            node.packages;

          shellHook =
            wsl.hook +
            node.hook + ''
              echo "${name} started"
            '';
        };
      });
}
