# Declarative Cachix

Add [cachix](https://cachix.org/) caches declaratively.

Has two options; a system module and a home-manager module.

### System module

Import `default.nix` into your system configuration.
This adds the top-level `cachix` option, which you can use to add cachix caches.
You can either pass them as names, or as `{name, sha256}` attribute pairs.

Example configuration:
```nix
  {
    imports = [
      (import (builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/FIXME.tar.gz"))
    ];

    cachix = [
      { name = "jmc"; sha256 = "1bk08lvxi41ppvry72y1b9fi7bb6qvsw6bn1ifzsn46s3j0idq0a"; }
      "iohk"
    ];
  }
```

### Home-manager module (not recommended)

The home-manager module is a little bit trickier.
Home-manager does not contain a mechanism for declaratively adding caches like the system config does, so we have to write it ourselves.
The issue is that this means that we take responsibility for generating a well-formed `.config/nix/nix.conf` file.
If this file is malformed, it breaks home-manager itself, so you have to manually delete/fix it and fix your config.
Caveat emptor.

#### Usage

Import `home-manager.nix` into your home-manager configuration.
This adds two user-facing options; `caches.extraCaches` and `caches.cachix`.
There's also `caches.caches`, but you typically don't want to set this manually since it also adds the normal nix hydra.

Example configuration:
```nix
  {
    imports =
      let
        declCachix = builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/FIXME.tar.gz";
      in
      [ (import "${declCachix}/home-manager.nix") ];

    caches.cachix = [
      { name = "jmc"; sha256 = "1bk08lvxi41ppvry72y1b9fi7bb6qvsw6bn1ifzsn46s3j0idq0a"; }
      "iohk"
    ];

    caches.extraCaches = [
      {
        url = "https://hydra.iohk.io";
        key = "hydra.iohk.io:********************************************";
      }
    ];
  }
```
