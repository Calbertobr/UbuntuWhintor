#!/bin/bash

update(){
    sleep 1800
    apt update >>/dev/null
    apt upgrade -y >>/dev/null
    date>>/var/log/Process.log
}
update &

