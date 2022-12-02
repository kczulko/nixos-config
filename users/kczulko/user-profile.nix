{ config, pkgs, lib, latest-nixpkgs, ...}:
let

  customizations = import ./customizations/all.nix { inherit pkgs; };

  # for cisco vpn connection
  # openconnect-sso = import (
    # fetchTarball https://github.com/kczulko/openconnect-sso/archive/955359e8cae79b8db9b6daf08006a2fc1708b554.tar.gz
  # );

  # haskell-language-server = (import (
    # fetchTarball https://github.com/haskell/haskell-language-server/archive/745ef26f406dbdd5e4a538585f8519af9f1ccb09.tar.gz
  # )).defaultPackage.x86_64-linux;

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
    passwordFile = config.age.secrets.kczulko-pass.path;
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
    home.sessionPath = [
      "$HOME/.daml/bin"
    ];
    home.packages = with pkgs; [
      bat
      bloop
      cabal2nix
      calcurse
      customizations.polybar-launcher
      customizations.setup-resolution
      evince
      file
      gnome3.gnome-screenshot
      gscan2pdf
      ispell
      kubectl
      keepassxc
      nix-prefetch-git
      libreoffice
      masterpdfeditor4
      # openconnect-sso
      openjdk
      sbt
      signal-desktop
      slack-dark
      unrar
      latest-nixpkgs.cabal-install
      latest-nixpkgs.ghc
      latest-nixpkgs.haskell-language-server
      latest-nixpkgs.metals
      vlc
      xe-guest-utilities
      zoom-us
    ];

    programs = {
      vscode = {
        enable = true;
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      firefox = {
        enable = true;
        extensions = with config.nur.repos.rycee.firefox-addons; [
          keepassxc-browser
          multi-account-containers
          metamask # for ethereum dapp development
          consent-o-matic # disabling cookie popups
        ];
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
        userEmail =
          let
            email-secret-path = config.age.secrets.kczulko-email.path;
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
        enableAutosuggestions = true;

        # Zsh completions installed for Daml assistant.
        # To use them, add '~/.daml/zsh' to your $fpath, e.g. by adding the following
        # to the beginning of '~/.zshrc' before you call 'compinit':
        # fpath=(~/.daml/zsh $fpath)
        initExtraBeforeCompInit = ''
          fpath=(~/.daml/zsh $fpath)
        '';
        shellAliases = {
          ll = "ls -la";
          # assumes that hostname is the same as flake entry
          rebuild-nixos = "sudo nixos-rebuild switch --flake /home/kczulko/Projects/nixos-config/ --impure";
          restart-xsession = "systemctl --user stop graphical-session.target";
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "docker"
            # "fd"
            "git"
            "kubectl"
            # "ripgrep"
          ];
          theme = "agnoster";
        };
      };
    };
  };
}
