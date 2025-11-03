{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  users.groups = {
    radiusd = {
      gid = 222;
    };
    hass = {
      gid = config.ids.gids.hass;
    };
    planka = { };
  };

  users.users = {
    jacob = {
      isNormalUser = true;
      description = "Jacob Alford";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaAzzPDHwyEe/3DS6MlYlAjZpdg84KckJsBA99k0/O3NgS16/XMj2SH/JN6mrcV/GZ6yat60RlpuYbgKBNDl84="
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIApcg0ug0kJ6QAsv/hDOyva7qk7efKQhBzI1Ty4J7nISAAAABHNzaDo= yk1-ssh-ed25519"
      ];
      shell = pkgs.zsh;
    };
    restic = {
      isNormalUser = true;
    };
    radiusd = {
      isSystemUser = true;
      group = "radiusd";
      uid = 222;
    };
    hass = {
      home = "/var/lib/hass";
      createHome = true;
      group = "hass";
      uid = config.ids.uids.hass;
    };
    planka = {
      isSystemUser = true;
      home = "/var/lib/planka";
      group = "planka";
    };
  };
}
