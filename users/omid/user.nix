{inputs, ...}: {
            
  users.users.omid = {
    # isNormalUser = lib.mkForce true;
    isNormalUser = true;
    group = "omid";
    initialPassword = "changeme";
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjU7xEhfQl6Y2jwuH1po4xK8x6PdXejq60Du4YYJhi5"
    # ];
    extraGroups = [
      "wheel" # Enable sudo
      "storage" # Allow your user to manage drives
      "networkmanager"
      "tty"
      "input"
      "audio"
      "video"
      "sound"
      "docker"
    ];
  };

  users.groups.omid = {}; # Create the matching group
}
