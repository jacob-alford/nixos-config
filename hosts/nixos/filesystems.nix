{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  fileSystems."/mnt/backups" = {
    device = "//10.10.0.251/Personal-Drive";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=${config.sops.templates."smb-creds".path},uid=1001,gid=${toString config.users.groups.users.gid}" ];
  };

  fileSystems."/home/jacob/cloud" = {
    device = "//10.10.0.251/Personal-Drive";
    fsType = "cifs";
    options =
      let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in
      [ "${automount_opts},credentials=${config.sops.templates."jacob-smb-creds".path},uid=1000,gid=${toString config.users.groups.users.gid}" ];
  };
}
