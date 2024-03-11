# First try - losing purity

The first attempt to convert to flake-parts goes fine until you discover that
you cannot pass `system` to the code that needs to be in `nixosConfiguration`.

You don't have to specify `system` when importing `nixpkgs`, but now you have
to use `nix build --impure` to build.

Moreover, `nix flake show` and `nix flake check` need `--impure` too.

Good luck justifying that "improvement"!

And if you hardcode e.g. `system = "x86_64-linux"` that's not an improvement
either. Your Mac with Apple Silicon won't be able to build this flake, even if
you install Linux on it (in a VM or natively).
