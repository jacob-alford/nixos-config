{
  description = "Jacob Alford's NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nixpkgs unstable
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # SOPS-Nix
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # 1Password shell plugins
    # _1password-shell-plugins.url = "github:1Password/shell-plugins";

    # stylix flake
    # stylix.url = "github:danth/stylix";

    # catppuccin flake
    catppuccin.url = "github:catppuccin/nix";

    # nixvim flake
    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , catppuccin
    , nixvim
    , home-manager
    , sops-nix
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      # nixos-rebuild --flake .#nixos
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;

            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };

          # > Our main nixos configuration file <
          modules = [
            catppuccin.nixosModules.catppuccin
            nixvim.nixosModules.nixvim
            ./hosts/nixos
            sops-nix.nixosModules.sops
          ];
        };
      };

      # home-manager --flake .#jacob@nixos
      homeConfigurations = {
        "jacob@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; 
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home/jacob-nixos ];
        };
      };
    };
}
