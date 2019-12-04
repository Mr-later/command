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

#source 执行 使serverip生效
source ~/.bash_profile
echo ${serverip}

#执行 startFilebeat.sh脚本,若要是将init与start分开则将此行摘出来即可,单独放置一个脚本.
cd ${filebeat_path}; sh startFilebeat.sh


#脚本说明:
#描述:在A主机远程B1,B2,B3主机，安装filebeat并配置

#第一步：将安装包传至远程服务器
#scp filebeat-5.6.9-linux-x86_64.tar.gz  hlwztprd@10.0.40.99:/app/hlwztprd
#第二步：调用init_start_Filebeat.sh脚本,将远程主机的配置配好 并 启动服务.
ssh  user@ip  < init_start_Filebeat.sh >show.log
#第三步:在远程主机验证 ps  -ef  |  grep filebeat 时有没有进程的情况,此时重新开启一个终端登录即可.


#问题:
#写入远程主机中的filebeat.yml文件中的变量${serverip}到远程主机中查看时已经成为了ip字符串


