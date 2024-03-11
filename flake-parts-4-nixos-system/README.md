# Fourth try - lib.nixosSystem

Another way to define a NixOS system is with `lib.nixosSystem` that doesn't
need to know the build system.

However, I get a build error when cross-compiling.

```
error: a 'aarch64-linux' with features {} is required to build
'/nix/store/f2ljg5xnkrx9ap1sz6gbc7fykg4cw12w-append-initrd-secrets.drv', but I
am a 'x86_64-linux' with features {benchmark, big-parallel, kvm, nixos-test,
uid-range}
```

Setting `boot.kernel.enable = false;` gets me past that point, but then I get

```
error: a 'aarch64-linux' with features {} is required to build
'/nix/store/vfnbkn6p0kgx9n1lzjxlcm9iag94sb46-mounts.sh.drv', but I am a
'x86_64-linux' with features {benchmark, big-parallel, kvm, nixos-test,
uid-range}
```
