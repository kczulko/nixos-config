# nixos-config
Config for my nixos envs

## Setup:

1. Create `current.nix` link pointing to actual nix configuration.

```bash
ln -sf <path-to-nixos-repo>/<current-hardware-setup.nix> ./current.nix
```

2. Generate `mkpasswd -m sha-512` and put it to secret.nix into project dir:

```bash
cat secrects.nix
{
  users = {
    kczulko = {
      email = "...";
      hashedPassword = "...";
    };
  };
}
```

