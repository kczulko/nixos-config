{pkgs,home-manager,...}:
let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

  secrets = import ../../secrets.nix;

  customizations = import ./customizations/all.nix { inherit pkgs; };

  sbtJava8 = pkgs.sbt.override { jre = pkgs.openjdk8; };
  metalsJava8 = pkgs.metals.override { jdk = pkgs.openjdk8; jre = pkgs.openjdk8; };
# l9zfy-metals-deps-0.10.8':
  # wanted: sha256:11skbg0is1g5i97z6cc4i0qr2wgyj02w7dbv8b04qc4qyqvpwcn5
  # got:    sha256:0vp7d2b7qykiii63k3zkj364x1hn2y6d2jp9klj0xxs3jniy7wrb
# cannot build derivation '/nix/store/dqsbwj5jzmp944xqq6l0axi9d5lyass
  #unstable.metals.override { jdk = pkgs.openjdk8; jre = pkgs.openjdk8; };
  bloopJava8 = pkgs.bloop.override { jre = pkgs.openjdk8; };

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
      ".screenlayout/setup.sh".source = ./config-files/.screenlayout/setup.sh;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    home.packages = with pkgs; [
      # customizations.metals
      bat
      bloopJava8
      cabal2nix
      calcurse
      customizations.polybar-launcher
      customizations.setup-resolution
      evince
      gnome3.gnome-screenshot
      gscan2pdf
      ispell
      metalsJava8
      nix-prefetch-git
      openjdk8
      sbtJava8
      slack-dark
      unrar
      unstable.cabal-install
      unstable.ghc
      unstable.haskell-language-server
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
