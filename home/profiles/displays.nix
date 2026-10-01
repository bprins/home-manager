{ pkgs, ... }: {
  home.packages = with pkgs; [
    betterdisplay
    caffeine
  ];

  # Sparkle updates disabled, we use flake.lock
  targets.darwin.defaults."pro.betterdisplay.BetterDisplay".SUEnableAutomaticChecks = false;
}
