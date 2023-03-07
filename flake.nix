{
  inputs.pnpm2nix.url = "github:nix-community/pnpm2nix";
  inputs.pnpm2nix.flake = false;

  outputs = { nixpkgs, pnpm2nix, ... }: {
    packages.x86_64-linux = rec {
      chatgpt-telegram-bot = let
        # pnpm2nix uses basestring which is only available in Python 2.
        withPython2 = pkgs: x: x // { passthru = (x.passthru or {}) // { inherit (pkgs) python; }; };

        pnpm2nixPkgs = import pnpm2nix rec {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          nodejs = withPython2 pkgs pkgs.nodejs-18_x;
          nodePackages = nodejs.pkgs;
        };
      in
      pnpm2nixPkgs.mkPnpmPackage {
        src = ./.;
        packageJSON = ./package.json;
        pnpmLock = ./pnpm-lock.yaml;
      };

      default = chatgpt-telegram-bot;
    };
  };
}
