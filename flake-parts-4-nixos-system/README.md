# Fourth try - lib.nixosSystem

Another way to define a NixOS system is with `lib.nixosSystem` that doesn't
need to know the build system.

It turns out both `nixpkgs.buildPlatform` and `nixpkgs.hostPlatform` need to be
set for cross-compilation to work.

`nixpkgs.hostPlatform` is fixed, it's the hardware we are targeting. But
`nixpkgs.buildPlatform` is what we want to be variable. One would think it can
be copied from `pkgs.stdenv.buildPlatform.system`, but it's causing infinite
recursion.

It means that the build platform needs to be hardcoded unless we find some way
to smuggle `system` from `perSystem` into the module.

Hardcoding the build platform makes this approach just as problematic as our
first attempt to convert from flake-utils to flake-parts.
