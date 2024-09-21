{
  description = "System configuration";


    inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
      home-manager = {
        url = "github:nix-community/home-manager/release-24.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      rust-overlay = {
        url = "github:oxalica/rust-overlay";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=918d8340afd652b011b937d29d5eea0be08467f5";
      # where {version} is the hyprland release version
      # or "github:hyprwm/Hyprland" to follow the development branch

      # hy3 = {
      #   url = "github:outfoxxed/hy3?ref=hl0.41.2"; # where {version} is the hyprland release version
      #   # or "github:outfoxxed/hy3" to follow the development branch.
      #   # (you may encounter issues if you dont do the same for hyprland)
      #   inputs.hyprland.follows = "hyprland";
      # };
    };

    outputs = { nixpkgs, home-manager, rust-overlay, hyprland, ... }: 
    let
      system = "x86_64-linux";
    in {
        nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
              environment.systemPackages = [
                (pkgs.rust-bin.stable.latest.default.override {
                  extensions = [
                    "rust-src"
                    "rust-analyzer"
                  ];
                })
              ];
            })
          ];
        };

        homeConfigurations.fert = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [
            hyprland.homeManagerModules.default

            {
              wayland.windowManager.hyprland = {
                enable = true;
                # portalPackage = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
                # plugins = [ hy3.packages.${system}.hy3 ];
              };
            }

            ./home.nix
          ];
        };
    };
}
