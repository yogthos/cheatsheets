## using keybase gpg key

    keybase pgp export | gpg --import
    keybase pgp export --secret | gpg --allow-secret-key-import --import
    
may need to set tty for the password prompt:

    export GPG_TTY=`tty`
