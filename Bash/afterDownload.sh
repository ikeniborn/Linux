#!/bin/bash

#filename=$(transmission-remote -n transmission:transmission -l | grep Idle | awk '{for(i=10; i<NF; i++) printf "%s",$i OFS; if(NF) printf "%s",$NF; printf ORS}')
#fullpath=/media/film/Complete/New/$filename
transmission-remote -n transmission:transmission -l | grep Done > /media/film/list.txt
while IFS=" " read -r value1 remainder;do transmission-remote -n transmission:transmission -t $value1 --move /media/film/Complete/New/;done < /media/film/list.txt
