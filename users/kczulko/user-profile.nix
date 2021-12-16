{pkgs,home-manager,...}:
let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
  ){ config = { allowUnfree = true; }; };

  secrets        = (import ../../secrets.nix).users.kczulko;
  customizations = import ./customizations/all.nix { inherit pkgs; };

  # for cisco vpn connection
  openconnect-sso = import (
    fetchTarball https://github.com/kczulko/openconnect-sso/archive/955359e8cae79b8db9b6daf08006a2fc1708b554.tar.gz
  );

  haskell-language-server = (import (
    fetchTarball https://github.com/haskell/haskell-language-server/archive/745ef26f406dbdd5e4a538585f8519af9f1ccb09.tar.gz
  )).defaultPackage.x86_64-linux;

in {

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
    hashedPassword = secrets.hashedPassword;
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
      ".screenlayout/setup.sh".source = ./config-files/.screenlayout/setup.sh;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    home.packages = with pkgs; [
      bat
      bloop
      cabal2nix
      calcurse
      customizations.polybar-launcher
      customizations.setup-resolution
      evince
      gnome3.gnome-screenshot
      gscan2pdf
      ispell
      nix-prefetch-git
      libreoffice
      openconnect-sso
      openjdk
      sbt
      signal-desktop
      slack-dark
      unrar
      unstable.cabal-install
      unstable.ghc
      haskell-language-server
      unstable.metals
      vlc
      xe-guest-utilities
      zoom-us
    ];

    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox = {
        enable = true;
        profiles = {
          default = {
            settings = {
              # "general.useragent.override" =
              "browser.startup.homepage" = "duckduckgo.com";
              "browser.fullscreen.autohide" = false;
              # enable userChrome
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
            userChrome = ''
               /* Show Bookmarks Toolbar in fullscreen mode */
               #navigator-toolbox[inFullscreen="true"] #PersonalToolbar {
                 visibility: unset !important;
               }
            '';
          };
        };
      };
      git = {
        enable = true;
        userName  = "kczulko";
        userEmail = secrets.email;
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
          "filter \"lfs\"" = {
            process = "git-lfs filter-process";
            required = true;
            clean = "git-lfs clean -- %f";
            smudge = "git-lfs smudge -- %f";
          };
        };
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        shellAliases = {
          ll = "ls -la";
          rebuild-nixos = "sudo nixos-rebuild switch -I nixos-config=/home/kczulko/Projects/nixos-config/current.nix";
          restart-xsession = "systemctl --user stop graphical-session.target";
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
