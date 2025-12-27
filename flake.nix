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
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;

    nixosModules = {
      default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [
            ./modules/nixos/default.nix
          ];

          options.omarchy = (import ./config.nix lib).omarchyOptions;
          config = {
            nixpkgs.config.allowUnfree = true;
          };
        };
    };

    homeManagerModules = {
      default =
        {
          config,
          lib,
          pkgs,
          osConfig ? { },
          ...
        }:
        {
          imports = [
            nix-colors.homeManagerModules.default
            ./modules/home-manager/default.nix
          ];
          options.omarchy = (import ./config.nix lib).omarchyOptions;
          config = lib.mkIf (osConfig ? omarchy) {
            omarchy = lib.mkDefault osConfig.omarchy;
          };
        };
    };

    overlays = import ./overlays {inherit inputs;};
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
