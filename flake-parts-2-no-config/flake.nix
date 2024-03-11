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
      flake = {
        nixosModules.base = { pkgs, ... }: {
          fileSystems."/" = {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
          };
          boot.loader.grub.enable = false;
          system.stateVersion = "23.11";
        };
      };
      perSystem = { pkgs, ... }:
        let
          cross-config = { pkgs, modules, }:
            pkgs.pkgsCross.aarch64-multiplatform.nixos { imports = modules; };
          # This is our devkit.
          nixos-devkit = cross-config {
            inherit pkgs;
            modules = [ inputs.self.nixosModules.base ];
          };
          # Our other systems will go here.
        in
        {
          packages = { default = nixos-devkit.config.system.build.toplevel; };
        };
    };
}
