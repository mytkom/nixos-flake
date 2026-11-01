{vars, ...}: {
  imports = [./hardware-configuration.nix];

  networking = {
    hostName = "esprimo";
    firewall = {
      enable = true;
      allowPing = true;
    };
  };

  my = {
    tailscale.enable = true;
    ssh = {
      enable = true;
      # TODO: this host has no declared users, so root is the only way in.
      # Declare a user with authorizedKeys, then drop both overrides.
      passwordAuthentication = true;
      permitRootLogin = "yes";
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
        workgroup = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      private = {
        path = "/home";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = vars.user;
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  system.stateVersion = "23.11";
}
