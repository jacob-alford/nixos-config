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
      # This will probably only work on nixos
      gnome_restart = "sudo systemctl restart display-manager.service";

      ssh_udm = "TERM=vt100 ssh root@10.76.100.1";
      ssh_unas = "TERM=vt100 ssh root@nas.plato-splunk.media";
    };
  };
}
