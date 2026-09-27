{ lib, ... }: {
  programs.lazygit = {
    enable = true;
    settings = {
      git.commit.signOff = true;
      customCommands = [
        {
          key = "O";
          context = "commits";
          description = "Sign off selected commit and everything above it";
          prompts = [
            {
              type = "confirm";
              title = "Sign off";
              body = "Add Signed-off-by to {{.SelectedLocalCommit.Hash | printf \"%.7s\"}} and all newer commits?";
            }
          ];
          command = "git rebase --autostash --signoff {{.SelectedLocalCommit.Hash}}~1";
          loadingText = "Signing off...";
        }
      ];
    };
  };

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
