{ config, pkgs, ... }: { wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec-once = swaybg -i ${./assets/wallpaper.jpg} -m fill
      exec-once = waybar
      exec-once = hyprctl setcursor Future-cursors 24
      exec-once = nm-applet --indicator
      exec-once = dunst
      exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
      exec-once = swayidle -w timeout 200 'swaylock-fancy' 

      env = WLR_NO_HARDWARE_CURSORS,1
      env = GDK_BACKEND,wayland,x11
      env = QT_QPA_PLATFORM,wayland;xcb
      env = SDL_VIDEODRIVER,wayland
      env = CLUTTER_BACKEND,wayland
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = GTK_THEME,Breeze-Dark
      env = QT_STYLE_OVERRIDE,Breeze
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = XCURSOR_THEME,Future-cursors
      env = XCURSOR_SIZE,24
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_SCALE_FACTOR,1.5
      env = GDK_SCALE,1.5
      env = ELM_SCALE,1.5

      monitor=eDP-1,highres,auto,1.25

      input {
        kb_layout = pl
        kb_options = caps:escape

        touchpad {
          natural_scroll = true
          scroll_factor = 0.9
          clickfinger_behavior = true
          disable_while_typing = true
        }
        scroll_method = 2fg
      }

      general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
    
        gaps_in = 3
        gaps_out = 5
        border_size = 3
        col.active_border = rgba(22221eff) rgba(102536ff) 45deg
        col.inactive_border = rgba(595959aa)
    
        layout = dwindle
    
        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false
      }

      
      decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
      
          rounding = 10
      
          blur {
              enabled = true
              size = 3
              passes = 1
          }
      
          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
      }

      $mod = SUPER

      bind = $mod, Q, exec, kitty
      bind = $mod, B, exec, brave
      bind = $mod, S, exec, rofi -show drun
      bind = $mod, C, killactive,
      bind = $mod, M, exit,

      # Move focus
      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d

      # Workspace switch
      bind = $mod, 1, workspace, 1
      bind = $mod, 2, workspace, 2
      bind = $mod, 3, workspace, 3
      bind = $mod, 4, workspace, 4
      bind = $mod, 5, workspace, 5
      bind = $mod, 6, workspace, 6
      bind = $mod, 7, workspace, 7
      bind = $mod, 8, workspace, 8
      bind = $mod, 9, workspace, 9
      bind = $mod, 0, workspace, 10

      # Move active window to a workspace with mod + SHIFT + [0-9]
      bind = $mod SHIFT, 1, movetoworkspace, 1
      bind = $mod SHIFT, 2, movetoworkspace, 2
      bind = $mod SHIFT, 3, movetoworkspace, 3
      bind = $mod SHIFT, 4, movetoworkspace, 4
      bind = $mod SHIFT, 5, movetoworkspace, 5
      bind = $mod SHIFT, 6, movetoworkspace, 6
      bind = $mod SHIFT, 7, movetoworkspace, 7
      bind = $mod SHIFT, 8, movetoworkspace, 8
      bind = $mod SHIFT, 9, movetoworkspace, 9
      bind = $mod SHIFT, 0, movetoworkspace, 10

      # Move between neighbour workspaces
      bind = $mod SHIFT, left, workspace, e-1
      bind = $mod SHIFT, right, workspace, e+1

      binde=, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+
      binde=, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-
      bind=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      binde=, XF86MonBrightnessUp,exec, brillo -q -A 5
      binde=, XF86MonBrightnessDown,exec, brillo -q -U 5
      '';
  };
}
