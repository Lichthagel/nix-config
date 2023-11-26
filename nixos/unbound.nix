{
  services.unbound = {
    enable = true;
    settings = {
      forward-zone = [
        {
          name = ".";
          forward-tls-upstream = "yes";
          forward-addr = "5.9.164.112@853#dns3.digitalcourage.de";
        }
      ];
    };
  };
}
