{
  description = "Jacob Alford's NixOS config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # 1Password shell plugins
    _1password-shell-plugins.url = "github:1Password/shell-plugins";

    # stylix flake
    # stylix.url = "github:danth/stylix";

    # catppuccin flake
    catppuccin.url = "github:catppuccin/nix";

    # nixvim flake

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , catppuccin
    , nixvim
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        nixos = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          # > Our main nixos configuration file <
          modules = [
            catppuccin.nixosModules.catppuccin
            nixvim.nixosModules.nixvim
            ./nixos/configuration.nix
          ];
        };
      };

      ### Commenting out to use as a NixOS module ###

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # homeConfigurations = {
      # FIXME replace with your username@hostname
      # "jacob@nixos" = home-manager.lib.homeManagerConfiguration {
      # pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      # extraSpecialArgs = {inherit inputs outputs;};
      # > Our main home-manager configuration file <
      # modules = [./home-manager/home.nix];
      #};
      #};
    };
}
