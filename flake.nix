{
  description = "My Home Manager configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, ...} @ inputs: let
    inherit (self) outputs;
    lib = inputs.nixpkgs.lib // inputs.home-manager.lib;

    forEachSystem = f: lib.genAttrs (import inputs.systems) (system: f pkgsFor.${system});

    pkgsFor = lib.genAttrs (import inputs.systems) (
      system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
    );

    configureHome = hostname: system:
      inputs.home-manager.lib.homeManagerConfiguration {
        modules = [
          ./configs/${hostname}.nix
          ./options.nix
        ];
        pkgs = pkgsFor.${system};
        extraSpecialArgs = {
          inherit inputs outputs;
        };
      };
  in {
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    homeConfigurations = {
      "kamil@kiri" = configureHome "kiri" "x86_64-linux";
    };
  };
}
