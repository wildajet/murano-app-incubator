#!/bin/bash

function include(){
    curr_dir=$(cd $(dirname "$0") && pwd)
    inc_file_path=$curr_dir/$1
    if [ -f "$inc_file_path" ]; then
        . $inc_file_path
    else
        echo -e "$inc_file_path not found!"
        exit 1
    fi
}
include "common.sh"

get_os
[[ $? -ne 0 ]] && exit 1
if [[ "$DistroBasedOn" != "redhat" ]]; then
    DEBUGLVL=4
    log "ERROR: We are sorry, only \"redhat\" based distribution of Linux supported for this service type, exiting!"
    exit 1
fi

bash installer.sh -p sys -i "tomcat tomcat-webapps tomcat-admin-webapps"

add_fw_rule '-I INPUT 1 -p tcp -m tcp --dport 8080 -j ACCEPT -m comment --comment "by murano, Tomcat"'

systemctl enable tomcat.service
systemctl start tomcat.service

