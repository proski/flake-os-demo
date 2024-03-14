# First try - losing purity

The first attempt to convert to flake-parts goes fine until you discover that
you cannot pass `system` to the code that needs to be in `nixosConfiguration`.

You don't have to specify `system` when importing `nixpkgs`, but now you have
to use `nix build --impure` to build.

Moreover, `nix flake show` and `nix flake check` need `--impure` too.

You can hardcode one system as a fallback, but users of other systems still
need `--impure`.

Your best bet is to designate of system as "official" and others are
"unofficial". That may work for some teams but not for others.
