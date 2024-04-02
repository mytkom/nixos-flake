{ inputs, outputs, ... }:
{
  dconf.settings = {
    "org.gnome.desktop.input-sources" = {
      xkb-options = "['caps:escape']";
    };
    "org.gnome.mutter" = {
      experimental-features = "['scale-monitor-framebuffer']";
    };
  };
}
