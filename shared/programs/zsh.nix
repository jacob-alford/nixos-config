{ inputs
, lib
, config
, pkgs
, ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      gnome_restart = "sudo systemctl restart display-manager.service";

      ssh_udm = "TERM=vt100 ssh root@10.76.100.1";
      ssh_unas = "TERM=vt100 ssh root@nas.plato-splunk.media";
      ssh_aug = "SSH_AUTH_SOCK=/run/user/1000/ssh-agent TERM=vt100 ssh -A jacob@augustus.neko-bicolor.ts.net";
      ssh_mini = "TERM=vt100 ssh jacob@mini.neko-bicolor.ts.net";
    };
  };
}
