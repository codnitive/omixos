{ config, pkgs, inputs, ... }:

let
  theme = config.omarchy.theme;
  #
  # cfg = config.omarchy;
  # wallpapers = {
  #   "tokyo-night" = [
  #     "1-Pawel-Czerwinski-Abstract-Purple-Blue.jpg"
  #   ];
  #   "kanagawa" = [
  #     "kanagawa-1.png"
  #   ];
  #   "kanagawa-dragon" = [
  #     "kanagawa-dragon-1.png"
  #   ];
  #   "everforest" = [
  #     "1-everforest.jpg"
  #   ];
  #   "nord" = [
  #     "nord-1.png"
  #   ];
  #   "gruvbox" = [
  #     "gruvbox-1.jpg"
  #   ];
  #   "gruvbox-light" = [
  #     "gruvbox-1.jpg"
  #   ];
  # };
  #
  # # Handle wallpaper path for generated themes and overrides
  # wallpaper_path =
  #   if
  #     (cfg.theme == "generated_light" || cfg.theme == "generated_dark")
  #     || (cfg.theme_overrides.wallpaper_path != null)
  #   then
  #     toString cfg.theme_overrides.wallpaper_path
  #   else
  #     let
  #       selected_wallpaper = builtins.elemAt (wallpapers.${cfg.theme}) 0;
  #     in
  #     "~/Pictures/Wallpapers/${selected_wallpaper}";

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
  # imports = validModules;
  # inherit wallpaper_path;

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

