#cat initFilebeat.sh

base_path=/app/hlwztprd

filebeat_path=${base_path}/filebeat

cd ${base_path}

rm -rf filebeat-5.6.9-linux-x86_64

rm -rf filebeat

tar -zxf filebeat-5.6.9-linux-x86_64.tar.gz

mv filebeat-5.6.9-linux-x86_64 filebeat

cd ${filebeat_path}

cat <<EOF> filebeat.yml
filebeat.prospectors:
- input_type: log
  paths:
    - /app/hlwztprd/filebeat/log/*.log
fields_under_root: true
fields:
  host: ${serverip}
loadbalance: true
output.logstash:
  hosts: ["10.0.41.134:5044","10.0.41.135:5044","10.0.41.144:5044"]
EOF

echo " nohup ${filebeat_path}/filebeat -e -c ${filebeat_path}/filebeat.yml >${filebeat_path}/filebeat.log 2>&1 &" > startFilebeat.sh

echo "export serverip=`ip addr  |  grep "10.0" | grep  "inet" |  awk   '{print $2}' | awk -F"/" '{print$1}'`"  >> ~/.bash_profile

source ~/.bash_profile

echo ${serverip}





[jenkins@pjenkinsvapp uploadFile]$ cat install_filebeat.sh

shell=initFilebeat.sh
shell1='cd /app/hlwztprd; sh startFilebeat.sh'
shell2='echo "nohup /app/hlwztprd/filebeat/filebeat -e -c /app/hlwztprd/filebeat/filebeat.yml > /app/hlwztprd/filebeat/filebeat.log" > /app/hlwztprd/startFilebeat.sh'

scp filebeat-5.6.9-linux-x86_64.tar.gz  hlwztprd@10.0.40.99:/app/hlwztprd

ssh  hlwztprd@10.0.40.99  < ${shell}




[jenkins@pjenkinsvapp uploadFile]$ cat updateFilebeatyml.sh
base_path=/app/hlwztprd
filebeat_path=$base_path/filebeat
cd $filebeat_path
cat <<EOF >filebeat.yml
filebeat.prospectors:
- input_type: log
  paths:
    - /app/hlwztprd/filebeat/log/*.log
  ignore_older: 70h
  close_inactive: 1m
  close_removed: true
  clean_inactive: 72h
  clean_removed: true
  close_timeout: 3h
filebeat.spool_size: 256
fields_under_root: true
fields:
  host: $serverip
loadbalance: true
output.logstash:
  hosts: ["10.0.41.21:5044","10.0.40.187:5044","10.0.40.188:5044"]
EOF
echo '----------'
cat filebeat.yml
filebeatport=$(ps -ef | grep -v grep | grep "filebeat.yml" | sed -n '1P' | awk '{print $2}')
echo '----------'
echo "éœ²ä¸è¯¤? $filebeatport"
if [ "" != "$filebeatport" ]
    then
        kill -9 $filebeatport
fi
nohup $filebeat_path/filebeat -e -c $filebeat_path/filebeat.yml >$filebeat_path/filebeat.log 2>&1 &
echo "nohup $filebeat_path/filebeat -e -c $filebeat_path/filebeat.yml >$filebeat_path/filebeat.log 2>&1 &"
echo '####################################################################################################'
exit 0

ssh -t hlwztprd@10.0.67.122  < updateFilebeatyml.sh