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

      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILWx58wZCH+S3GeV6WIEYl34u5ST3SYnpKZbdN3YLPI";
      };

      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
        "https://gist.github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };
  };
}
