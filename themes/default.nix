{ config, pkgs, lib, inputs, ... }:

let
  theme = config.omarchy.theme;

  # Generate color scheme from wallpaper for generated themes
  generatedColorScheme =
    if (theme == "generated_light" || theme == "generated_dark") then
      (inputs.nix-colors.lib.contrib { inherit pkgs; }).colorSchemeFromPicture {
        path = config.omarchy.theme_overrides.wallpaper_path;
        variant = if theme == "generated_light" then "light" else "dark";
      }
    else
      null;
in {
  imports = [
    ./wallpaper.nix
  ];

  colorScheme =
    if (theme == "generated_light" || theme == "generated_dark") then
      generatedColorScheme
    else if builtins.pathExists ./${theme}/. then
      import ./${theme}/theme.nix
    else
      inputs.nix-colors.colorSchemes.${theme};

  # This ensures portals are enabled, which allows apps to query system theme settings
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*"; # Standard for 2025 portal behavior
  };

  # GNOME/GTK Dark Mode
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    theme = {
      name = if theme == "generated_light" then "Adwaita" else "Adwaita:dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };
}

