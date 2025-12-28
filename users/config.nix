{ lib, ... }:

{
  # The initialHashedPassword, hashedPassword, initialPassword, password and hashedPasswordFile
  # options all control what password is set for the user.
  # If the option users.mutableUsers is true, the password defined in one of the above password
  # options will only be set when the user is created for the first time. After that, you are
  # free to change the password with the ordinary user management commands.
  # If users.mutableUsers is false, you cannot change user passwords, they will always be set
  # according to the password options.
  # https://search.nixos.org/options?show=users.users.%3Cname%3E.hashedPassword
  users.mutableUsers = false;
}

