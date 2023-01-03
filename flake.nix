{
  description = "kczulko NixOS configuration";

  inputs = {

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = "github:nix-community/NUR";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    daml-mode = {
      url = "github:kczulko/daml-mode-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils-plus/flake-utils";
    };

    nurl = {
      url = "github:nix-community/nurl";
    };
  };

  outputs = inputs: with inputs;
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
      };

      hostDefaults = rec {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = {
          latest-nixpkgs = import latest-nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };

          hmLib = home-manager.lib.hm;

          nurl = nurl.packages.${system}.default;
        };
        modules = [
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          agenix.nixosModule
          ./secrets/age-secrets.nix
          ./modules/common.nix
          ./modules/default-desktop.nix
        ];
      };

      sharedOverlays = import ./overlays { inherit inputs latest-nixpkgs; };

      hosts = {
        thinkpad = {
          modules = [
            nixos-hardware.nixosModules.lenovo-thinkpad-x1
            (import ./setups "thinkpad")
            ./users/kczulko/user-profile.nix
            ./users/ula/user-profile.nix
          ];
        };

        workstation = {
          modules = [
            nixos-hardware.nixosModules.common-cpu-intel
            nixos-hardware.nixosModules.common-gpu-intel
            (import ./setups "workstation")
            ./users/kczulko/user-profile.nix
          ];
        };
      };
    };
}
