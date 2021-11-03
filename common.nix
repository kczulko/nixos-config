{ config, pkgs, lib, ... }:

let

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-21.05.tar.gz;

in
{
  imports = [
    <nixpkgs/nixos/modules/services/hardware/sane_extra_backends/brscan4.nix>
    (import "${home-manager}/nixos")
  ];

  config = {
    nixpkgs.config = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "google-chrome"
        "brscan4"
        "brother-udev-rule-type1"
        "brscan4-etc-files"
        "unrar"
        "slack"
        "zoom"
      ];
    };
  };

  config.nix = {

    # Clean up nix gc
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # direnv "cache" setup
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
  };

  config.i18n.defaultLocale = "en_US.UTF-8";
  config.console = {
    font = "Lat2-Terminus16";
    keyMap = "pl";
  };

  config.programs.bash = {
    enableCompletion = true;
  };

    # Set your time zone.
  config.time.timeZone = "Europe/Warsaw";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  config.environment.systemPackages = with pkgs; [
    alacritty # fast rust terminal emulator
    arandr # Front End for xrandr
    binutils-unwrapped
    brightnessctl # Control screen brightness
    du-dust
    emacs
    fd
    git
    git-crypt
    git-lfs
    lshw
    lsof
    mkpasswd
    networkmanagerapplet # NetworkManager in Gnome
    pavucontrol # PulseAudio Volume Control
    psmisc
    python27
    ranger
    silver-searcher
    vim
    wget
  ];

  # Enable CUPS to print documents.
  config.services.printing.enable = true;
  config.services.printing.drivers = [ (pkgs.callPackage ./hardware/others/printer.nix {}) ];
  config.services.avahi.enable = true;
  config.services.avahi.nssmdns = true;

  # Enable sound.
  config.sound.enable = true;
  config.hardware = {
    pulseaudio.enable = true;

    sane = {
      enable = true;
      brscan4 = {
        enable = true;
        netDevices = {
          home = { model = "DCP-J105"; ip = "192.168.0.14"; };
        };
      };
    };

    printers = {
      ensureDefaultPrinter = "DCP-J105";
      ensurePrinters = [
        {
          name = "DCP-J105";
          description = "Brother DCP-J105";
          deviceUri = "ipp://BRW94533072B538.local:631/ipp/print";
          model = "brother_dcpj105_printer_en.ppd";
        }
      ];
    };
  };

}
