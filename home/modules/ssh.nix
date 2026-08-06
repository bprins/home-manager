{ ... }: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      # podman machine, see ./containers.nix
      "127.0.0.1" = {
        identityFile = "~/.local/share/containers/podman/machine/machine";
      };
      "*" = {
        addKeysToAgent = "yes";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
