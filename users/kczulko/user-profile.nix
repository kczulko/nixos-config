{pkgs,...}:
let

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  secrets = import ../../secrets.nix;

  customizations = import ./customizations/all.nix { inherit pkgs; };
in {

  imports = [
    (import "${home-manager}/nixos")
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
      ".Xresources".source = ./config-files/.Xresources;
    };
    home.sessionVariables = {
      TERM = "xterm-256color";
    };
    home.packages = with pkgs; [
      metals
      sbt
      jdk
      bloop
      gscan2pdf
      citrix_workspace
      xe-guest-utilities
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
      };
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        shellAliases = {
          ll = "ls -la";
          # define in following way:
          # some-value = "<your-command>"
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
