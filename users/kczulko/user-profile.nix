{ config, pkgs, lib, latest-nixpkgs, ... }:
let

  customizations = import ./customizations/all.nix { inherit pkgs; };

  # for cisco vpn connection
  # openconnect-sso = import (
  # fetchTarball https://github.com/kczulko/openconnect-sso/archive/955359e8cae79b8db9b6daf08006a2fc1708b554.tar.gz
  # );

in
{

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
      "networkmanager"
    ];
    home = "/home/kczulko";
    shell = pkgs.lib.mkForce pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPasswordFile = config.age.secrets.kczulko-pass.path;
  };

  home-manager.users.kczulko = {

    home.stateVersion = "25.05";

    home.file = {
      ".fehbg".source = ./config-files/.fehbg;
      ".Xresources".source = ./config-files/.Xresources;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/wallpaper.jpg".source = ./config-files/.config/wallpaper.jpg;
      ".config/polybar".source = ./config-files/.config/polybar;
      ".config/nixpkgs/config.nix".source = ./config-files/.config/nixpkgs/config.nix;
      ".config/alacritty/alacritty.toml".source = ./config-files/.config/alacritty/alacritty.toml;
      ".screenlayout/setup.sh".source = ./config-files/.screenlayout/setup.sh;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    # home.sessionPath = [
      # "$HOME/.daml/bin"
    # ];
    home.packages = (with pkgs; [
      argocd
      bat
      cabal2nix
      calcurse
      clipboard-cli
      cntr
      distrobox
      docker-compose
      evince
      # metals_1_0
      # openconnect-sso
      file
      fzf
      gnome-screenshot
      go2tv
      gscan2pdf
      gsts
      htmlq
      i3-battery-popup
      imhex
      ispell
      keepassxc
      kgraphviewer
      kubectl
      kubectx
      libreoffice
      libvirt
      masterpdfeditor4
      mongodb-compass
      nix-prefetch-git
      openjdk
      qemu
      qemu_kvm
      sbt
      slack
      tmux
      unrar
      util-linux
      virt-manager
      vlc
      xe-guest-utilities
      ytmdl
      # zoom-us
    ]) ++ (with latest-nixpkgs; [
      bloop
      cabal-install
      ghc
      haskell-language-server
      metals
      signal-desktop
      zoom-us
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
              # disable AI 'enhancements'...
              "browser.tabs.groups.smart.enabled" = false;
              "browser.ml.chat.enabled" = false;
              # "general.useragent.override" =
              "browser.startup.homepage" = "duckduckgo.com";
              "browser.fullscreen.autohide" = false;
              # enable userChrome
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
              # "ui.systemUsesDarkTheme" = 1;
              "browser.urlbar.showSearchSuggestionsFirst" = false;
            };
            userChrome = ''
              /* Show Bookmarks Toolbar in fullscreen mode */
              #navigator-toolbox[inFullscreen="true"] #PersonalToolbar {
                visibility: unset !important;
              }
            '';
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              keepassxc-browser
              multi-account-containers
              consent-o-matic # disabling cookie popups
            ];
          };
        };
      };
      git = {
        enable = true;
        userName = "kczulko";
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
        autosuggestion.enable = true;
        # enableAutosuggestions = true;

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
        initContent = ''
          unalias gsts
          PROMPT='$(kube_ps1)'$PROMPT
          kubeoff
        '';
        oh-my-zsh = {
          enable = true;
          plugins = [
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
