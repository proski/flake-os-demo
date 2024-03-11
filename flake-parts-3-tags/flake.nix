{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    flake-parts.url =
      "github:hercules-ci/flake-parts/f7b3c975cf067e56e7cda6cb098ebe3fb4d74ca2";
  };
  outputs = inputs:
    let build-tag = config: system: config + " built on " + system;
    in inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];
      flake =
        let
          cross-config = { system, modules, }:
            let pkgs = import inputs.nixpkgs { inherit system; };
            in pkgs.pkgsCross.aarch64-multiplatform.nixos { imports = modules; };
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
          nixosConfigurations =
            let
              nixos-conf = system: {
                # Our devkit
                "${build-tag "devkit" system}" = cross-config {
                  inherit system;
                  modules = [ nixosModules.base ];
                };
                # Other systems go here
              };
            in
            nixos-conf "aarch64-linux" // nixos-conf "x86_64-linux";
        };
      perSystem = { system, ... }: rec {
        packages =
          let
            build-config = sysconfig:
              let nixos-config = "${build-tag sysconfig system}";
              in with inputs.self.nixosConfigurations."${nixos-config}"; {
                "${sysconfig}" = config.system.build.toplevel;
              };
          in
          build-config "devkit" // { default = packages.devkit; };
      };
    };
}
