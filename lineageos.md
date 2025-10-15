https://wiki.lineageos.org/devices/redfin/install

https://wiki.lineageos.org/gapps

boot phone to recovery: power off then power button + volume down

in recovery enable ADB under advanced if it's not and reboot

go to apply update

select apply from ADB

then run

    # optional steps
    ./adb root
    ./adb -d reboot sideload

    # sideload is the key part
    ./adb sideload roms/pixel5/lineage-20.0-20230101-nightly-redfin-signed.zip

the update might hang at 47%, just wait till the phone says it's complete
after that, it will ask if you want to reboot to recovery, say yes

do another update to install Gapps, have to enable ADB again

    ./adb -d reboot sideload
    ./adb sideload roms/pixel5/MindTheGapps-13.0.0-arm64-20221025_100653.zip

reboot
