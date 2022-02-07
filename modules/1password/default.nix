{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dov."1password";
in
{
  options.dov."1password".enable = mkEnableOption "1password";

  config = mkIf cfg.enable
    {
      home.packages = with pkgs; [
        _1password-gui
      ];
    };
}
