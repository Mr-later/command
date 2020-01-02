inode节点大量占用 打tar包上传至其他服务器
脚本一:
$ cat BackupMessagefileXML_ABC.sh
#!/bin/sh

dirDomain=/app
dirBackup=$dirDomain/remote_xml/BACKUP
HostName=$(hostname)
nDateTime=$(date "+%Y%m%d%H%M")
nDateDir=$(date "+%Y%m%d")



echo "********NEW Procedure********"
echo "1. [$(date "+%Y%m%d %H:%M:%S")] Backup messagefile/$1 begin..."
if [ ! -d $dirBackup/$1 ]; then
  mkdir -p $dirBackup/$1
fi
lFilelist=$dirBackup/${1}_XML_FileList_${nDateTime}.txt
echo "2. [$(date "+%Y%m%d %H:%M:%S")] Backup messagefile/$1 find..."
find $dirDomain/xml/$1/ -maxdepth 1 -mindepth 1  -type d ! -newermt `date +"%y-%m-%d"` -print > $lFilelist
if [ $(wc -l $lFilelist|awk '{print $1}') = "0" ];then
  echo "[$(date "+%Y%m%d %H:%M:%S")] 娌℃ ?惧 1澶╁ ? ml?ユ ?
  rm $lFilelist
  exit 0
fi
echo "3. [$(date "+%Y%m%d %H:%M:%S")] $1/$(date '+%Y')/$(date '+%m')/$(date '+%d') xml files[$(wc -l $lFilelist|awk '{print $1}')]"
cat $lFilelist|while read line
do
  tar -czPvf $dirBackup/$1/${HostName}_${1}_${line##*/}.tar $line --remove-files >/dev/null
  echo "4. [$(date "+%Y%m%d %H:%M:%S")] Backup messagefile[$dirBackup/$1/${HostName}_${1}_${line##*/}.tar]."
done

rm $lFilelist
echo "5. [$(date "+%Y%m%d %H:%M:%S")] Backup messagefile/$1 end."

exit 0



脚本二:
$ cat /app/xml/ftp_upload.sh
#!/bin/bash
cd /app/xml

if [ `/bin/date +%H`  -eq 00 ] ;then
    dirdate=`date -d  '-1 day' +%Y%m%d`
else
    dirdate=`date +%Y%m%d`
fi




























































export dirdate
export updir=./abc/$dirdate

makedir=`find ./abc/$dirdate -type d -printf abc/$dirdate/'%P\n'| awk '{if ($0 == "")next;print "mkdir  "$0}'`
putfile=`find $updir -type f -printf "put %p abc/$dirdate/%P \n"`


/usr/bin/ftp -nv 10.10.68.199  <<EOF
user icsapp icsapp199
binary
prompt
$makedir
$putfile
bye
EO

