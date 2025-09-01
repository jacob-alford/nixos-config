{
  description = "Jacob Alford's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    catppuccin.url = "github:catppuccin/nix";

    nixvim.url = "github:nix-community/nixvim/nixos-25.05";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , catppuccin
    , nixvim
    , home-manager
    , sops-nix
    , nix-darwin
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

          modules = [
            home-manager.nixosModules.home-manager
            catppuccin.nixosModules.catppuccin
            nixvim.nixosModules.nixvim
            ./hosts/nixos
            sops-nix.nixosModules.sops
          ];
        };

        augustus = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/augustus
            sops-nix.nixosModules.sops
            nixvim.nixosModules.nixvim
          ];
        };
      };

      darwinConfigurations = {
        mini = nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs outputs;
          };

          modules = [
            ./hosts/mini
            sops-nix.darwinModules.sops
            nixvim.nixDarwinModules.nixvim
          ];
        };
      };

      # home-manager --flake .#jacob@nixos
      homeConfigurations = {
        "jacob@nixos" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
          };
          modules = [
            ./home/jacob-nixos
          ];
        };
      };
    };
}
