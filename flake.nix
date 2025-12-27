{
  description = "Omixos, minimalistic Nixos";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Note: Currently pinned to 25.11
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager-master.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";


    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    system = "x86_64-linux";
    forAllSystems = nixpkgs.lib.genAttrs systems;
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {

      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; 

        modules = [
	  ./users
        ];
      };
    };
  };
}
