{ config, pkgs, ... }:

let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

in {
  services = {
    # For checking power status
    upower.enable = true;

    xserver = {
      enable = true;
      layout = "pl";

      displayManager.gdm.enable = true;

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu
          feh
          i3lock-pixeled-fixed
          i3status
          polybarFull
          rofi
        ];
      };
    };
  };

  fonts.fonts = with pkgs; [
    font-awesome_4
    terminus_font
    powerline-fonts
    (unstable.nerdfonts.override {
      fonts = ["Hack"];
    })
  ];

}
