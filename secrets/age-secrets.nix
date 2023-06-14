{
  age = {
    secrets = {
      kczulko-pass.file = ./kczulko-pass.age;
      ula-pass.file = ./ula-pass.age;
      kczulko-email.file = ./kczulko-email.age;
      ula-email.file = ./ula-email.age;
      vpn-config.file = ./vpn-config.age;
      vpn-pem-passwd.file = ./vpn-pem-passwd.age;
      vpn-user.file = ./vpn-user.age;
    };

    identityPaths = [ "/root/.ssh/id_ed25519" ];
  };
}

