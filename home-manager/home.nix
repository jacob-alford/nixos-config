# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    inputs._1password-shell-plugins.hmModules.default
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nixvim.homeManagerModules.nixvim
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "jacob";
    homeDirectory = "/home/jacob";
  };

  programs._1password-shell-plugins = {
    enable = true;

    plugins = with pkgs; [ gh ];
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # programs.neovim.defaultEditor = true;

  programs.nixvim = {
    enable = true;

    globalOpts = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;

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
        key = "<leader>ff";
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
          };

          completion = {
            luasnip.enable = true;
            spell.enable = true;
          };
        };
      };

      notify = {
        enable = true;
        fps = 60;
        render = "default";
        timeout = 500;
        topDown = true;
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
        servers = {
          # Average webdev LSPs
          tsserver.enable = true; # TS/JS
          cssls.enable = true; # CSS
          tailwindcss.enable = true; # TailwindCSS
          html.enable = true; # HTML
          astro.enable = true; # AstroJS
          phpactor.enable = true; # PHP
          svelte.enable = false; # Svelte
          vuels.enable = false; # Vue
          pyright.enable = true; # Python
          marksman.enable = true; # Markdown
          nil-ls.enable = true; # Nix
          dockerls.enable = true; # Docker
          bashls.enable = true; # Bash
          clangd.enable = true; # C/C++
          csharp-ls.enable = true; # C#
          yamlls.enable = true; # YAML

          lua-ls = {
            # Lua
            enable = true;
            settings.telemetry.enable = false;
          };

          # Rust
          rust-analyzer = {
            enable = true;
            installRustc = true;
            installCargo = true;
          };
        };
      };

      alpha = {
        enable = true;
        theme = "dashboard";
        iconsEnabled = true;
      };
    };
  };

  home.packages = with pkgs; [
    steam
    protonup
    kitty
    prismlauncher
    discord
    vesktop
    makemkv
  ];

  programs.mangohud = {
    enable = true;
    settings = {
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_load_value = true;
      gpu_fan = true;

      cpu_temp = true;
      cpu_mhz = true;
      cpu_load_value = true;
    };
  };

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Jacob Alford";
    userEmail = "github.scouting378@passmail.net";
    extraConfig = {
      pull = {
        rebase = true;
      };

      core = {
        editor = "nvim";
      };

      push = {
        autoSetupRemote = true;
      };

      gpg = {
        format = "ssh";
      };

      "gpg \"ssh\"" = {
        program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
      };

      commit = {
        gpgsign = true;
      };

      user = {
        signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILWx58wZCH+S3GeV6WIEYl34u5ST3SYnpKZbdN3YLPI";
      };

      credential = {
        "https://github.com" = {
          helper = "!gh auth git-credential";
        };
        "https://gist.github.com" = {
          helper = "!gh auth git-credential";
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
           	  IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      gh = "op plugin run -- gh";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    catppuccin = {
      enable = true;
      flavor = "frappe";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
