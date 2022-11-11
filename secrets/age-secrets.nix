{
  age = {
    secrets = {
      kczulko-pass.file = ./kczulko-pass.age;
      ula-pass.file = ./ula-pass.age;
      kczulko-email.file = ./kczulko-email.age;
      ula-email.file = ./ula-email.age;
    };

    identityPaths = [ "/root/.ssh/id_ed25519" ];
  };
}

