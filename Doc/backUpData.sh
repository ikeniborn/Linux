#!/bin/sh
date=`date "+%Y-%m-%d-%H%M%S"`
SRC=/media/data
DST=/mnt/backup/data

rsync -ax \
--delete \
--link-dest=../Latest \
$SRC $DST/Processing-$date \
&& cd $DST \
&& mv Processing-$date $date \
&& rm -f Latest \
&& ln -s $date Latest