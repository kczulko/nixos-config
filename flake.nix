{
  description = "kczulko NixOS configuration";

  inputs = {

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    latest-nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nur.url = "github:nix-community/NUR";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurl = {
      url = "github:nix-community/nurl";
    };

    gsts = {
      url = "github:kczulko/gsts/kczulko/add-nix-flake";
    };
  };

  outputs = inputs: with inputs;
    let
      insecurePkgs = [
        "python-2.7.18.8"
      ];
    in
    flake-utils-plus.lib.mkFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channelsConfig = {
        allowUnfree = true;
        permittedInsecurePackages = insecurePkgs;
      };

      hostDefaults = rec {
        system = "x86_64-linux";
        channelName = "nixpkgs";
        extraArgs = {
          latest-nixpkgs = import latest-nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            config.permittedInsecurePackages = insecurePkgs;
          };

          hmLib = home-manager.lib.hm;

          nurl = nurl.packages.${system}.default;

          inherit nixpkgs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          nur.modules.nixos.default
          agenix.nixosModules.default
          ./secrets/age-secrets.nix
          ./modules/common.nix
          ./modules/default-desktop.nix
          ./modules/dcp-j105.nix
        ];
      };

      sharedOverlays = (import ./overlays { inherit inputs latest-nixpkgs; }) ++ (with inputs; [
        gsts.overlays.x86_64-linux
        agenix.overlays.default
      ]);

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
            (import ./setups "workstation")
            ./users/kczulko/user-profile.nix
          ];
        };
      };
    };
}
