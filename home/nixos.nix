# Nixos specific, does not get applied on ubuntu
{ config, pkgs, ... }: {
  imports = [
    ./home.nix
  ];

  home.packages = with pkgs; [
    brave
    neovim
    element-desktop
    discord
  ];

  programs.vscode.enable = true;
}
