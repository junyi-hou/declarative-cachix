{
  description = "Use cachix declaratively";

  output = { self }: {
    homeManagerModule = { config, lib, ... }: {
      declarativeCachix = import ./default.nix config lib;
    };
  };
}
