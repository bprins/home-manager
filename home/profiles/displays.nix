{ pkgs, ... }: {
  # Screen behaviour on the docked machines. Darwin-only: nixpkgs has no
  # BetterDisplay build for other platforms.
  home.packages = with pkgs; [
    betterdisplay
    caffeine
  ];
}
