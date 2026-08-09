How to bring a Remarkable tablet back to working order

SSH in, set the clock:

```
ssh root@10.11.99.1          # USB. over wifi: the tablet's LAN IP
# password: on the tablet, Settings → Help → Copyrights and licenses → General info
# (username root, password, IPs all listed there)

timedatectl                  # confirm how far off it is
timedatectl set-ntp 0        # disable auto time first, or set-time errors out
timedatectl set-time '2026-07-15'
timedatectl set-ntp 1
```

After setting the time, I was able to download a software update.

### Software update

After the first software update, cloud sync now gaves a different error: HTTP 400, actual error message in the journal: “Unable to sync. Please update this application to continue using the reMarkable cloud.”

    journalctl -u rm-sync.service --since '-45 min' --no-pager

The cloud rejects obsolete system version. Turns out the first update only brought the tablet to 3.11.2.5 and wouldn’t update further.

journalctl for swupdate.service showed Couldn't resolve host name (after the post-update reboot, the updater had started before wifi/DNS was up and never retried). Restarting the update services made the Settings screen offer 3.27.3.0, and a second update brought the tablet to the latest available software version.

```
systemctl restart swupdate.service update-engine.service
systemctl is-active swupdate.service update-engine.service
journalctl --since '-1 min' -u swupdate.service -u update-engine.service
```

Starting with version 3.22 of the software, SSH over wifi is now silently disabled by the update, so port 22 refuses on the LAN.

SSH in to the tablet via USB (e.g. 10.11.99.1) instead. Re-enable network SSH with rm-ssh-over-wlan on, or drop the marker file rm_enable_ssh_wifi_marker (the dropbear-wlan.socket unit is already enabled, just inactive)

```
rm-ssh-over-wlan on
systemctl is-active dropbear-wlan.socket
systemctl is-enabled dropbear-wlan.socket
test -e /home/root/.config/remarkable/rm_enable_ssh_wifi_marker && echo present
ip -4 -brief address show wlan0
ss -lntp | grep ':22 ' || true
```

### Importing files over SSH

For whatever reason, cloud sync still appeared to be broken, it wouldn’t pull any of my new uploads.

Instead of debugging this further (by now I was done dealing with the cloud sync), I found that the table has an optional web server that can be turned on, to allow you to upload and export files from the device. I backed up the xochitl config before toggling it on (WebInterfaceEnabled=true):

```
conf=/home/root/.config/remarkable/xochitl.conf
cp -p "$conf" "$conf.codex-backup-before-usb-web"
if grep -q '^WebInterfaceEnabled=' "$conf"; then
  sed -i 's/^WebInterfaceEnabled=.*/WebInterfaceEnabled=true/' "$conf"
else
  sed -i '/^\[General\]$/a WebInterfaceEnabled=true' "$conf"
fi
systemctl restart xochitl.service
grep '^WebInterfaceEnabled=' "$conf"
systemctl is-active xochitl.service

Inspect and upload PDFs:

curl --max-time 30 -sS http://10.11.99.1/documents/ | jq -r '.[].VisibleName'

set -e
for file in ./my-pdf-files/*.pdf; do
  name=${file##*/}
  status=$(curl --max-time 300 -sS -o /dev/null -w '%{http_code}' \
    -F "file=@${file};type=application/pdf" http://10.11.99.1/upload)
  printf '%s\t%s\n' "$status" "$name"
  test "$status" = 201
done
```
