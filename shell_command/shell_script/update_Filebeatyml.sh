# cat updateFilebeatyml.sh

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
  hosts: ["ip1:5044","ip2:5044","ip3:5044"]
EOF
echo '----------'
cat filebeat.yml
filebeatport=$(ps -ef | grep -v grep | grep "filebeat.yml" | sed -n '1P' | awk '{print $2}')
echo '----------'
echo "占用端口$filebeatport"
if [ "" != "$filebeatport" ]
    then
        kill -9 $filebeatport
fi
nohup $filebeat_path/filebeat -e -c $filebeat_path/filebeat.yml >$filebeat_path/filebeat.log 2>&1 &
echo "nohup $filebeat_path/filebeat -e -c $filebeat_path/filebeat.yml >$filebeat_path/filebeat.log 2>&1 &"
echo '####################################################################################################'
exit 0


#脚本功能:在多个远程主机已经启动了filebeat的情况下,改掉配置文件,并重新启动应用

#在jenkins中执行以下命令是会直接有回显结果的
#有多个ip可以直接写多行
ssh -t user@ip  < updateFilebeatyml.sh