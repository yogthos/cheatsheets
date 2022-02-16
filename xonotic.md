setting permissions on macOS:

    sudo xattr -r -d com.apple.quarantine "/path/to/Xonotic.app"
    
setting up a dedicated server

### clone and build

    git clone git://git.xonotic.org/xonotic/xonotic.git
    cd xonotic
    ./all update -p
    ./all compile -r

### start the server

    ./all run dedicated xonotic
    
run in the background

    nohup ./all run dedicated xonotic >/dev/null 2>&1 &
