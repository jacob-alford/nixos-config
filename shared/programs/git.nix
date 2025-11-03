{ inputs
, lib
, config
, pkgs
, ...
}: {
  programs.git = {
    enable = true;
    userName = "Jacob Alford";
    userEmail = "github.scouting378@passmail.net";
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_signing";
      signByDefault = true;
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };

      pull = {
        rebase = true;
      };

      core = {
        editor = "nvim";
      };

      push = {
        autoSetupRemote = true;
      };

      gpg = {
        format = "ssh";
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "~/.ssh/id_ed25519_signing";
      };
    };
  };
}
