{ config, lib, ... }:

let
  cfg = config.omarchy;
  themeName = cfg.theme;
  themesDir = ./.;

  # Supported wallpaper extensions (in priority order)
  wallpaperExtensions = [ "jpg" "jpeg" "png" "webp" ];

  # Check if a custom theme directory exists with a wallpaper
  findThemeWallpaper = theme:
    let
      themeDir = themesDir + "/${theme}";
      findFirst = exts:
        if exts == [] then null
        else
          let
            ext = builtins.head exts;
            path = themeDir + "/wallpaper.${ext}";
          in
          if builtins.pathExists path then path
          else findFirst (builtins.tail exts);
    in
    if builtins.pathExists themeDir
    then findFirst wallpaperExtensions
    else null;

  # Wallpapers directory for nix-colors themes
  wallpapersDir = ./wallpapers;

  # Fallback wallpaper mappings for nix-colors themes (Nix store paths)
  fallbackWallpapers = {
    "tokyo-night" = wallpapersDir + "/1-Pawel-Czerwinski-Abstract-Purple-Blue.jpg";
    "kanagawa" = wallpapersDir + "/kanagawa-1.png";
    "everforest" = wallpapersDir + "/1-everforest.jpg";
    "nord" = wallpapersDir + "/nord-1.png";
    "gruvbox" = wallpapersDir + "/gruvbox-1.jpg";
    "gruvbox-light" = wallpapersDir + "/gruvbox-1.jpg";
  };

  # Determine the wallpaper path
  resolvedWallpaperPath =
    # Priority 1: Manual override
    if cfg.theme_overrides.wallpaper_path != null then
      toString cfg.theme_overrides.wallpaper_path
    # Priority 2: Generated themes require manual wallpaper_path
    else if (themeName == "generated_light" || themeName == "generated_dark") then
      throw "Generated themes require theme_overrides.wallpaper_path to be set"
    # Priority 3: Custom theme directory wallpaper
    else
      let themeWallpaper = findThemeWallpaper themeName;
      in
      if themeWallpaper != null then
        toString themeWallpaper
      # Priority 4: Fallback to predefined wallpapers
      else if fallbackWallpapers ? ${themeName} then
        toString fallbackWallpapers.${themeName}
      # Priority 5: No wallpaper found
      else
        null;

in {
  options.omarchy.wallpaper_path = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = resolvedWallpaperPath;
    readOnly = true;
    description = ''
      The resolved wallpaper path for the current theme.
      This is automatically determined based on:
      1. Manual override via theme_overrides.wallpaper_path
      2. Wallpaper file in custom theme directory (themes/<name>/wallpaper.{jpg,png,...})
      3. Predefined wallpaper for nix-colors themes

      Other modules can access this via config.omarchy.wallpaper_path
    '';
  };
}
