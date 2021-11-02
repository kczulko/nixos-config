{pkgs,home-manager,...}:
let

  unstable = import (
    fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
    ){ config = { allowUnfree = true; }; };

  secrets = import ../../secrets.nix;

in {

  users.users.ula = {

    description = "ula";
    uid = 6667;
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
    home = "/home/ula";
    shell = pkgs.lib.mkForce pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = secrets.users.ula.hashedPassword;
  };

  home-manager.users.ula = {
    home.file = {
      ".Xresources".source = ../kczulko/config-files/.Xresources;
      ".config/alacritty/alacritty.yml".source = ../kczulko/config-files/.config/alacritty/alacritty.yml;
      ".screenlayout/setup.sh".source = ../kczulko/config-files/.screenlayout/setup.sh;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    home.packages = with pkgs; [
      # customizations.metals
      bat
      calcurse
      evince
      gnome3.gnome-tweak-tool
      gnome3.eog
      gnome3.gnome-screenshot
      gnome3.gnome-session
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gscan2pdf
      unrar
      vlc
    ];

    xsession = {
      enable = true;
      windowManager.command = ''
        gnome-session
      '';
    };
    
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
        userName  = "uullcciiaa";
        userEmail = secrets.users.ula.email;
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
          rebuild-nixos = "sudo nixos-rebuild switch -I nixos-config=/home/ula/Projects/nixos-config/current.nix";
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
