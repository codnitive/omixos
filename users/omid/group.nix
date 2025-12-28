{ inputs, ... }:

{
  # Creater the matching group
  users.groups.omid = {
    # gid = 1000; # It you have issue mapping host user within docker container user
    name = "omid";
    members = ["omid"];
  };
}

