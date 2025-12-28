{ inputs, pkgs, ... }:

{
  users.users.omid = {
    # uid = 1000; # It you have issue mapping host user within docker container user
    description = "Main admin user";
    isNormalUser = true;
    group = "omid";
    # https://search.nixos.org/options?show=users.users.%3Cname%3E.hashedPassword
    # Generate hashed password using `mkpasswd` command
    # Default is set to "changeme"
    hashedPassword = "$y$j9T$MqtBjRJIZcaTHpfK8e3dY/$8TUl/Co2bbrBOgoxLwc7RA5ZtKTv935IKwIM9YodSy1";
    home = "/home/omid";

    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjU7xEhfQl6Y2jwuH1po4xK8x6PdXejq60Du4YYJhi5"
    # ];

    extraGroups = [
      "wheel" # Enable sudoer
      #"users" # This group is default group NixOS use, can be added in case system is not working well
      "storage" # Allow your user to manage drives
      "disk"
      "networkmanager"
      "tty"
      "input"
      "audio"
      "video"
      "sound"
      "docker"
    ];
  };
}

