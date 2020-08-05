# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  z-emacs = (with pkgs;
    (emacsPackagesNgGen emacsGit).emacsWithPackages (p:
      with p; [
        nix-mode
        haskell-mode
        yaml-mode
        web-mode
        rust-mode
        lua-mode
        go-mode
        goto-line-preview
        diredfl
        dired-collapse
        rime
        nix-env-install
        nix-sandbox
        telega
        nix-haskell-mode
        use-package
        use-package-ensure-system-package
        vterm
        which-key-posframe
        treemacs
        aggressive-indent
        doom-modeline
        dimmer
        zoom
        benchmark-init
        no-littering
        vterm-toggle
        ws-butler
        direnv
        helpful
        font-lock-studio
        form-feed
        winum
        nov
        format-all
        suggest
        prescient
        company-posframe
        flycheck-posframe
        flycheck-color-mode-line
        package-lint
        company-tabnine
        evil
        indent-guide
        magit
        hl-todo
        olivetti
        google-translate
        rainbow-mode
        highlight-defined
        easy-escape
      ]));
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
    #    ./services/v2ray-ipv4-transproxy.nix
    ./services/guix.nix
    <home-manager/nixos>
  ];
  # services.v2ray-ipv4-transproxy = let
  #   assets = {
  #     "geoip.dat" = pkgs.fetchurl {
  #       url = "https://github.com/Loyalsoldier/v2ray-rules-dat /releases/download/202006130214/geoip.dat";
  #       sha256 = "273d10dc8dede54a55bc2caeb9220eedd88a4f6f2a9d0631b93837faf38aab75";
  #     };
  #     "geosite.dat" = pkgs.fetchurl {
  #       url = "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/download/202006130214/geosite.dat";
  #       sha256 = "992929d803ef5bf6750111603fcfd42f8763806248494437e19bed580a6d1cbf";
  #     };
  #   };
  #   v2ray = pkgs.v2ray.override {
  #     inherit assets;
  #   };
  # in
  #   {
  #     enable = true;
  #     package = v2ray;
  #     redirPort = 7892;
  #     configPath = ./secrets/v2ray/config.json;
  #   };
  services.guix-daemon.enable = true;
  home-manager.useGlobalPkgs = true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    #    supportedFilesystems = [ "zfs" ];
    blacklistedKernelModules = [ "ideapad_laptop" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
  };
  networking = {
    useDHCP = false;
    interfaces = {
      enp4s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    }; # hostId = "eeeeeeee";
    hosts = {
      "23.7.218.170" = [ "api.warframe.com" ];
      "104.127.215.220" = [ "origin.warframe.com" ];
      "117.18.232.232" = [ " download.nvidia.com" ];
    };
    hostName = "Z572"; # Define your hostname.
    extraHosts = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "googlehosts";
      repo = "hosts";
      rev = "8ff01be91c4a70604f83e5cf0a3dd595fe8868b0";
      sha256 = "07bf23fp9l3xcw2jf3rxjkb4729948k6a3vgqvizs9v4glhwmj1b";
    } + "/hosts-files/hosts");
    wireless = {
      enable = true;
      userControlled.enable = true;
      networks = {
        TP-LINK_2302 = { psk = "15958123279"; };
        CMCC-2QFz = { psk = "123456789"; };
        ASUS_90 = { psk = "wu12345678"; };
      };
    };
  };
  # Enables wireless support via wpa_supplicant.
  #networking.networkmanager.enable=true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.

  # Configure network proxy if necessary
  #  networking.proxy.default = "http://localhost:8087/";
  #  networking.proxy.noProxy = ''
  #    127.0.0.1,localhost,internal.domain,mirrors.tuna.tsinghua.edu.cn
  #  '';

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [ "zh_CN.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
    inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ rime ];
    };
  };
  console = {
    useXkbConfig = true;
    font = "Lat2-Terminus16";
    #    keyMap = "us";
  };
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  environment = {
    pathsToLink = [ "/share/zsh" ];
    homeBinInPath = true;
    shells = with pkgs; [ zsh bash ];
    variables = {
      #    EDITOR = "emacs";
      BROWSER = "chromium";
      SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
      WINEDLLOVERRIDES = "winemenubuilder.exe=d";
      EMAIL = "873216071@qq.com";
    };
    systemPackages = with pkgs; [
      direnv
      arc-theme
      lxappearance
      screenkey
      gcc
      xorg.xkill
      nodePackages.node2nix
      dunst
      #(blender.override{OpenGL=true;})
      pandoc
      libtool
      compton
      gnutar
      unzip
      gitAndTools.git-open
      wget
      home-manager
      cv
      inkscape
      neovim
      gparted
      alacritty
      aria2
      nodejs
      #ripgrep-all
      xarchiver
      ripgrep
      krita
      stack
      fzf
      git
      neofetch
      gnumake
      cmake
      ghc
      nixfmt
      gotop
      libnotify
      vlc
      imv
      light
      you-get
      (haskellPackages.ghcWithPackages (p: with p; [ xmonad xmonad-contrib ]))
      (python38Full.withPackages (p:
        with p; [
          pyqt5 # _with_qtmultimedia
          pyqtwebengine
          pyopenssl
          pysocks
          filebrowser_safe
          pyqrcode
        ]))
      wpsoffice
      nss
      steam
      #      (steam.override { nativeOnly = true; }).run
    ];
  };

  nix = {
    binaryCaches = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
    ];
    autoOptimiseStore = true;
    #    gc.automatic = true;
    maxJobs = 32;
    useSandbox = true;
    readOnlyStore = true;
    package=pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  programs = {
    dconf.enable = true;
    # nvim={
    #  enable=true;
    #  viAlias=true;
    #  vimAlias=true;
    #  withNodeJs=true;
    # };
    light.enable = true;
    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    command-not-found.enable = true;
    chromium = {
      enable = true;
      homepageLocation = "https://duckduckgo.com";
      extensions = [
        #        "ookhnhpkphagefgdiemllfajmkdkcaim" # iNinja VPN
        "gighmmpiobklfepjocnamgkkbiglidom" # AdBlock
        "chphlpgkkbolifaimnlloiipkdnihall" # OneTab
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # darkreader
        "iipjdmnoigaobkamfhnojmglcdbnfaaf" # Clutter Free
      ];
    };
    ccache = {
      enable = true;
      #      packageNames = [ "emacsGit" ];
    };
    npm = { enable = true; };
    thefuck = { enable = true; };
    tmux = {
      enable = true;
      clock24 = true;
      customPaneNavigationAndResize = true;
      reverseSplit = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      #  zsh-autoenv.enable = true;
    };
     };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };
  # List services that you want to enable:
  nixpkgs = {
    config = {
      allowUnfree = true;
      chromium = { enableWideVine = true; };
      git = {
        enable = true;
        userName = "Z572";
        userEmail = "873216071@qq.com";
        github.user = "Z572";
      };

      packageOverrides = pkgs: {
        nur = import (builtins.fetchTarball
          "https://github.com/nix-community/NUR/archive/master.tar.gz") {
            inherit pkgs;
          };
      };
    };
    overlays = [
      (import (builtins.fetchTarball {
        url =
          "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];
  };
  # Enable the OpenSSH daemon.
  #  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  security = {
    doas = {
      enable = true;
      extraRules = [{
        groups = [ "wheel" ];
        noPass = false;
        keepEnv = true;
      }];
    };
    pki.certificateFiles = [ "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
  };
  # Enable sound.
  sound.enable = true;

  # Enable the X11 windowing system.
  hardware = {
    pulseaudio.enable = true;
    acpilight.enable = true;
    brillo.enable = true;
    #bumblebee.enable=true;
    nvidia = {
      modesetting.enable = true;
      prime = {
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
        sync.enable = true;
      };
    };
    steam-hardware.enable = true;
    opengl.driSupport32Bit = true;
  };
  #virtualisation.anbox.enable = true;

  # Enable touchpad support.
  services = {
    dbus.packages = with pkgs; [ gnome3.dconf ];
    zerotierone = {
      enable = false;
      joinNetworks = [ "1c33c1ced081139c" ];

    };
    v2ray = {
      enable = false;
      config = { };
    };
    syncthing = { enable = false; };
    lorri.enable = true;
    emacs = {
      enable = true;
      defaultEditor = true;
      install = true;
      package = z-emacs;
    };
    ipfs = {
      enable = false;
      autoMount = true;

    };
    tlp.enable = true;
    cron = { mailto = "873216071@qq.com"; };
    smartdns = {
      enable = false;
      settings = {
        bind = ":5353 -no-rule -group example";
        cache-size = 4096;
        server-tls = [ "8.8.8.8:853" "1.1.1.1:853" ];
        server-https = "https://cloudflare-dns.com/dns-query";
        prefetch-domain = true;
        speed-check-mode = "ping,tcp:80";
      };
    };
    xserver = {
      enable = true;
      layout = "us";
      libinput.enable = true;
      displayManager = {
        lightdm = {
          enable = true;
          greeters = {
            mini = {
              enable = false;
              user = "x";
            };
          };
        };
      };

      xkbOptions = "ctrl:nocaps";
      wacom.enable = true;
      videoDrivers = [
        "nvidia"
        #        "modesetting"
      ];
      desktopManager = {
        #gnome3.enable= true;
        #plasma5.enable = true;
      };
      windowManager = {
        exwm.enable = false;
        openbox.enable = true;
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = p: with p; [ rio xmonad xmonad-contrib xmobar ];
        };
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users.x = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Z572";
      extraGroups = [ "wheel" "networkmanager" "disk" "audio" "video" ];
    };
  };
  fonts = {
    fontconfig = {
      enable = true;
      cache32Bit = true;
      defaultFonts = {
        monospace = [ "Sarsa Mono Sc" "DejaVu Sans Mono" "unifont" ];
        emoji = [ "Noto Color Emoji" ];
        sansSerif = [
          "Ubuntu Nerd Font"
          "Noto Sans CJK"
          "WenQuanYi Micro Hei"
          "DejaVu Sans"
          "unifont"
        ];
        serif = [ "DejaVu Serif" "Noto Sans CJK" "Vazir" "Ubuntu" "unifont" ];
      };
    };
    enableFontDir = true;
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      symbola
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      #source-han-sans
      powerline-fonts
      fira-code
      sarasa-gothic
      vazir-fonts
      ubuntu_font_family
      wqy_zenhei
      wqy_microhei
      noto-fonts
      hack-font
      unifont
    ];
  };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html ).
  system = {
    autoUpgrade.enable = true;
    stateVersion = "20.03";
  };
  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };
}
