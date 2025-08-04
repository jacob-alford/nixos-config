{ pkgs, config, ... }: {
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Opens the port the server is running on (by default 25565 but in this case 43000)
    declarative = true;
    whitelist = {
      # This is a mapping from Minecraft usernames to UUIDs. You can use https://mcuuid.net/ to get a Minecraft UUID for a username
      jacob_alford = "dfb56ab8-5441-4165-be4f-27f8e6e31ac4";
      Ryan_In_Reverie = "dab38f2e-0d4d-4c9f-8e4f-3fc1c23d9a42";
      squish37 = "3f66f523-9fb1-4fc9-af4a-1bdddcc50f9a";
    };
    serverProperties = {
      server-port = 25565;
      difficulty = 2;
      gamemode = 0;
      max-players = 5;
      motd = "§dThe Best§r§1 §r§5§kabcdefg§r§1 server§r";
      white-list = true;
      allow-cheats = false;
      enforce-whitelist = true;
    };
    package = pkgs.papermcServers.papermc-1_21_5;
  };

  ### Minecraft Backups ###
  services.restic.backups.minecraft = {
    user = "restic";
    repository = "/mnt/backups/minecraft-backup";
    initialize = true;
    passwordFile = config.sops.templates."minecraft-backup-passphrase".path;
    paths = [ "/var/lib/minecraft" ];
    timerConfig = {
      OnCalendar = "Mon..Sun *-*-* 06,12,18:00:00";
      Persistent = true;
    };
    package = pkgs.writeShellScriptBin "restic" ''
      exec /run/wrappers/bin/restic "$@"
    '';
  };
}
