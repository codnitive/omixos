# To override default theme for specific user
{ pkgs, lib, ... }:

{
  home-manager = {
    users.omid = {
      # # Manually set the color scheme for nix-colors used by Omarchy
      # # mkForce ensures your custom colors override the ones Omarchy looks up
      # colorScheme = lib.mkForce kanagawa-dragon;

      # # GNOME/GTK Dark Mode
      # dconf.settings = lib.mkForce {
      #   "org/gnome/desktop/interface" = {
      #     color-scheme = "prefer-light";
      #   };
      # };
      #
      # gtk = lib.mkForce {
      #   theme = {
      #     name = "Adwaita";
      #     package = pkgs.gnome-themes-extra;
      #   };
      #   gtk3.extraConfig.gtk-application-prefer-dark-theme = 0;
      #   gtk4.extraConfig.gtk-application-prefer-dark-theme = 0;
      # };
    };
  };
}

