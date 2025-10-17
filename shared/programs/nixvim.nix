{ inputs
, lib
, config
, pkgs
, ...
}: {
  programs.nixvim = {
    enable = true;

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    globalOpts = {
      number = true;
      relativenumber = true;

      signcolumn = "yes";

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smarttab = true;

      cursorline = true;
    };

    globals.mapleader = " ";

    keymaps = [
      {
        action = "<cmd>Neotree toggle<CR>";
        key = "<leader>e";
      }

      {
        action = "<cmd>lua vim.lsp.buf.format { async=true, filter = function(client) return client.name == \"null-ls\" end }<CR>";
        key = "<C-f>";
        options.desc = "Format with null-ls";
      }

      {
        mode = [ "n" ];
        key = "<C-s>";
        action = ":w<CR>";
        options.desc = "Save file";
      }

      {
        mode = [ "i" ];
        key = "<C-s>";
        action = "<Esc>:w<CR>i";
        options.desc = "Save file";
      }

      {
        mode = [ "v" ];
        key = "<C-s>";
        action = "<Esc>:w<CR>v";
        options.desc = "Save file";
      }

      {
        key = "<C-v>";
        mode = "i";
        action = "<C-r>+";
        options.desc = "Paste from clipboard";
      }

      {
        key = "<C-v>";
        mode = [
          "n"
          "v"
        ];
        action = ''"+p'';
        options.desc = "Paste from clipboard";
      }

      {
        key = "<C-q>";
        mode = [
          "n"
          "i"
          "v"
        ];
        action = "<Esc>:wq<CR>";
        options.desc = "Save and quit";
      }
    ];

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavor = "frappe";
        integrations = {
          notify = true;
          neotree = true;
          treesitter = true;
          treesitter_context = true;
          native_lsp = {
            enabled = true;
            inlay_hints = {
              background = true;
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              information = [ "underline" ];
              warnings = [ "underline" ];
            };
          };
        };
      };
    };

    plugins = {
      # --- not yet available in 24.05 ---
      web-devicons = {
        enable = true;
        settings = {
          strict = true;
          color_icons = true;
          variant = "dark";
        };
      };

      copilot-vim.enable = true;

      #guess-indent = {
      #  enable = true;
      #  settings = {
      #    auto_cmd = true;
      #    on_space_options = {
      #      expandtab = true;
      #      shiftwidth = "detected";
      #      softtabstop = "detected";
      #      tabstop = "detected";
      #    };
      #    on_tab_options = {
      #      expandtab = false;
      #    };
      #  };
      #};

      lualine = {
        enable = true;
      };

      treesitter = {
        enable = true;
      };

      ts-autotag = {
        enable = true;
      };

      # formatting
      none-ls = {
        enable = true;

        # settings = {
        # cmd = [ "zsh -c nvim" ];
        # debug = true;
        # };

        sources = {
          code_actions = {
            statix.enable = true;
            gitsigns.enable = true;
          };

          diagnostics = {
            statix.enable = true;
            deadnix.enable = true;
            pylint.enable = true;
            checkstyle.enable = true;
          };

          formatting = {
            # command = [ "zsh -c nvim" ];
            alejandra.enable = true;
            stylua.enable = true;
            shfmt.enable = true;
            nixpkgs_fmt.enable = true;
            google_java_format.enable = false;
            prettier = {
              enable = true;
              disableTsServerFormatter = true;
            };
            black = {
              enable = true;
              # settings = ''
              #  {
              #    extra_args = { "--fast" },
              #  }
              # '';
            };
            dxfmt = {
              enable = true;
            };
          };

          completion = {
            luasnip.enable = true;
            spell.enable = true;
          };
        };
      };

      notify = {
        enable = true;
        settings = {
          top_down = true;
          fps = 60;
          render = "default";
          timeout = 500;
        };
      };

      persistence.enable = true;

      lint = {
        enable = true;
        lintersByFt = {
          text = [ "vale" ];
          json = [ "jsonlint" ];
          markdown = [ "vale" ];
          rst = [ "vale" ];
          ruby = [ "ruby" ];
          dockerfile = [ "hadolint" ];
          terraform = [ "tflint" ];
        };
      };

      neo-tree = {
        enable = true;
        enableDiagnostics = true;
        enableGitStatus = true;
        enableModifiedMarkers = true;
        enableRefreshOnWrite = true;
        closeIfLastWindow = true;
        popupBorderStyle = "rounded"; # Type: null or one of “NC”, “double”, “none”, “rounded”, “shadow”, “single”, “solid” or raw lua code
        buffers = {
          bindToCwd = false;
          followCurrentFile = {
            enabled = true;
          };
        };
        window = {
          width = 40;
          height = 15;
          autoExpandWidth = false;
          mappings = {
            "<space>" = "none";
          };
        };
      };

      lsp = {
        enable = true;
        # --- not available in 24.05 ---
        # inlayHints = true;
        servers = {
          # Average webdev LSPs
          ts_ls.enable = true; # TS/JS
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          astro.enable = true; # AstroJS
          phpactor.enable = true; # PHP
          svelte.enable = false; # Svelte
          vuels.enable = false; # Vue
          pyright.enable = true; # Python
          marksman.enable = true; # Markdown
          nil_ls.enable = true; # Nix
          dockerls.enable = true; # Docker
          bashls.enable = true; # Bash
          clangd.enable = true; # C/C++
          # csharp_ls not good for darwin
          # csharp_ls.enable = true; # C#
          yamlls.enable = true; # YAML

          lua_ls = {
            # Lua
            enable = true;
            settings.telemetry.enable = false;
          };

          # Rust
          rust_analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
        };
      };

      alpha = {
        enable = true;
        theme = "dashboard";
      };
    };
  };
}
