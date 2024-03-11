# The original code using flake-utils

Everything looks neat. But let's look closer.

`nix flake show` shows two different configurations for the host system instead
of just one.

```
├───nixosConfigurations
│   ├───aarch64-linux: NixOS configuration
│   └───x86_64-linux: NixOS configuration
```

Even though all configurations are supposed to run on aarch64-linux, their
names are the systems that build the image.

Likewise, there are two children of `nixosModules`:

```
├───nixosModules
│   ├───aarch64-linux: NixOS module
│   └───x86_64-linux: NixOS module
```

And `nix flake check` reports a problem:

```
error: attribute 'config' in selection path 'config.system.build.toplevel' not found
```

Search for "flake-utils" and you'll find a lot of suggestions to stop using it
precisely for that reason. flake-utils makes all flake outputs
system-dependent, whether they should be (like `packages`) or not (like
`nixosConfigurations` and `nixosModules`).
