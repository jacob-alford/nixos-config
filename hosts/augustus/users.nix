{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  users.users = {
    jacob = {
      isNormalUser = true;
      description = "Jacob Alford";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtyqHcqkr11WdGh8DQYCY8rUrq0NwfwWMcYio3Z9Wof"
      ];
      shell = pkgs.zsh;
    };
  };
}
