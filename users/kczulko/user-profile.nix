{pkgs,...}:
let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-21.05.tar.gz;

  secrets = import ../../secrets.nix;

  # configJava8 = {
  #   packageOverrides = pkgs: rec {
  #     jdk = pkgs.openjdk8;
  #     jre = pkgs.openjdk8;
  #   };
  # };

  # pkgs = import <nixpkgs> { inherit configJava8; };

  customizations = import ./customizations/all.nix { inherit pkgs; };

  sbtJava8 = pkgs.sbt.override { jre = pkgs.openjdk8; };
  metalsJava8 = unstable.metals.override { jdk = pkgs.openjdk8; jre = pkgs.openjdk8; };
  bloopJava8 = pkgs.bloop.override { jre = pkgs.openjdk8; };
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
      # customizations.metals
      metalsJava8
      customizations.polybar-launcher
      sbtJava8
      openjdk8
      bloopJava8
      gscan2pdf
      xe-guest-utilities
      calcurse
      ghc
      cabal2nix
      cabal-install
      # unstable.haskell-language-server
      nix-prefetch-git
      evince
      unrar
    ];
    programs = {
      firefox = {
        enable = true;
        profiles = {
          default = {
            settings = {
              # "general.useragent.override" =
              "browser.startup.homepage" = "duckduckgo.com";
              "browser.fullscreen.autohide" = false;
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
          init = {
            defaultBranch = "master";
          };
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
          rebuild-nixos = "sudo nixos-rebuild switch -I nixos-config=/home/kczulko/Projects/nixos-config/current.nix";
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
