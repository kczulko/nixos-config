{ config, pkgs, latest-nixpkgs, ... }:
{
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
          i3status
          (pkgs.callPackage ../pkgs/i3-lock-pixeled.nix {})
          polybarFull
          rofi
        ];
      };
    };
  };

  fonts.packages = with pkgs; [
    font-awesome_4
    terminus_font
    powerline-fonts
    (latest-nixpkgs.nerdfonts.override {
      fonts = ["Hack"];
    })
  ];

}
