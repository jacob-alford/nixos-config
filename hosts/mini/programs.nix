{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;

    # oh-my-zsh = {
    #  enable = true;
    #  plugins = [ "git" ];
    # };

    # shellAliases = { };
  };
}
