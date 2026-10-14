{ config, lib, ... }:
{
  # Out-of-store links need the checkout's real location.
  options.repoPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/code/home-manager";
    description = "Absolute path of this repository's checkout.";
  };
}
