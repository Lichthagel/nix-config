{ ... }:
{
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.licht.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIINk7AyWZXm9YSmnwfW0M6ujtqc0mg3ZUcW0X0NbyHS7 shared"
  ];
}
