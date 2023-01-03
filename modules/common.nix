{ pkgs, config, lib, nurl, ... }:
let

  recent-qmk-udev-rules = pkgs.qmk-udev-rules.overrideAttrs (final: prev: {
    src = pkgs.fetchFromGitHub {
      owner = "qmk";
      repo = "qmk_firmware";
      rev = "ff73cb6290271db473899118200a2fbf725cbc85";
      sha256 = "sha256-n1m7thUYLVyP9Aqk8vUmY35ecYNoxJ/VSbiVXTh/crw=";
    };
  });

in {

  nix = {
    package = pkgs.nixFlakes;

    # direnv "cache" setup + flakes enabled
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '' + pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
           "experimental-features = nix-command flakes";
  };

  # Ensure Home Manager plays well with flakes
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  nix = {

    # Clean up nix gc
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "pl";

  programs.bash = {
    enableCompletion = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alacritty # fast rust terminal emulator
    arandr # Front End for xrandr
    binutils-unwrapped
    brightnessctl # Control screen brightness
    du-dust
    emacs-kczulko
    fd
    git
    git-crypt
    git-lfs
    htop
    gnupg
    lshw
    lsof
    mkpasswd
    multimarkdown
    networkmanagerapplet # NetworkManager in Gnome
    pavucontrol # PulseAudio Volume Control
    psmisc
    python27
    ranger
    silver-searcher
    usbutils
    vim
    unzip
    wget
    qmk
    nurl
  ];

  services.udev.packages = [ recent-qmk-udev-rules ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ (pkgs.callPackage ../pkgs/dcpj105-printer.nix {}) ];
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  services.blueman.enable = true;  # bluetooth

  # mount mtp devices
  services.gvfs.enable = true;

  services.pipewire = {
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
  hardware = {

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
          deviceUri = "dnssd://Brother%20DCP-J105._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-94533072b538";
          model = "brother_dcpj105_printer_en.ppd";
        }
      ];
    };
  };

}
