#!/bin/bash
#Logs
DATE=`date +'%d'`
LOGFILE=/mnt/bacula/backup.log
if [[ -w $LOGFILE ]];then
  rm $LOGFILE
else
  touch $LOGFILE
fi

#Parametrs
BACKUPTIME=`date +'%d-%b-%Y %R'`
PCT='/pictures'
DT='/data'
VM='/VirtualBox VMs'
SRCPCT='/media/pictures'
SRCDT='/media/data'
SCRVM='/home/ikeni/VirtualBox VMs'
TGT='/mnt/bacula'
TGTPCT=$TGT$PCT
TGTDT=$TGT$DT
TGTVM=$TGT$VM

#Backup data
OLD_IFS=$IFS
IFS=$'\n'
echo  &>>$LOGFILE
echo '====================================================='  &>>$LOGFILE
echo $BACKUPTIME &>>$LOGFILE
echo 'Задание запущено...' &>>$LOGFILE

if [[ $DATE = 1 ]]; then
  echo 'Удаление старого архива '$TGTDT &>>$LOGFILE;
  rm -rf $TGTDT &>>$LOGFILE;
  echo 'Удаление старого архива '$TGTPCT &>>$LOGFILE;
  rm -rf $TGTPCT &>>$LOGFILE;
  echo 'Удаление старого архива '$TGTVM &>>$LOGFILE;
  rm -rf $TGTVM &>>$LOGFILE;
  echo 'Создание копии...' >>$LOGFILE
  rsync -azrqW --exclude '*/.Trash*' $SRCDT $TGT & rsync -azrqW --exclude '*/.Trash*' $SRCPCT $TGT \
  & rsync -azrqW --exclude '*/.Trash*' $SCRVM $TGT;
  echo 'Копии созданы' >>$LOGFILE
else
  echo 'Обновление...' >>$LOGFILE
  rsync -azrqW --exclude '*/.Trash*' $SRCDT $TGT & rsync -azrqW --exclude '*/.Trash*' $SRCPCT $TGT \
  & rsync -azrqW --exclude '*/.Trash*' $SCRVM $TGT;
  echo 'Копии обновлены' >>$LOGFILE
fi

STATUS=$?
IFS=$OLD_IFS

if [[ $STATUS != 0 ]]; then
  echo '###########################################' &>>$LOGFILE;
  echo '###  Произошла ошибка! Бэкап не удался. ###' &>>$LOGFILE;
  echo '###########################################' &>>$LOGFILE;
else
  echo 'Размер исходного каталога '$SRCDT' - ' `du -h -s --exclude '*/.Trash*' $SRCDT | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGTDT' - ' `du -h -s --exclude '*/.Trash*' $TGTDT | awk '{print $1}'` &>>$LOGFILE
  echo 'Размер исходного каталога '$SRCPCT' - ' `du -h -s --exclude '*/.Trash*' $SRCPCT | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGTPCT' - ' `du -h -s --exclude '*/.Trash*' $TGTPCT | awk '{print $1}'`  &>>$LOGFILE
  echo 'Размер исходного каталога '$SCRVM' - ' `du -h -s --exclude '*/.Trash*' $SCRVM | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGTVM' - ' `du -h -s --exclude '*/.Trash*' $TGTVM | awk '{print $1}'`  &>>$LOGFILE
  echo 'Бэкап успешно завершен в '`date +'%d-%b-%Y %R'` &>>$LOGFILE;
fi
exit
