{ config, pkgs, ... }:

{
  home.username = "fred";
  home.homeDirectory = "/home/fred";

  # set cursor size and dpi for 4k monitor
  # xresources.properties = {
  #   "Xcursor.size" = 16;
  #   "Xft.dpi" = 172;
  # };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processer https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    bat # rust replacement for cat
    zoxide # rust replacment for cd

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # misc
    which
    tree
    jq

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system tools
    pciutils # lspci
    usbutils # lsusb
    
    # screenshots
    grimblast
    grim
    slurp

    #Fonts
    jetbrains-mono
    nerdfonts

    # Window manager helpers
    # wofi
    fuzzel
    waybar
    mako
    ags
    # xdg-desktop-portal-hyprland
    # adding this for zed ability to open browser
    # xdg-desktop-portal-gtk

    # Applications
    obsidian
    bitwarden-cli
    todoist
    discord

    # Development stuff
    rustup
    python3
    pkg-config
    openssl
    openssl.dev
    sqlite
    gh
    unityhub
    # Haskell
    ghc
    cabal-install
    haskell-language-server
    haskellPackages.hlint

    # AI
    ollama

    # Web
    zola
  ];

  # programs.ags = {
  #   enable = true;
  #   configDir = ../ags;
  #   extraPackages = with pkgs; [
  #     gtksourceview
  #     webkitgtk
  #     accountsservice
  #   ];
  # };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Fred Hsu";
    userEmail = "fredlhsu@gmail.com";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      LazyVim
    ];
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    settings = {
      aws.disabled = true;
      gcloud.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        normal  = {
          family = "JetBrains Mono";
	};
        size = 12;
      };
      shell.program = "/etc/profiles/per-user/fred/bin/fish";
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.fish = {
    enable = true;
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  wayland.windowManager.hyprland = {
  	enable = true;
	xwayland.enable = true;
	systemd.enable = true;
  };

  # home.nix
  wayland.windowManager.hyprland.settings = {
      "monitor" = "eDP-1, preferred, auto, 1.6";
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      input = {
        "kb_options" = "ctrl:nocaps";
      };
      bind =
        [
          "$mod, F, exec, firefox"
          "$mod, Return, exec, alacritty"
          "$mod, space, exec, fuzzel"
	  ", Print, exec, grimblast copy area"
	  "$mod, c, closewindow"
	]
        ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
	    x: let
	      ws = let
	        c = (x + 1) / 10;
	      in
                builtins.toString (x + 1 - (c * 10));
            in [
              "$mod, ${ws}, workspace, ${toString (x + 1)}"
	      "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
	  10)
	);
    };
  wayland.windowManager.hyprland.extraConfig = "
  exec-once = waybar
  exec-once = mako
  ";
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.catppuccin
    ];

  };
}
