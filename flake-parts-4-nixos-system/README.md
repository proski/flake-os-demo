# Fourth try - lib.nixosSystem

Another way to define a NixOS system is with `lib.nixosSystem` that doesn't
need to know the build system.

It turns out both `nixpkgs.buildPlatform` and `nixpkgs.hostPlatform` need to be
set for cross-compilation to work.

`nixpkgs.hostPlatform` is fixed, it's the hardware we are targeting. But
`nixpkgs.buildPlatform` is what we want to be variable. One would think it can
be copied from `pkgs.stdenv.buildPlatform.system`, but it's causing infinite
recursion.

Indeed, we are not passing any system-dependent arguments to the configuration
in `perSystem`, so `pkgs` as the `nixosModules` argument can only come from the
`nixosConfiguration`. Defining one based from another won't get us any
information about the current system.

It means that the build platform needs to be hardcoded unless we find some way
to break hermeticity of `nixosConfiguration`.

So we are back to what we had during our first attempt. One system can be
hardcoded, others need to use `--impure`.

But one thing is better now. The build system is defined in a module. The same
module can be used for many configurations.
