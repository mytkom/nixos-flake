{ ... }:
{
  programs.git = {
    enable = true;
    userName = "mytkom";
    userEmail = "marek.mytkowski.mm@gmail.com";
    extraConfig = {
      core.excludesFile = "~/.config/git/ignore";
    };
  };

  # Optionally, ensure the global gitignore file exists
  home.file.".config/git/ignore".text = ''
    shell.nix
    flake.nix
  '';
}
