setting permissions on macOS:

    sudo xattr -r -d com.apple.quarantine "/path/to/Xonotic.app"
    
setting up a dedicated server

### clone and build

    git clone git://git.xonotic.org/xonotic/xonotic.git
    cd xonotic
    ./all update -p
    ./all update -l best
    ./all compile -r

### start the server

    ./all run dedicated xonotic
    
run in the background

    nohup ./all run dedicated xonotic >/dev/null 2>&1 &

### add server config

[xonotic/data/server.cfg](https://github.com/yogthos/cheatsheets/blob/master/server.cfg)

### add start script

`<path to>/xonotic/run-dedicated.sh`

    #!/bin/bash
    ./all run dedicated xonotic >/dev/null 2>&1

### add systemd service

add a service `/etc/systemd/system/xonotic.service`

```
[Unit]
Description=Xonotic
After=network.target

[Service]
WorkingDirectory=/<path to>/xonotic
Environment=""
ExecStart=/<path to>/xonotic/run-dedicated.sh
User=yogthos

[Install]
WantedBy=graphical.target
```

start dedicated server

    sudo systemctl start xonotic

