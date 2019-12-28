#!/bin/sh
date=`date "+%Y-%m-%d-%H%M%S"`
SRC=/media/pictures
DST=/mnt/backup/pictures

rsync -ax \
--delete \
--link-dest=../Latest \
$SRC $DST/Processing-$date \
&& cd $DST \
&& mv Processing-$date $date \
&& rm -f Latest \
&& ln -s $date Latest