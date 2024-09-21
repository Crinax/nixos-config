{ config, pkgs, ... }:
let
  vscode = (pkgs.vscode.override { isInsiders = false; }).overrideAttrs (oldAttrs: rec {
    src = (builtins.fetchTarball {
      url = "https://code.visualstudio.com/sha/download?os=linux-x64";
      sha256 = "1q85cw0sqv4av9ygzfsk2raxplzpp2g9kv5sd0yk8vzvysp3jhna";
    });
    version = "latest";

    buildInputs = oldAttrs.buildInputs ++ [ pkgs.rustup pkgs.zlib pkgs.openssl.dev pkgs.pkg-config ];
  });

  libraries = with pkgs; [
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    glib
    dbus
    openssl_3
    librsvg
  ];

  packages = with pkgs; [
    pkg-config
    dbus
    openssl_3
    glib
    gtk3
    libsoup
    webkitgtk
    appimagekit
    librsvg
  ];
in {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "fert";
    homeDirectory = "/home/fert";
    stateVersion = "24.05";
  };

  wayland.windowManager.hyprland.extraConfig = ''
#
# Please note not all available settings / options are set here.
# For a full list, see the wiki
#

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=VGA-1,1280x1024@75,0x56,1
monitor=HDMI-A-1,1920x1080@120,1280x0,1

# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox
exec-once = waybar
exec-once = dunst
exec-once = brave
exec-once = swww-daemon
exec-once = ./scripts/xdg-force
exec-once = wl-paste -t text --watch clipman store -P --histpath="~/.local/share/clipman-primary.json"
exec-once = udiskie &

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Set programs that you use
$terminal = alacritty
$fileManager = dolphin
$menu = wofi

# Some default env vars.
env = HYPRCURSOR_THEME,catppuccin-mocha-dark-cursors
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORM,wayland
env = QT_QPA_PLATFORMTHEME,qt5ct

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us,ru
    kb_variant =
    kb_model =
    kb_options = grp:win_space_toggle
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(fc5c7daa) rgba(6a82fbaa) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    
    blur {
        enabled = false
        # size = 7
        # passes = 4
        # noise = 0.008
        # contrast = 0.8916
        # brightness = 0.8
    }

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_status = master
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

misc {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
}

layerrule = blur, wofi
layerrule = ignorezero, wofi

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.
windowrulev2 = suppressevent fullscreen, class:.*

# Calendar
windowrulev2 = float,class:gsimplecal
windowrulev2 = move onscreen cursor -50% 0%,class:gsimplecal
windowrulev2 = size 25% 25%,class:gsimplecal

# Swappy tool annotation
windowrulev2 = float,class:swappy
windowrulev2 = forceinput,class:swappy
windowrulev2 = windowdance,class:swappy
windowrulev2 = pin,class:swappy
windowrulev2 = stayfocused,class:swappy

# Pulse audio volume control
windowrulev2 = float,class:pavucontrol
windowrulev2 = move onscreen cursor,class:pavucontrol
windowrulev2 = size 50% 40%,class:pavucontrol

# Flameshot rules
# windowrulev2=float,class:flameshot
# windowrulev2=move 0 0,class:flameshot
# windowrulev2=fullscreen,class:flameshot

# Brave DevTools
windowrulev2=float,class:brave-browser,title:^(DevTools)$

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, $terminal
bind = $mainMod, C, killactive, 
bind = $mainMod, M, exit, 
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, F, togglefloating, 
bind = ALT, space, exec, $menu
# TODO:  this work
# bind = ALT, P, exec, ls $HOME/projects | $menu --show dmenu | ./scripts/open-if-success
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, V, exec, clipman pick -t $menu --histpath="~/.local/share/clipman-primary.json"
bind = $mainMod ALT, P, exec, hyprpicker -a -f hex

# Translate via clipboard
bind = $mainMod, T, exec, wl-copy "$(wl-paste -p | trans :ru -brief | $menu --show dmenu)"
bind = CTRL ALT, T, exec, ~/nix/scripts/wofi/wofi-translate.sh :ru
bind = $mainMod CTRL ALT, T, exec, ~/nix/scripts/wofi/wofi-translate.sh :en

# Applications
bind = $mainMod, D, exec, ~/programs/Discord/Discord # --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform=wayland
bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
# bind = , Print, exec, grim -g "$(slurp)" - | satty --filename - --fullscreen --copy-command wl-copy --early-exit
bind = CTRL ALT, S, exec, signal-desktop

# Move focus with mainMod + arrow keys
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10
bind = $mainMod CTRL, right, workspace, e+1
bind = $mainMod CTRL, left, workspace, e-1

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10
bind = $mainMod SHIFT, right, movetoworkspace, e+1
bind = $mainMod SHIFT, left, movetoworkspace, e-1

bind = $mainMod ALT, right, resizeactive, 10 0
bind = $mainMod ALT, left, resizeactive, -10 0
bind = $mainMod ALT, up, resizeactive, 0 -10
bind = $mainMod ALT, down, resizeactive, 0 10

# Example special workspace (scratchpad)
bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = , mouse:274, movewindow
bindm = $mainMod, mouse:273, resizewindow
bind = $mainMod, mouse:274, killactive, 
  '';

  programs.vscode = {
    enable = true;
    package = vscode;
    extensions = with pkgs.vscode-extensions; [
      vue.volar
      prisma.prisma
      gruntfuggly.todo-tree
      bradlc.vscode-tailwindcss
      eamodio.gitlens
      ms-azuretools.vscode-docker
      catppuccin.catppuccin-vsc
      dbaeumer.vscode-eslint
      esbenp.prettier-vscode
      catppuccin.catppuccin-vsc-icons
      rust-lang.rust-analyzer
    ];
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history.size = 1000000;

    shellAliases = {
      system-update = "sudo nixos-rebuild switch --flake /home/fert/nix";
      home-update = "home-manager switch --flake /home/fert/nix";
      ls = "eza -la";
      cat = "bat";
    };

    sessionVariables = {
      EDITOR = "nvim";
      NIXOS_OZONE_WL = "1";
      # Prisma huynya
      PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
      PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
      PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";

      # Tauri
      LD_LIBRARY_PATH = "${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH";
      XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS";

      # # OpenSSL
      PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
      PATH="$PATH:/home/fert/.cargo/bin";
      # OPENSSL_DIR="${pkgs.openssl}/etc/ssl";
      # X86_64_UNKNOWN_LINUX_GNU_OPENSSL_LIB_DIR="${pkgs.openssl}/etc/ssl";
      # X86_64_UNKNOWN_LINUX_GNU_OPENSSL_DIR="${pkgs.openssl}";
      # X86_64_UNKNOWN_LINUX_GNU_OPENSSL_INCLUDE_DIR="${pkgs.openssl}";
    };

    oh-my-zsh = {
      enable = true;
      theme = "jonathan";
      plugins = [
        "git"
        "thefuck"
        "volta"
        "rust"
      ];
    };
  };
}
