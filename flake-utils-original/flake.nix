{
  inputs = {
    nixpkgs.url =
      "github:nixos/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e";
    flake-utils.url =
      "github:numtide/flake-utils/1ef2e671c3b0c19053962c07dbda38332dcebf26";
  };
  outputs = inputs:
    inputs.flake-utils.lib.eachSystem [ "aarch64-linux" "x86_64-linux" ]
      (system:
        let
          cross-config = modules:
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
          nixosConfigurations.devkit = cross-config [ nixosModules.base ];
          packages = {
            default = nixosConfigurations.devkit.config.system.build.toplevel;
          };
        });
}
