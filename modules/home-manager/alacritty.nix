{pkgs, ...}: {
  home.packages = with pkgs; [alacritty];

  programs.alacritty = {
    enable = true;
    settings = {
      font.size = 13.0;
      window.startup_mode = "Windowed";
    };
  };
}
