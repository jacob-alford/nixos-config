{
  description = "Jacob Alford's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # TODO: Update Nix-Darwin to 25.11
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Update Catppuccin to 25.11
    catppuccin.url = "github:catppuccin/nix/release-25.05";

    nixvim.url = "github:nix-community/nixvim/nixos-25.11";

    affinity-nix.url = "github:mrshmllow/affinity-nix";

    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
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
    , affinity-nix
    , quadlet-nix
    , nix-minecraft
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      eachSystem = f:
        nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devshells = eachSystem (pkgs: {
        default = {
          commands = [
            {
              name = "remote-build-cicero";
              help = "Rebuild Cicero over ssh";
              command = "nixos-rebuild --taret-host jacob@cicero.neko-bicolor.ts.net";
            }
            {
              name = "remote-build-augustus";
              help = "Rebuild Augustus over ssh";
              command = "nixos-rebuild --taret-host jacob@augustus.neko-bicolor.ts.net";
            }
          ];
        };
      });

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

            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/augustus
            sops-nix.nixosModules.sops
            nixvim.nixosModules.nixvim
            quadlet-nix.nixosModules.quadlet
            nix-minecraft.nixosModules.minecraft-servers
            {
              nixpkgs.overlays = [ nix-minecraft.overlay ];
            }
          ];
        };

        cicero = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;

            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/cicero
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
            pkgs-unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [
            ./home/jacob-nixos
          ];
        };

        "jacob@augustus" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
          };
          modules = [
            ./home/jacob-augustus
          ];
        };

        "jacob@cicero" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs outputs;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
          };
          modules = [
            ./home/jacob-cicero
          ];
        };
      };
    };
}
