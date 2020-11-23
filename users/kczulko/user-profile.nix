{pkgs,...}:
let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;

  secrets = import ../../secrets.nix;

  customizations = import ./customizations/all.nix { inherit pkgs; };
in {

  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users.kczulko = {

    description = "kczulko";
    uid = 6666;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "docker"
      "scanner"
      "sound"
      "pulse"
      "audio"
      "lp"
    ];
    home = "/home/kczulko";
    shell = pkgs.lib.mkForce pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = secrets.users.kczulko.hashedPassword;
  };

  home-manager.users.kczulko = {
    home.file = {
      ".fehbg".source = ./config-files/.fehbg;
      ".Xresources".source = ./config-files/.Xresources;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/wallpaper.jpg".source = ./config-files/.config/wallpaper.jpg;
      ".config/polybar".source = ./config-files/.config/polybar;
      ".config/nixpkgs/config.nix".source = ./config-files/.config/nixpkgs/config.nix;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    home.packages = with pkgs; [
      customizations.metals
      customizations.polybar-launcher
      sbt
      jdk
      bloop
      gscan2pdf
      citrix_workspace
      xe-guest-utilities
      calcurse
      ghc
      cabal2nix
      cabal-install
      # unstable.haskellPackages.haskell-language-server
      nix-prefetch-git
    ];
    programs = {
      firefox = {
        enable = true;
        profiles = {
          windows = {
            settings = {
              "general.useragent.override" =
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.102 Safari/537.36";
              "browser.startup.homepage" =
                secrets.users.kczulko.homepage;
            };
          };
        };
      };
      git = {
        enable = true;
        userName  = "kczulko";
        userEmail = secrets.users.kczulko.email;
        aliases = {
          co = "checkout";
          ci = "commit";
          br = "branch";
          st = "status";
          hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
          type = "cat-file -t";
          dump = "cat-file -p";
        };
        extraConfig = {
          core = {
            # cat instead of less for git diff
            pager = "cat";
          };
        };
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        shellAliases = {
          ll = "ls -la";
          rebuild-nixos = "sudo nixos-rebuild switch -I nixos-config=/home/kczulko/Projects/nixos-config/virtual-box-configuration.nix";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            # "docker"
            # "fd"
            "git"
            # "kubectl"
            # "ripgrep"
          ];
          theme = "agnoster";
        };
      };
    };
  };
}
