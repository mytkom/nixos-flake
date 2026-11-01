{
  pkgs,
  lib,
  config,
  ...
}: {
  options.my.laptopPower.enable = lib.mkEnableOption "TLP battery tuning and AMD backlight permissions";

  config = lib.mkIf config.my.laptopPower.enable {
    services = {
      system76-scheduler.settings.cfsProfiles.enable = true;
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          STOP_CHARGE_THRESH_BAT1 = "95";
          CPU_MAX_PERF_ON_AC = "100";
          CPU_MAX_PERF_ON_BAT = "50";
          AHCI_RUNTIME_PM_ON_BAT = "on";
        };
      };
      logind.settings.Login.KillUserProcesses = true;
      power-profiles-daemon.enable = false;
    };
    powerManagement.powertop.enable = false;

    services.udev.extraRules = ''
      RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/amdgpu_bl0/brightness"
      RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/amdgpu_bl0/brightness"
    '';
  };
}
