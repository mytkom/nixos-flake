{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.printing.enable = lib.mkEnableOption "CUPS printing with the university Canon printer";

  config = lib.mkIf config.my.printing.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        foomatic-db-nonfree
        foomatic-db-ppds-withNonfreeDb
        gutenprint
        cnijfilter2
      ];
    };

    # Needed for printing via the university SMB print server
    # (NT1 is an old, insecure protocol; note this also enables the smbd service).
    services.samba = {
      enable = true;
      settings.global = {
        workgroup = "WORKGROUP";
        "client min protocol" = "NT1";
        "client max protocol" = "SMB3";
        security = "user";
      };
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.printers = {
      ensurePrinters = [
        {
          name = "Canon3225(MINI)";
          location = "Uni";
          deviceUri = "smb://duodecimus.mini.pw.edu.pl/wirtualna";
          model = "foomatic-db-ppds/Canon-imageRunner_3225-pxlmono.ppd.gz";
          ppdOptions.PageSize = "A4";
        }
      ];
      ensureDefaultPrinter = "Canon3225(MINI)";
    };
  };
}
