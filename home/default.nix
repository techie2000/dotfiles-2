#Shared by all machines
{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.yarn
    pkgs.ripgrep
    pkgs.bat
    pkgs.exa
    pkgs.rustup
    pkgs.nodejs
    pkgs.niv
    pkgs.nixpkgs-fmt
    pkgs.strace
    pkgs.lsof
    pkgs.gdb
    pkgs.cutter
    pkgs.youtube-dl
    pkgs.spotify
    pkgs.ffmpeg
  ];

  dov = {
    zsh.enable = true;
  };

  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "Dov Alperin";
    userEmail = "dzalperin@gmail.com";
    delta.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.go = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };
}
