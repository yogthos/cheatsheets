resize droplet disk if fails to happen automatically for ext4 fs

    gdisk -l /dev/vda
    growpart /dev/vda 1
    resize2fs /dev/vda1

turn off maintenance mode

    sudo nextcloud.occ maintenance:mode --off

check/repair install

    sudo nextcloud.occ maintenance:repair
