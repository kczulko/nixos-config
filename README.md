# kczulko nixos-config

Config for my [NixOS](www.nixos.org) setups.

## Deployment steps

All steps executed as `root`.

```
$ ####################
$ # clone nixos project
$ git clone git@github.com:kczulko/nixos-config.git
$ ####################
$ # upload private key and place it under /root/.ssh
$ mv id_ed25519 /root/.ssh/
$ ####################
$ # build configuration by choosing appropriate setup, e.g. workstation:
$ nixos-rebuild switch --flake ./nixos-config#workstation --impure
```

## Secrets management

This repository is using [`agenix`](www.github.com/rynantm/agenix) for secrets management.

In order to add a new secret use [this guideline](https://github.com/ryantm/agenix/blob/a630400067c6d03c9b3e0455347dc8559db14288/README.md#tutorial) 
from `agenix` repository.

For hashed user password generation, please use following command: `mkpasswd -m sha-512`.

## Shenanigans

There are some issues when obtaining `agenix` secret for an entry which is not a file. Pure mode flakes evaluation
does not allow to e.g. check for OS paths existence, so e.g. `builtins.pathExists` evaluates to `false` for a pure mode.
This is in general the reason why `--impure` is used here. Moreover, adding new secret and assigning it to a `string`
field, may throw an error due to absence of a newly added secret file. Therefore following guards were added:

```nix
let
  new-secret-path = config.age.secrets.your-new-secret.path;
in
  lib.strings.optionalString (lib.pathExists new-secret-path)
    (lib.readFile new-secret-path)
```

which for initial evaluation returns an empty string (when path does not exist). It means that while introducing
new secret, one may have to run `nixos-rebuild ...` twice... (sic!). Maybe [this](https://github.com/jordanisaacs/homeage) project may help here.

## Inspiration intensifies

Jack of all trades, master of some: https://github.com/AleksanderGondek/nixos-config
