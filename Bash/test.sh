#!/bin/bash
g1= truncate --size=1K /mnt/bacula/backup.log
g2= ls -lsh ./Documents/Bash/test.sh | awk '{print $1}' |cut -d" " -f5
echo $g1-$g2
exit
