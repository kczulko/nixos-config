{pkgs,...}:
let

  home-manager = fetchTarball https://github.com/rycee/home-manager/archive/release-20.03.tar.gz;
  secrets = import ./secrets.nix;

in {

  imports = [
    (import "${home-manager}/nixos")
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.karol = {

    description = "Karol Czulkowski";
    uid = 6666;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/karol";
    shell = pkgs.lib.mkForce pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = secrets.users.karol.hashedPassword;
  };

  home-manager.users.karol = {
    programs.zsh = {
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
}
