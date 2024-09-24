{ pkgs, config, latest-nixpkgs, nixpkgs, lib, nurl, ... }:
let

  recent-qmk-udev-rules = pkgs.qmk-udev-rules.overrideAttrs (final: prev: {
    src = pkgs.fetchFromGitHub {
      owner = "qmk";
      repo = "qmk_firmware";
      rev = "ff73cb6290271db473899118200a2fbf725cbc85";
      sha256 = "sha256-n1m7thUYLVyP9Aqk8vUmY35ecYNoxJ/VSbiVXTh/crw=";
    };
  });

in
{

  nix = {
    # package = latest-nixpkgs.nix;

    # Clean up nix gc
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # direnv "cache" setup + flakes enabled
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '' + pkgs.lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";

    registry.nixpkgs.flake = nixpkgs;

    nixPath = [
      "nixpkgs=/etc/channels/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    settings = {
      trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
      substituters = [ "https://cache.iog.io" ];
    };

  };

  environment.etc."channels/nixpkgs".source = nixpkgs.outPath;

  # Ensure Home Manager plays well with flakes
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console.font = "Lat2-Terminus16";
  console.keyMap = "pl";

  # programs.nix-ld.enable = true;
  programs.bash = {
    enableCompletion = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    agenix
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
    pciutils
    mkpasswd
    multimarkdown
    networkmanagerapplet # NetworkManager in Gnome
    pavucontrol # PulseAudio Volume Control
    psmisc
    python27
    ranger
    silver-searcher
    tree
    usbutils
    vim
    unzip
    wget
    qmk
    nurl
  ];

  networking.nameservers = [
    # Cloudflare
    "1.1.1.1"
    "1.0.0.1"
    # Gevil
    "9.9.9.9"
  ];
  networking.networkmanager.dns = pkgs.lib.mkForce "none";

  services.udev.packages = [ recent-qmk-udev-rules ];

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ (pkgs.callPackage ../pkgs/dcpj105-printer.nix { }) ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  services.blueman.enable = true; # bluetooth

  # mount mtp devices
  services.gvfs.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

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
