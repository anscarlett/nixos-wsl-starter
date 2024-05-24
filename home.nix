{
  # FIXME: uncomment the next line if you want to reference your GitHub/GitLab access tokens and other secrets
  # secrets,
  config,
  pkgs,
  username,
  nix-index-database,
  ...
}: let
  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    bat
    bottom
    coreutils
    curl
    du-dust
    fd
    findutils
    fx
    git
    git-crypt
    htop
    jq
    killall
    lunarvim
    mosh
    neovim
    procs
    ripgrep
    sd
    tmux
    tree
    unzip
    vim
    wget
    zip
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use

    # key tools
    gh # for bootstrapping
    just

    # core languages
    rustup
    go
    lua
    nodejs
    python3
    typescript

    # rust stuff
    cargo-cache
    cargo-expand

    # local dev stuf
    mkcert
    httpie

    # treesitter
    tree-sitter

    # language servers
    ccls # c / c++
    gopls
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix
    nodePackages.pyright

    # formatters and linters
    alejandra # nix
    black # python
    ruff # python
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    statix # nix
    sqlfluff
    tflint
  ];
in {
  imports = [
    nix-index-database.hmModules.nix-index
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.EDITOR = "lvim";
    # FIXME: set your preferred $SHELL
    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";
  };

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  # FIXME: if you want to version your LunarVim config, add it to the root of this repo and uncomment the next line
  # home.file.".config/lvim/config.lua".source = ./lvim_config.lua;

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    # FIXME: disable this if you don't want to use the starship prompt
    starship.enable = true;
    starship.settings = {
    format = "
[](#9A348E)$os$username[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$gradle$java$nodejs$nim$rust[](fg:#86BBD8 bg:#06969A)$docker_context[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)";
      aws.disabled = true;
      gcloud.disabled = true;
      kubernetes.disabled = true;
      #git_branch.style = "242";
      #directory.style = "blue";
      #directory.truncate_to_repo = false;
      #directory.truncation_length = 8;
      python.disabled = true;
      ruby.disabled = true;
      hostname.ssh_only = false;
      hostname.style = "bold green";
     username = {
    show_always = true;
    style_user = "bg:#9A348E";
    style_root = "bg:#9A348E";
    format = "[$user ]($style)";
    disabled = false;
};
os = {
style = "bg:#9A348E";
disabled = false;
};

directory = {
    style = "bg:#DA627D";
format = "[ $path ]($style)";
truncation_length = 3;
truncation_symbol = "…/";
};

directory.substitutions = {
"Documents" = "󰈙 ";
"Downloads" = " ";
"Music" = " ";
"Pictures" = " ";
};

c = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

docker_context = {
symbol = " ";
style = "bg:#06969A";
format = "[ $symbol $context ]($style)";
};

git_branch = {
symbol = "";
style = "bg:#FCA17D";
format = "[ $symbol $branch ]($style)";
};

git_status = {
style = "bg:#FCA17D";
format = "[$all_status$ahead_behind ]($style)";
};

gradle = {
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

java = {
symbol = " ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

nodejs = {
symbol = "";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

nim = {
symbol = "󰆥 ";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

rust = {
symbol = "";
style = "bg:#86BBD8";
format = "[ $symbol ($version) ]($style)";
};

time = {
disabled = false;
time_format = "%R";
style = "bg:#33658A";
format = "[󰅐 $time ]($style)";
};
    };

    # FIXME: disable whatever you don't want
    fzf.enable = true;
    fzf.enableZshIntegration = true;
    lsd.enable = true;
    lsd.enableAliases = true;
    zoxide.enable = true;
    zoxide.enableZshIntegration = true;
    broot.enable = true;
    broot.enableZshIntegration = true;

    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "anscarlett@gmail.com";
      userName = "anscarlett";
      extraConfig = {
        # FIXME: uncomment the next lines if you want to be able to clone private https repos
        # url = {
        #   "https://oauth2:${secrets.github_token}@github.com" = {
        #     insteadOf = "https://github.com";
        #   };
        #   "https://oauth2:${secrets.gitlab_token}@gitlab.com" = {
        #     insteadOf = "https://gitlab.com";
        #   };
        # };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

    # FIXME: This is my .zshrc - you can fiddle with it if you want
    zsh = {
      enable = true;
      autocd = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = "vicmd";
      history.size = 10000;
      history.save = 10000;
      history.expireDuplicatesFirst = true;
      history.ignoreDups = true;
      history.ignoreSpace = true;
      historySubstringSearch.enable = true;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
shellAliases = {
        "..." = "./..";
        "...." = "././..";
        ll = "ls-al";
        cd = "z";
        gc = "nix-collect-garbage --delete-old";
        refresh = "source ${config.home.homeDirectory}/.zshrc";
        show_path = "echo $PATH | tr ':' '\n'";

        # FIXME: add more git aliases here if you want them
        gapa = "git add --patch";
        grpa = "git reset --patch";
        gst = "git status";
        gdh = "git diff HEAD";
        gp = "git push";
        gph = "git push -u origin HEAD";
        gco = "git checkout";
        gcob = "git checkout -b";
        gcm = "git checkout master";
        gcd = "git checkout develop";

        pbcopy = "/mnt/c/Windows/System32/clip.exe";
        pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
        explorer = "/mnt/c/Windows/explorer.exe";
      };

      envExtra = ''
        export PATH=$PATH:$HOME/.local/bin
      '';

      initExtra = ''
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^e' end-of-line
        bindkey '^w' forward-word
        bindkey "^[[3~" delete-char
        bindkey ";5C" forward-word
        bindkey ";5D" backward-word

        zstyle ':completion:*:*:*:*:*' menu select

        # Complete . and .. special directories
        zstyle ':completion:*' special-dirs true

        zstyle ':completion:*' list-colors ""
        zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

        # disable named-directories autocompletion
        zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

        # Use caching so that commands like apt and dpkg complete are useable
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

        # Don't complete uninteresting users
        zstyle ':completion:*:*:*:users' ignored-patterns \
                adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
                clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
                gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
                ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
                named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
                operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
                rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
                usbmux uucp vcsa wwwrun xfs '_*'
        # ... unless we really want to.
        zstyle '*' single-ignored complete

        # https://thevaluable.dev/zsh-completion-guide-examples/
        zstyle ':completion:*' completer _extensions _complete _approximate
        zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
        zstyle ':completion:*' group-name ""
        zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
        zstyle ':completion:*' squeeze-slashes true
        zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        # mkcd is equivalent to takedir
        function mkcd takedir() {
          mkdir -p $@ && cd ''${@:$#}
        }

        function takeurl() {
          local data thedir
          data="$(mktemp)"
          curl -L "$1" > "$data"
          tar xf "$data"
          thedir="$(tar tf "$data" | head -n 1)"
          rm "$data"
          cd "$thedir"
        }

        function takegit() {
          git clone "$1"
          cd "$(basename ''${1%%.git})"
        }

        function take() {
          if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
            takeurl "$1"
          elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
            takegit "$1"
          else
            takedir "$@"
          fi
        }

        WORDCHARS='*?[]~=&;!#$%^(){}<>'

        # fixes duplication of commands when using tab-completion
        export LANG=C.UTF-8
      '';
    };
  };
}
