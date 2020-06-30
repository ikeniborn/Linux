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
SRCPCT='/media/pictures'
SRCDT='/media/data'
SCRVM='/media/ikeni/Virtual_HDD'
SCRGD='/home/ikeni/google-drive/ПК'
TGT='/mnt/bacula'
TGTMEDIA=$TGT'/media'
TGTHOME=$TGT'/home'
TGTHOMEIKENI=$TGTHOME'/ikeni'
TGTMEDIAIKENI=$TGTMEDIA'/ikeni'
TGTHOMEIKENIGOOGLEDRIVE=$TGTHOMEIKENI'/google-drive'

#Backup data
OLD_IFS=$IFS
IFS=$'\n'
echo  &>>$LOGFILE
echo '====================================================='  &>>$LOGFILE
echo 'Задание запущено в '`date +'%d-%b-%Y %R'` &>>$LOGFILE
echo '====================================================='  &>>$LOGFILE

echo 'Проверка каталогов' >>$LOGFILE

if ! [ -d $TGTMEDIA ]; then
mkdir -p $TGTMEDIA 
echo $TGTMEDIA' cоздан' >>$LOGFILE
  else 
  echo $TGTMEDIA' существует' >>$LOGFILE
fi

if ! [ -d $TGTHOME ]; then
  mkdir -p $TGTHOME 
  echo $TGTHOME' cоздан' >>$LOGFILE
else 
echo $TGTHOME' существует' >>$LOGFILE
fi

if ! [ -d $TGTMEDIAIKENI ]; then
mkdir -p $TGTMEDIAIKENI 
echo $TGTMEDIAIKENI ' cоздан' >>$LOGFILE
else 
echo $TGTMEDIAIKENI ' существует' >>$LOGFILE
fi

if ! [ -d $TGTHOMEIKENI ]; then
mkdir -p $TGTHOMEIKENI 
echo $TGTHOMEIKENI ' cоздан' >>$LOGFILE
else 
echo $TGTHOMEIKENI ' существует' >>$LOGFILE
fi

if ! [ -d $TGTHOMEIKENIGOOGLEDRIVE ]; then
mkdir -p $TGTHOMEIKENIGOOGLEDRIVE 
echo $TGTHOMEIKENIGOOGLEDRIVE ' cоздан' >>$LOGFILE
else 
echo $TGTHOMEIKENIGOOGLEDRIVE' существует' >>$LOGFILE
fi
echo 'Каталоги проверены' >>$LOGFILE

echo 'Обновление...' >>$LOGFILE

echo 'Обновление ' $TGT$SRCDT >>$LOGFILE
echo 'Запуск ' `date +'%d-%b-%Y %R'` >>$LOGFILE
rsync -azrqW --exclude '*/.Trash*' $SRCDT $TGTMEDIA;
echo 'Завершение ' `date +'%d-%b-%Y %R'` >>$LOGFILE

echo 'Обновление ' $TGT$SRCPCT >>$LOGFILE
echo 'Запуск ' `date +'%d-%b-%Y %R'` >>$LOGFILE
rsync -azrqW --exclude '*/.Trash*' $SRCPCT $TGTMEDIA; 
echo 'Завершение ' `date +'%d-%b-%Y %R'` >>$LOGFILE

echo 'Обновление ' $TGT$SCRGD >>$LOGFILE
echo 'Запуск ' `date +'%d-%b-%Y %R'` >>$LOGFILE
rsync -azrqW --exclude '*/.Trash*' $SCRGD $TGTHOMEIKENIGOOGLEDRIVE;
echo 'Завершение ' `date +'%d-%b-%Y %R'` >>$LOGFILE

echo 'Обновление ' $TGT$SCRVM >>$LOGFILE
echo 'Запуск ' `date +'%d-%b-%Y %R'` >>$LOGFILE
ls -p $SCRVM | grep -v / | xargs -I '{}' -P 2 -n1 rsync -azrqW --exclude '*/.Trash*' $SCRVM $TGTMEDIAIKENI;
echo 'Завершение ' `date +'%d-%b-%Y %R'` >>$LOGFILE

echo 'Копии обновлены' >>$LOGFILE

STATUS=$?
IFS=$OLD_IFS

if [[ $STATUS != 0 ]]; then
  echo '###########################################' &>>$LOGFILE;
  echo '###  Произошла ошибка! Бэкап не удался. ###' &>>$LOGFILE;
  echo '###########################################' &>>$LOGFILE;
else
  echo 'Размер исходного каталога '$SRCDT' - ' `du -h -s --exclude '*/.Trash*' $SRCDT | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGT$SRCDT' - ' `du -h -s --exclude '*/.Trash*' $TGT$SRCDT | awk '{print $1}'` &>>$LOGFILE
  echo 'Размер исходного каталога '$SRCPCT' - ' `du -h -s --exclude '*/.Trash*' $SRCPCT | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGT$SRCPCT' - ' `du -h -s --exclude '*/.Trash*' $TGT$SRCPCT | awk '{print $1}'`  &>>$LOGFILE
  echo 'Размер исходного каталога '$SCRVM' - ' `du -h -s --exclude '*/.Trash*' $SCRVM | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGT$SCRVM' - ' `du -h -s --exclude '*/.Trash*' $TGT$SCRVM | awk '{print $1}'`  &>>$LOGFILE
  echo 'Размер исходного каталога '$SCRGD' - ' `du -h -s --exclude '*/.Trash*' $SCRGD | awk '{print $1}'` &>> $LOGFILE
  echo 'Размер копии '$TGT$SCRGD' - ' `du -h -s --exclude '*/.Trash*' $TGT$SCRGD | awk '{print $1}'`  &>>$LOGFILE
  echo '====================================================='  &>>$LOGFILE
  echo 'Бэкап успешно завершен в '`date +'%d-%b-%Y %R'` &>>$LOGFILE;
  echo '====================================================='  &>>$LOGFILE
fi
exit
