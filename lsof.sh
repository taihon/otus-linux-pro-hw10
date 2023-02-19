#!/bin/bash

function getfdinfo(){
    ofs=$(ls -l $1|awk 'BEGIN {FS=" -> "}; {print $2}')
    procid=$(echo "$1"|cut -d '/' -f3)
    fd=$(echo "$1"|cut -d '/' -f5)
    exe=$(ls -l /proc/$procid/exe|awk 'BEGIN {FS=" -> "}; {print $2}')
    echo -e "${exe}\t${procid}\t${fd}\t${ofs}"    
}
export -f getfdinfo
echo -e "EXE\tPID\tFD\tFILE"
find /proc/[0-9]*/fd -type l -exec bash -c "getfdinfo \"{}\"" \;
exit 0