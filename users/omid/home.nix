{ self, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "BAK";

    extraSpecialArgs = { inherit inputs; };

    users.omid = {
      imports = [ self.homeManagerModules.default ];

      home.username = "omid";
      home.homeDirectory = "/home/omid";
    };
  };
}

