{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  users.groups = {
    radiusd = { };
  };

  users.users = {
    jacob = {
      isNormalUser = true;
      description = "Jacob Alford";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtyqHcqkr11WdGh8DQYCY8rUrq0NwfwWMcYio3Z9Wof"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaAzzPDHwyEe/3DS6MlYlAjZpdg84KckJsBA99k0/O3NgS16/XMj2SH/JN6mrcV/GZ6yat60RlpuYbgKBNDl84="
      ];
      shell = pkgs.zsh;
    };
    restic = {
      isNormalUser = true;
    };
    radiusd = {
      isSystemUser = true;
      group = "radiusd";
    };
  };
}
