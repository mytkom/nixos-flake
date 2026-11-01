{
  lib,
  config,
  ...
}: {
  options.my.audio.enable = lib.mkEnableOption "PipeWire audio and Bluetooth";

  config = lib.mkIf config.my.audio.enable {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings.General.Enable = "Source,Sink,Media,Socket";
  };
}
