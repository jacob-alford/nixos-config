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
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
      ];
      shell = pkgs.zsh;
    };
    restic = {
      isNormalUser = true;
    };
  };
}
