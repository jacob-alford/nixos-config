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
    planka = {
      gid = 10666;
    };
    planka-certs = {
      gid = 11666;
    };
  };

  users.users = {
    jacob = {
      isNormalUser = true;
      description = "Jacob Alford";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD6gE/UA8NCZkxImg073c02kzh3P6ohV8DLzTXQeoJanwCDJgWYMsQI55XoYqanK8n/xooiKEkt3MCIAmG9EtTs="
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
      uid = 10666;
    };
  };
}
