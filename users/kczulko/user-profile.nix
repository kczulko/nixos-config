{pkgs,...}:
let

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  secrets = import ../../secrets.nix;

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
    home.packages = with pkgs; [
      metals
      sbt
      jdk
      bloop
      gscan2pdf
    ];
    programs = {
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
