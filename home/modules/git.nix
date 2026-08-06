{ lib, ... }: {
  programs.lazygit.enable = true;

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = lib.mkDefault "bobby.prins@gmail.com";
        name = lib.mkDefault "Bobby Prins";
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictStyle = "diff3";
        tool = "meld";
      };
      pull = {
        rebase = true;
      };
    };
    lfs.enable = true;
  };
}
