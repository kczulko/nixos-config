# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.copyKernels = true;
  boot.zfs.requestEncryptionCredentials = true;
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelParams = [
    # "i915.enable_psr=0" # https://bbs.archlinux.org/viewtopic.php?id=268244
    # "vfio-pci.ids=8086:a12f,1b21:1242" # usb passthrough for line6 hx stomp xl
    "iommu=pt"
    "intel_iommu=on"
    "vfio-pci.ids=8086:02ed"
  ];

  # virtualisation.docker = {
  #   enable = true;
  #   storageDriver = "zfs";
  # };

  virtualisation.libvirtd = {
    enable = true;
  };
  users.extraGroups.qemu-libvirtd.members = [ "kczulko" ];
  users.extraGroups.libvirtd.members = [ "kczulko" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    useDHCP = false;
    hostId = "ace456ac";
    hostName = "thinkpad";
    interfaces = {

      # enp45s0u2 = {
      #   useDHCP = false;
      #   ipv4.addresses = [{
      #     address = "192.168.56.1";
      #     prefixLength = 24;
      #   }];
      # };
      wlp0s20f3.useDHCP = true;
    };
    networkmanager = {
      unmanaged = [ "wlp0s20f0u3" ];
      enable = true;
    };
    extraHosts = ''
      192.168.0.14 BRW94533072B538.local
      192.168.56.2 raspberypi
    '';
    firewall = {
      # enable = false;
      allowedUDPPorts = [ 1901 ];
      allowedTCPPorts = [ 3500 ];
      # extraPackages = [ pkgs.conntrack-tools ];
      # autoLoadConntrackHelpers = true;
      # extraCommands = ''
      # nfct add helper ssdp inet udp
      # iptables --verbose -I OUTPUT -t raw -p udp --dport 1900 -j CT --helper ssdp
      # '';
      # extraCommands = ''
      # iptables -A FORWARD --in-interface enp45s0u2 -j ACCEPT
      # iptables --table nat -A POSTROUTING --out-interface wlp0s20f3 -j MASQUERADE
      # '';
    };
  };

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

  # services.xserver.desktopManager.gnome.enable = true;
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

