{ inputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  home.packages = with pkgs; [
    steam
    protonup
    kitty
    prismlauncher
    discord
    makemkv
    protonvpn-gui
    bolt-launcher
    mullvad-browser
    yubikey-manager
    finamp
    freecad-wayland
    httpie
    dmidecode
    popsicle
  ];
  
  programs.kitty.enable = true;
  
  programs.mangohud = {
    enable = true;
    settings = {
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_load_value = true;
      gpu_fan = true;

      cpu_temp = true;
      cpu_mhz = true;
      cpu_load_value = true;
    };
  };

  programs.home-manager.enable = true;

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Include ~/.ssh/1Password/config

      Host *
           	  IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
