{ pkgs, config, lib, hmLib, latest-nixpkgs, ... }:
let

  setup-resolution = import ../kczulko/customizations/setup-resolution.nix { pkgs = pkgs; };

in
{

  # for now it probably works without that
  # services.dbus.packages = [ pkgs.gnome3.dconf ];
  # services.udev.packages = [ pkgs.gnome3.gnome-settings-deamon ];

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
    hashedPasswordFile = config.age.secrets.ula-pass.path;
  };

  home-manager.users.ula = {

    services.udiskie.enable = true;

    home = {

      stateVersion = "24.11";

      file = {
        ".Xresources".source = ../kczulko/config-files/.Xresources;
        ".screenlayout/setup.sh".source = ../kczulko/config-files/.screenlayout/setup.sh;
        ".config/alacritty/alacritty.yml".source = ../kczulko/config-files/.config/alacritty/alacritty.yml;
        ".config/autostart/setup-resolution.desktop".source = ./config-files/.config/autostart/setup-resolution.desktop;
        ".config/wallpaper.png".source = ./config-files/wallpaper.png;
      };
      sessionVariables = {
        TERM = "xterm-256color";
      };
      packages = with pkgs; [
        bat
        calcurse
        evince
        google-chrome
        gedit
        gnomeExtensions.appindicator
        gnomeExtensions.dash-to-dock
        gscan2pdf
        libreoffice
        librecad
        setup-resolution
        unrar
        vlc
        wine
        xournalpp
      ] + (with pkgs.gnome; [
        gnome-control-center
        gnome-tweaks
        eog
        gnome-screenshot
        gnome-session
        nautilus
      ]);
    };

    xsession = {
      enable = true;
      windowManager.command = ''
        gnome-session
        setup-resolution
      '';
    };

    dconf.settings = {
      "org/gnome/desktop/peripherals/mouse" = {
        "natural-scroll" = false;
        "speed" = -0.5;
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        "tap-to-click" = true;
        "two-finger-scrolling-enabled" = true;
      };

      "org/gnome/desktop/input-sources" = {
        "current" = "uint32 0";
        "sources" = [ (hmLib.gvariant.mkTuple [ "xkb" "pl" ]) ];
        "xkb-options" = [ "terminate:ctrl_alt_bksp" "lv3:ralt_switch" "caps:ctrl_modifier" ];
      };

      "org/gnome/desktop/background" = {
        "picture-uri" = "file:///home/ula/.config/wallpaper.png";
      };

      "org/gnome/desktop/screensaver" = {
        "picture-uri" = "file:///home/ula/.config/wallpaper.png";
      };
    };

    programs = {
      #      autorandr = {
      #        enable = true;
      #        hooks = {
      #          postswitch = {
      #            "setup-resolution" = builtins.readFile ../kczulko/config-files/.screenlayout/setup.sh;
      #          };
      #        };
      #      };
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
        userName = "uullcciiaa";
        userEmail =
          let
            email-secret-path = config.age.secrets.ula-email.path;
          in
          lib.strings.optionalString (lib.pathExists email-secret-path)
            (lib.readFile email-secret-path);
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
        autosuggestion.enable = true;
        # enableAutosuggestions = true;
        shellAliases = {
          ll = "ls -la";
          rebuild-nixos = "sudo nixos-rebuild switch -I nixos-config=/home/ula/Projects/nixos-config/current.nix";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" ];
          theme = "agnoster";
        };
      };
    };
  };
}
