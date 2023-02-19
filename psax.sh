#!/bin/bash

function getprocinfo(){
    echo -n $(echo "$1"|cut -d '/' -f 3)
    echo -n -e '\t\t'
    if [[ $(awk '{print $7}' $1/stat) = 0 ]]; then
    echo -n -e "?\t\t"
    else
    TTYSTR=$(ls -l $1/fd| grep -E 'tty|pts' |awk 'BEGIN {FS=" -> "} ; { gsub("/dev/","",$2) ; print $2}'|uniq|head -n 1)
    echo -n "$TTYSTR"
    if echo $TTYSTR|grep -E -q '\/'; then
    echo -n -e '\t'
    else
    echo -n -e '\t\t'
    fi
    fi
    echo -n $(cat $1/stat|cut -d ' ' -f 3)
    echo -n -e '\t\t'
    echo -n $(date -u -d @$(( $(cat $1/stat|awk '{print $14+$15}') / 100 )) +"%-M:%S")
    echo -n -e '\t\t'
    if [ -z "$(tr -d '\0' < $1/cmdline )" ] ; then
    echo "[$(cat $1/comm)]"
    else
    echo "$(cat $1/cmdline|tr '\000' ' ')"
    fi
}
export -f getprocinfo
printf '\033[?7l'
echo -e "PID\t\tTTY\t\tSTAT\tTIME\t\tCMDLINE"
find /proc -type d -regex '^/proc/[0-9]+$' -exec bash -c "getprocinfo \"{}\"" \;
printf '\033[?7h'
