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
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEaAzzPDHwyEe/3DS6MlYlAjZpdg84KckJsBA99k0/O3NgS16/XMj2SH/JN6mrcV/GZ6yat60RlpuYbgKBNDl84="
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
