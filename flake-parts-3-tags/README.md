# Third try - tagged configuration

Losing purity didn't feel right, and neither did losing `nixosConfiguration`.
So let's see how to replicate some of the flake-utils behavior, but in a better
way.

flake-utils was adding the build system name to the configurations, so let's do
it. What should the new configuration name be? "devkit-x86_64-linux"?
"x86_64-linux-devkit"? Something with a fancier separator like "@" or "~"?
Let's be as explicit as we can:

```
├───nixosConfigurations
│   ├───"devkit built on aarch64-linux": NixOS configuration
│   └───"devkit built on x86_64-linux": NixOS configuration
├───nixosModules
│   └───base: NixOS module
```

Yes, that looks weird, but those names won't appear anywhere apart from the
`nix flake show` output. Anyway, let's refactor the function producing those
names so we can edit it in one place until it feels right.

We have system-independent `nixosModules`, it's still an improvement over
flake-utils.

It's not all rosy. `nixosConfigurations` looks more complex now, and so does
the `packages` definition.

In some way, this solution feels like admitting defeat. If Nix cares about
purity to the degree that it won't let me detect the system it's running on,
why cannot I have `nixosConfigurations` elements that don't depend on the build
system? Am I missing something?
