# flake-os-demo

The code in this repository illustrates how to convert a flake that uses
nixosConfigurations from flake-utils to flake-parts.

The conclusions so far:

`nixosConfigurations` is supposed to be hermetic, i.e. it should not take any
information about the build or the host system from the outside.

Not taking the build system information is disappointing but could be justified
by the fact that building on different systems is not likely to produce exactly
the same output.

One way to deal with it is to designate one system as official. Users of other
systems have to use `--impure` so their systems can be detected.

It's possible to remove `nixosConfigurations` from the flake completely if that
limitation is unacceptable.

Another option is to have separate configurations for different build system.
Refactoring of the resulting code is possible, but it looks quite complex.
