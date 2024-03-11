{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    flake-parts.url = "github:hercules-ci/flake-parts/f7b3c975cf067e56e7cda6cb098ebe3fb4d74ca2";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];
      flake =
        let
          cross-config = modules:
            let
              pkgs = import inputs.nixpkgs {
                # Cannot get `system` here. Uncomment the line below if you
                # only ever build on x86_64-linux.
                # system = "x86_64-linux";
              };
            in
            pkgs.pkgsCross.aarch64-multiplatform.nixos { imports = modules; };
        in
        rec {
          nixosModules.base = { pkgs, ... }: {
            fileSystems."/" = {
              device = "/dev/disk/by-label/nixos";
              fsType = "ext4";
            };
            boot.loader.grub.enable = false;
            system.stateVersion = "23.11";
          };
          nixosConfigurations.devkit = cross-config [ nixosModules.base ];
        };
      perSystem = { system, ... }: {
        packages = {
          default = inputs.self.nixosConfigurations.devkit.config.system.build.toplevel;
        };
      };
    };
}
