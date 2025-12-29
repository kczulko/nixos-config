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
      experimental-features = nix-command flakes
    '';

    registry.nixpkgs.flake = nixpkgs;

    nixPath = [
      "nixpkgs=/etc/channels/nixpkgs"
      "nixos-config=/etc/nixos/configuration.nix"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    settings = {
#      trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
#      substituters = [ "https://cache.iog.io" ];
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
  programs.bash.completion.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

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
    dust
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
      powerOnBoot = true;
      settings = {
        General = {
          # ControllerMode = "dual";
          # FastConnectable = "true";
          # Experimental = "true";
          Enable = "Source,Sink,Media,Socket";
        };
        # Policy = {
          # AutoEnable = "true";
        # };
      };
    };
  };

}
