{ config, pkgs, lib, ... }:

let

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-21.11.tar.gz;

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
      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
          inherit pkgs;
        };
      };
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
    htop
    gnupg
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
    unzip
    wget
  ];

  # Enable CUPS to print documents.
  config.services.printing.enable = true;
  config.services.printing.drivers = [ (pkgs.callPackage ./hardware/others/printer.nix {}) ];
  config.services.avahi.enable = true;
  config.services.avahi.nssmdns = true;

  config.services.blueman.enable = true;  #bluetooth

  # mount mtp devices
  config.services.gvfs.enable = true;

  config.services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;

    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  # Enable sound.
  # config.sound.enable = true;
  config.hardware = {

    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

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
