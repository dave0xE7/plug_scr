#!/usr/bin/env bash




if [ -d /etc/systemd/system ]; then
    # if body
    if [ ! -f "/etc/systemd/system/plug.service" ]; then
        
        echo "[Unit]
Description=TPservice
#Documentation=man:sshd(8) man:sshd_config(5)
#After=network.target auditd.service
#ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
User=root
#EnvironmentFile=-/etc/default/ssh
#ExecStartPre=/usr/sbin/sshd -t
ExecStart=${PLUG_DEST}/main.sh daemon worker
#ExecReload=/usr/sbin/sshd -t
#ExecReload=/bin/kill -HUP $MAINPID
#KillMode=process
#Restart=on-failure
#RestartPreventExitStatus=255
#Type=notify
#RuntimeDirectory=sshd
#RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
#Alias=sshd.service" > "/etc/systemd/system/plug.service"

        systemctl daemon-reload
        systemctl enable plug
        systemctl restart plug

    else
        echo "File \"/etc/systemd/system/plug.service\" exists"
    fi

else
    # else body
    echo "no systemd found"
fi
