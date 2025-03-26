# recipe manager

https://tamariapp.com/

# MPD UI

https://github.com/prokosna/sola_mpd

### M.A.L.P. - A mpd client for Android

https://gitlab.com/gateship-one/malp

### MPD config

check audio device `cat /proc/asound/cards`

```
audio_output {
        type            "alsa"
        name            "My ALSA Device"
#        auto_resample  "no"
        device          "hw:1"  # optional
        mixer_type      "hardware"      # optional
#       mixer_device    "default"       # optional
#       mixer_control   "PCM"           # optional
#       mixer_index     "0"             # optional
}
```

