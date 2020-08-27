fix noise on the line when nothing is playing

    echo 0 > /sys/module/snd_hda_intel/parameters/power_save
