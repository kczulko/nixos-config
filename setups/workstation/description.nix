{ config, pkgs, ... }:
{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.copyKernels = true;
  boot.kernelParams = [
    # "i915.enable_psr=0" # https://bbs.archlinux.org/viewtopic.php?id=268244
    # "vfio-pci.ids=8086:a12f,1b21:1242" # usb passthrough for line6 hx stomp xl
  ];
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.zfs.requestEncryptionCredentials = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  # package marked as broken!
  # boot.extraModulePackages = with config.boot.kernelPackages; [ rtl88xxau-aircrack ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "zfs";
  };

  virtualisation.libvirtd = {
    enable = true;
  };
  users.extraGroups.qemu-libvirtd.members = [ "kczulko" ];
  users.extraGroups.libvirtd.members = [ "kczulko" ];

  # enable virtualisation

  # users.extraGroups.vboxusers.members = [ "kczulko" ];
  # virtualisation.virtualbox = {
  #   host = {
  #     enable = true;
  #     enableExtensionPack = true;
  #   };
  #   guest = {
  #     enable = true;
  #     x11 = true;
  #   };
  # };

  networking = {

    useDHCP = false;
    interfaces = {
      # enp2s0.useDHCP = true;
      # wlp9s0.useDHCP = true;
      enp2s0.ipv4.addresses = [{
        address = "192.168.56.1";
        prefixLength = 24;
      }];
    };

    # required by zfs
    hostId = "acef45ac";
    hostName = "workstation";
    wireless.interfaces = [ "wlp9s0" ];
    # Network (Wireless and cord)
    networkmanager = {
      enable = true;
      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    # printer and raspberry
    extraHosts = ''
      192.168.0.14 BRW94533072B538.local
      192.168.56.2 raspberrypi
    '';

    firewall = {
      extraCommands = ''
        iptables -A FORWARD --in-interface enp2s0 -j ACCEPT
        iptables --table nat -A POSTROUTING --out-interface wlp9s0 -j MASQUERADE
      '';
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.gvfs.enable = true;

  services.tailscale.enable = true;

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 4;
    hourly = 6;
    daily = 3;
    weekly = 1;
    monthly = 1;
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
