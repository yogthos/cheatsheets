list devices `cat /proc/asound/cards`

example output

```
 0 [HDMI           ]: HDA-Intel - HDA Intel HDMI
                      HDA Intel HDMI at 0xa0810000 irq 75
 1 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xa0814000 irq 76
 2 [Audio          ]: USB-Audio - DigiHug USB Audio
                      FiiO DigiHug USB Audio at usb-0000:00:14.0-8, full speed
```

set the device in `/etc/mpd.conf`

```
audio_output {
	type	   	 "alsa"
	name		   "My ALSA Device"
	device		 "hw:2"	# number of the device from above
	mixer_type "hardware"	# optional
}
```

start mpd

`sudo systemctl start mpd`
