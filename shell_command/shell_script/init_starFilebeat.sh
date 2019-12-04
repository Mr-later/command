[icsapp@tyhxuatvapp2 fi]$ cat initFilebeat.sh
base_path=/app/icsapp
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
  hosts: ["10.10.68.172:5044"]
EOF
echo " nohup ${filebeat_path}/filebeat -e -c ${filebeat_path}/filebeat.yml >${filebeat_path}/filebeat.log 2>&1 &" > startFilebeat.sh
echo "export serverip=`ip addr  |  grep "10.10" | grep  "inet" |  awk   '{print $2}' | awk -F"/" '{print$1}'`"  >> ~/.bash_profile
source ~/.bash_profile
echo ${serverip}
cd ${filebeat_path}; sh startFilebeat.sh


#描述:在A主机远程B1,B2,B3主机，安装filebeat并配置