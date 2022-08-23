

curl https://raw.githubusercontent.com/dave0xE7/plug_scr/main/main.sh | bash


    1.Program START

    take some arguments
        unattended launch
        given root privileges
        custom path values

    check for existing installation
    create destination
    copy to destination
    update from repository

    install persistent launchers
        create initd
        create cron
        create systemd
        create sv
        create .bashrc



# host system identification and hardware description


plug init           # Initializes plug configuration files and generates a new keypair.

plug config         # get and set plug config values.
plug config show    # 

plug id             # show plug node id info
plug version        # show plug version info