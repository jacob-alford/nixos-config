{ inputs
, outputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ../../shared/nix.nix
    ./services
    ./filesystems.nix
    ./hardware.nix
    ./programs.nix
    ./security.nix
    ./sops.nix
    ./system.nix
    ./users.nix
  ];

  nixpkgs = {
    overlays = [
      ### Ollama Patch to use CUDA ###
      (self: super: {
        ctranslate2 = super.ctranslate2.override {
          withCUDA = true;
          withCuDNN = true;
        };
      })
    ];
    
    config = {
      allowUnfree = true;

      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "1password-gui"
          "1password"
        ];
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      jacob = import ../../home/jacob-nixos;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
