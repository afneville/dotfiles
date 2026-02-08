{
  description = "Development Environment Packages";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }: let
    supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = packageBuilder: nixpkgs.lib.genAttrs supportedSystems (system:
      packageBuilder (import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      })
    );
  in {
    packages = forAllSystems (pkgs: let
      treesitter-parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
      nvim = pkgs.neovim.override {
        configure = {
          packages.myPlugins = {
            start = with pkgs.vimPlugins; [
              lazy-nvim
              nvim-treesitter
              treesitter-parsers
            ];
          }; customRC = ''
            lua << EOF
              vim.opt.rtp:prepend("${pkgs.vimPlugins.nvim-treesitter}/runtime")
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
          stow
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
          terraform
          awscli2
          xdg-user-dirs
          qemu
          ansible
        ];
      };
    });
  };
}
