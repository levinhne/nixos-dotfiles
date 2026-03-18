{ ... }:

{
  services.pulseaudio.enable = false;

  # PipeWire owns the audio stack, including compatibility layers used by Bluetooth audio.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
