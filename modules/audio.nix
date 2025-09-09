# Audio utilities and user-level configuration
# NOTE: PipeWire should be configured at system level, not in Home Manager
{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # Audio utilities
    pavucontrol     # PulseAudio/PipeWire volume control
    pulsemixer      # Terminal-based mixer
    alsa-utils      # ALSA utilities
    
    # Audio tools
    playerctl       # Media player control
    pamixer         # PulseAudio command line mixer
    
    # Codecs and plugins for multimedia
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-vaapi
  ];

  # Audio-related session variables
  home.sessionVariables = {
    # Ensure proper audio backend selection
    SDL_AUDIODRIVER = "pulse";
  };

  # Audio control aliases
  home.shellAliases = {
    # Volume control
    vol = "pamixer --get-volume";
    volup = "pamixer -i 5";
    voldown = "pamixer -d 5";
    volmute = "pamixer -t";
    
    # Media control
    play = "playerctl play-pause";
    next = "playerctl next";
    prev = "playerctl previous";
    stop = "playerctl stop";
    
    # Audio utilities
    mixer = "pulsemixer";
    audio = "pavucontrol";
    
    # System audio info
    audioinfo = "pactl info";
    audiosinks = "pactl list sinks short";
    audiosources = "pactl list sources short";
  };

  # PipeWire and WirePlumber configuration files 
  # NOTE: These create user-level configs in ~/.config/pipewire and ~/.config/wireplumber
  xdg.configFile = {
    # PipeWire user configuration
    "pipewire/pipewire.conf.d/99-omakase.conf".text = ''
      # Omakase PipeWire user configuration
      context.properties = {
        # Logging level (0-5, 2=info)
        log.level = 2
        
        # Clock configuration for low-latency audio
        default.clock.rate = 48000
        default.clock.quantum = 512
        default.clock.min-quantum = 32
        default.clock.max-quantum = 2048
        
        # Memory management
        mem.warn-mlock = false
        mem.allow-mlock = true
      }
    '';
    
    # WirePlumber configuration (session manager)
    "wireplumber/wireplumber.conf.d/99-omakase.conf".text = ''
      # Omakase WirePlumber configuration
      monitor.alsa.rules = [
        {
          matches = [
            {
              device.name = "~alsa_card.*"
            }
          ]
          actions = {
            update-props = {
              api.alsa.use-acp = true
              api.alsa.soft-mixer = true
            }
          }
        }
      ]
      
      monitor.bluez.rules = [
        {
          matches = [
            {
              device.name = "~bluez_card.*"
            }
          ]
          actions = {
            update-props = {
              bluez5.auto-connect = [ "hfp_hf" "hsp_hs" "a2dp_sink" ]
              bluez5.hw-volume = [ "hfp_hf" "hsp_hs" "a2dp_sink" ]
            }
          }
        }
      ]
    '';
    
  };

  # Desktop entries for audio applications
  xdg.desktopEntries = {
    pavucontrol = {
      name = "Volume Control";
      comment = "Adjust audio volume and configuration";
      exec = "${pkgs.pavucontrol}/bin/pavucontrol";
      icon = "audio-volume-high";
      categories = [ "AudioVideo" "Audio" "Settings" ];
    };
    
    pulsemixer = {
      name = "Audio Mixer";
      comment = "Terminal-based audio mixer";
      exec = "${pkgs.pulsemixer}/bin/pulsemixer";
      icon = "audio-volume-medium";
      categories = [ "AudioVideo" "Audio" ];
      terminal = true;
    };
  };
}