{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    flake-parts.url =
      "github:hercules-ci/flake-parts/f7b3c975cf067e56e7cda6cb098ebe3fb4d74ca2";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];
      flake = rec {
        nixosModules.base = { pkgs, ... }: {
          fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
          };
          boot.loader.grub.enable = false;
          system.stateVersion = "23.11";
          # Following causes infinite recursion:
          # nixpkgs.buildPlatform = pkgs.stdenv.buildPlatform.system;
          # And this is impure:
          # nixpkgs.buildPlatform = builtins.currentSystem;
          nixpkgs.buildPlatform = "x86_64-linux";
          nixpkgs.hostPlatform = "aarch64-linux";
        };
        nixosConfigurations.devkit = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ nixosModules.base ];
        };
      };
      perSystem = { system, ... }: {
        packages = {
          default =
            inputs.self.nixosConfigurations.devkit.config.system.build.toplevel;
        };
      };
    };
}
