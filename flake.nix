{
  description = "Dovs nixos configs";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.url = "github:nix-community/emacs-overlay/master";
    nix-matlab.url = "gitlab:doronbehar/nix-matlab";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, unstable, nixos-hardware, emacs-overlay, nix-matlab, ... }:
    let
      system = "x86_64-linux";
      pkgs =
        let
          overlay-unstable = final: prev: {
            unstable = import unstable {
              system = "${prev.system}";
              config.allowUnfree = true;
            };
          };
        in
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (import ./overlays)
            emacs-overlay.overlay
            nix-matlab.overlay
            overlay-unstable
          ];
        };
      mkComputer = configurationNix: userName: extraModules: extraHomeModules: extraArgs: inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit system inputs pkgs extraArgs nixos-hardware; };
        modules = [
          configurationNix
          (./. + "/users/${userName}")

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${userName}" = {
              imports = extraHomeModules;
            };
          }
        ] ++ extraModules;
      };
    in
    {
      nixosConfigurations = {
        nixosvm = mkComputer
          ./machines/nixosvm #machine specific configuration
          "dovalperin" #default user
          [
            ./modules/gnome
            ./modules/1password
            ./modules/tailscale
            ./modules/ssh
          ] #modules to load
          [
            ./modules/zsh
          ] #modules to be loaded by home-manager
          {
            tskey = "tskey-knNVuH6CNTRL-JKERvdZq7G1bLjJw8rvTP";
          }; #extra arguments to pass to all the modules
        DovDev = mkComputer
          ./machines/DovDev #machine specific configuration
          "dovalperin" #default user
          [
            ./modules/gnome
            ./modules/1password
            ./modules/tailscale
            ./modules/ssh
            ./modules/zoom
            ./modules/browsers
            ./modules/postgresql
            ./modules/redis
          ] #modules to load
          [
            ./modules/zsh
            ./modules/emacs
          ] #modules to be loaded by home-manager
          {
            tskey = "tskey-kgeK3F1CNTRL-FQepgBXb9fNjgEcoQATQY";
          }; #extra arguments to pass to all the modules
      };
      homeConfigurations =
        let
          username = "dovalperin";
          stateVersion = "21.11";
          baseConfiguration = {
            programs.home-manager.enable = true;
            home.username = "dovalperin";
            home.homeDirectory = "/home/dovalperin";
          };
          mkHomeConfig = extraModules: home-manager.lib.homeManagerConfiguration {
            inherit username system stateVersion;
            homeDirectory = "/home/${username}";
            configuration = baseConfiguration // {
              imports = [ ./home ] ++ extraModules;
            };
          };
        in
        {
          "DovDev" = mkHomeConfig
            [
              ./modules/zsh
              ./machines/DovDevUbuntu
            ];
        };
    };
}


