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
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBD6gE/UA8NCZkxImg073c02kzh3P6ohV8DLzTXQeoJanwCDJgWYMsQI55XoYqanK8n/xooiKEkt3MCIAmG9EtTs="
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGCI/SI5sFnBLVyn4kit2WXh/tgFhoblW8CNF68HLD4yMU3lN52QD0BCSe1s3R1NTnZGnGxaQANR7EEKjQBvEjc="
      ];
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [ ];
      shell = pkgs.zsh;
    };
    restic = {
      isNormalUser = true;
    };
  };
}
