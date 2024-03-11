# Second try - no `nixosConfiguration`

If `nixosConfiguration` is an obstacle that prevents us from passing `system`
from per-system code to the place where we need `aarch64-multiplatform.nixos`,
what if we get rid of that obstacle?

`nix build` is happy, `nix flake show` and `nix flake check` are happy too. But
the output of `nix flake show` is shorter now:

```
git+file:///home/proski/src/flake-os-demo?dir=flake-parts-2-no-config
├───nixosModules
│   └───base: NixOS module
└───packages
    ├───aarch64-linux
    │   └───default omitted (use '--all-systems' to show)
    └───x86_64-linux
        └───default: package 'nixos-system-nixos-23.11pre-git'
```

The information about the systems we support is in some temporary variables
now. That's acceptable if the code is well structured. But it's not an
improvement. We lose access to a feature that was created for our use case.
