{ lib, ... }:
let
  # Get a flattened list of every file path in this directory and its subdirectories
  allFiles = lib.filesystem.listFilesRecursive ./.;

  # Filter for files ending in .nix, and ensure we don't import default.nix
  validModules = lib.filter 
    (path: 
      lib.hasSuffix ".nix" (toString path) && 
      (baseNameOf path) != "default.nix"
    ) 
    allFiles;
in {
  imports = validModules;
}

#
# { lib, ... }:
# let
#   # Read the directory, filter for .nix files, and exclude this file (default.nix)
#   files = builtins.attrNames (builtins.readDir ./.);
#   isNixFile = name: lib.hasSuffix ".nix" name && name != "default.nix";
#   listOfFiles = map (name: ./. + "/${name}") (builtins.filter isNixFile files);
# in {
#   imports = listOfFiles;
# }
#
