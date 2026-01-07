{
  description = "Development Environment Packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = function: nixpkgs.lib.genAttrs supportedSystems (system:
      function nixpkgs.legacyPackages.${system}
    );
  in {
    packages = forAllSystems (pkgs: let
      nvim = pkgs.neovim.override {
        configure = {
          packages.myPlugins = {
            start = with pkgs.vimPlugins; [
              lazy-nvim
              nvim-treesitter.withAllGrammars
            ];
          };
          customRC = ''
            lua << EOF
              vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")
              vim.opt.rtp:prepend(vim.fn.stdpath("config"))
              local user_init = vim.fn.stdpath("config") .. "/init.lua"
              if vim.fn.filereadable(user_init) == 1 then
                dofile(user_init)
              end
            EOF
          '';
        };
      };
    in {
      default = pkgs.buildEnv {
        name = "dev-env-packages";
        paths = with pkgs; [
          nvim
          lua
          lua-language-server
          stylua
          gcc
          clang-tools
          python3
          pyright
          ruff
          black
          nodejs
          typescript
          typescript-language-server
          nodePackages.prettier
          cmake
          gnumake
          go
          perl
          ripgrep
          fzf
          jq
          htop
          openssh
          tmux
        ];
      };
    });
  };
}
