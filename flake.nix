{
  description = "kczulko NixOS configuration";

  inputs = {
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";

    agenix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs: with inputs;
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
      };

      hostDefaults = {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = {
          latest-nixpkgs = import latest-nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };

          hmLib = home-manager.lib.hm;
        };
        modules = [
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          agenix.nixosModule
          ./secrets/age-secrets.nix
          ./common.nix
        ];
      };

      hosts.thinkpad = {
        modules = [
          nixos-hardware.nixosModules.lenovo-thinkpad-x1
          ./hardware/thinkpad.nix
          ./desktops/default-desktop.nix
          ./users/kczulko/user-profile.nix
          ./users/ula/user-profile.nix
          ./thinkpad.nix
        ];
      };
    };
}
