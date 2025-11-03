{ inputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  home.packages = with pkgs; [
    yubikey-manager
    httpie
  ];

  programs.home-manager.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

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

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "key::ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYLbVA5672FbyQKVQg3dsA2ozdcrf7dCW2o+fdrgIYq github.scouting378@passmail.net";
      };
    };
  };
}
