{
  age = {
    secrets = {
      kczulko-pass.file = ./kczulko-pass.age;
      ula-pass.file = ./ula-pass.age;
      kczulko-email.file = ./kczulko-email.age;
      ula-email.file = ./ula-email.age;
    };

    # requires --impure evaluation mode
    # otherwise pathExists returns false
    identityPaths = builtins.filter builtins.pathExists [
      "/root/.ssh/id_ed25519"
      "/home/kczulko/.ssh/id_ed25519"
    ];
  };
}

