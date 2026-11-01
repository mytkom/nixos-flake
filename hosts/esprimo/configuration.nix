{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      
      inputs.self.nixosModules.tailscale

      ./hardware-configuration.nix
    ];

    nix.settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };

    services.nginx = {
      enable = true;
    
      virtualHosts = {
        "localhost" = {
          root = "/var/www";  # not needed for proxy-only setup
          enableACME = false; # disable if not using HTTPS certs
    
          # Example reverse proxy
          locations = {
            "/nlp" = {
              proxyPass = "http://127.0.0.1:8501";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_redirect off;
              '';
            };
            "/bigdata" = {
              proxyPass = "http://127.0.0.1:8502";
              proxyWebsockets = true;
              extraConfig = ''
                proxy_set_header Host $host;
                proxy_set_header X-Real-IP $remote_addr;
                proxy_redirect off;
              '';
            };
            "/datasette/" = {
              proxyPass = "http://127.0.0.1:8001";
              proxyWebsockets = true;
              extraConfig = ''
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
		proxy_redirect off;
	      '';
            };
          };
        };
      };
    };

  services.vikunja = {
      enable = true;
  
      frontendHostname = "localhost";
      frontendScheme = "http";
  
      database = {
        type = "sqlite"; # simplest for single user
      };
  };

  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user
      # max protocol = smb2
      hosts allow = 192.168.8. 127.0.0.1 localhost levicorpus nothing-a063 laura
      hosts deny = 0.0.0.0/0
    '';
    shares = {
      private = {
        path = "/home/mytkom";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mytkom";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  
  services.syncthing = {
     enable = true;
     user = "mytkom";
     dataDir = "/home/mytkom/";
     configDir = "/home/mytkom/.config/syncthing";
     guiAddress = "0.0.0.0:8384";
  };

  services.cockpit = {
    enable = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user = "mytkom";
  };

  services.ollama = {
    enable = true;
    listenAddress = "0.0.0.0:11434";
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    zip
    unzip
    btop
    vim
    pcp
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "mytkom" "bigdata" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Users
  users.users = {
    mytkom = {
      initialPassword = "12345678";
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = ["wheel" "tty" "video" "audio" "docker" "input"];
    };
  };
  users.defaultUserShell = pkgs.zsh;

  networking.firewall.enable = true;
  networking.firewall.checkReversePath = false;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 8384 22000 9090 11434 3333 445 3456 8001 7272 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  networking.hostName = "esprimo"; # Define your hostname.
  # Pick only one of the below networking options.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # networking.wg-quick.interfaces.proton = {
  #   autostart = true;
  #   configFile = "/root/nixos-flake/proton.conf";
  # };

 # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

