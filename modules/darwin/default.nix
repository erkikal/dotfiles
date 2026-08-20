# Aggregates all system-level (nix-darwin) modules.
{ ... }:

{
  imports = [
    ./nix.nix
    ./homebrew.nix
    ./system-defaults.nix
  ];
}
