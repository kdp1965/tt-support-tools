# The precheck's tools.  KLayout comes from nix-eda rather than nixpkgs:
# nixpkgs still packages 0.30.4, whose hierarchical (deep-mode) netlist
# processor has a performance regression that makes the full SG13 DRC deck
# take hours on a large tile (the TT precheck on an 8x4 cmos5l design ran
# 2-3 h, all of it before the first rule).  nix-eda builds 0.30.7 with a
# patch for it (nix/patches/klayout/performance_regression.patch); the same
# deck then finishes in minutes.  flake-compat lets this plain default.nix
# import the flake with its locked nixpkgs.
{ pkgs ? let
    flake-compat = fetchTarball "https://github.com/edolstra/flake-compat/archive/ff81ac966bb2cae68946d5ed5fc4994f96d0ffec.tar.gz";
    nix-eda = (import flake-compat {
      src = fetchTarball "https://github.com/fossi-foundation/nix-eda/archive/6.11.0.tar.gz";
    }).defaultNix;
  in
    nix-eda.legacyPackages.${builtins.currentSystem}
,
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.klayout
    pkgs.magic
  ];
}
