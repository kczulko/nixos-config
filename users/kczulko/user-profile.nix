{ config, pkgs, lib, latest-nixpkgs, ...}:
let

  customizations = import ./customizations/all.nix { inherit pkgs; };

  # for cisco vpn connection
  # openconnect-sso = import (
    # fetchTarball https://github.com/kczulko/openconnect-sso/archive/955359e8cae79b8db9b6daf08006a2fc1708b554.tar.gz
  # );

in {

  programs.zsh.enable = true;

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
      # "networkmanager"
    ];
    home = "/home/kczulko";
    shell = pkgs.lib.mkForce pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    passwordFile = config.age.secrets.kczulko-pass.path;
  };

  home-manager.users.kczulko = {

    home.stateVersion = "23.05";

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
    home.packages = (with pkgs; [
      argocd
      bat
      cabal2nix
      calcurse
      docker-compose
      evince
      file
      fzf
      gnome3.gnome-screenshot
      gscan2pdf
      gsts
      ispell
      kubectl
      kubectx
      keepassxc
      nix-prefetch-git
      libreoffice
      masterpdfeditor4
      mongodb-compass
      i3-battery-popup
      # openconnect-sso
      openjdk
      vpn-connect
      sbt
      signal-desktop
      slack-dark
      unrar
      vlc
      xe-guest-utilities
      zoom-us
    ]) ++ (with latest-nixpkgs; [
      bloop
      cabal-install
      ghc
      haskell-language-server
      metals
    ]) ++ (with customizations; [
      polybar-launcher
      setup-resolution
    ]);

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
              # "ui.systemUsesDarkTheme" = 1;
            };
            userChrome = ''
              /* Show Bookmarks Toolbar in fullscreen mode */
              #navigator-toolbox[inFullscreen="true"] #PersonalToolbar {
                visibility: unset !important;
              }
            '';
            extensions = with config.nur.repos.rycee.firefox-addons; [
              keepassxc-browser
              multi-account-containers
              metamask # for ethereum dapp development
              consent-o-matic # disabling cookie popups
            ];
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
        # initExtraBeforeCompInit = ''
          # fpath=(~/.daml/zsh $fpath)
        # '';
        shellAliases = {
          ll = "ls -la";
          # assumes that hostname is the same as flake entry
          rebuild-nixos = "sudo nixos-rebuild switch --flake /home/kczulko/Projects/nixos-config/ --impure";
          restart-xsession = "systemctl --user stop graphical-session.target";
          kcx = "kubectx";
          kns = "kubens";
        };
        sessionVariables = {
          KUBE_EDITOR = "$(which emacs)";
        };
        initExtra = ''
          unalias gsts
          PROMPT='$(kube_ps1)'$PROMPT
          kubeoff
        '';
        oh-my-zsh = {
          enable = true;
          plugins = [
            "ag"
            "bazel"
            "docker"
            "fzf"
            "git"
            "kube-ps1"
            "kubectl"
            "kubectx"
          ];
          theme = "agnoster";
        };
      };
    };
  };
}
