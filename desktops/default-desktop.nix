{ config, pkgs, ... }:

let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

  in
{
  services.xserver = {
    enable = true;
    layout = "pl";

    displayManager.gdm = {
      enable = true;
    };

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dmenu
        feh
        i3lock
        i3status
        polybarFull
        rofi
      ];
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

  # For checking power status
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanagerapplet # NetworkManager in Gnome
    pavucontrol # PulseAudio Volume Control
    alacritty # fast rust terminal emulator
    arandr # Front End for xrandr
    brightnessctl # Control screen brightness
  ];
}
