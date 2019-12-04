systeminfo.sh查看系统内存,ip,内存使用率,cpu,tcp连接数
#cat systeminfo.sh
#获取内存使用率
mem_pused=`/usr/bin/free -m | sed -n '2p'|awk '{ print ($3+$6)/$2*100}'`
#获取ip（以10开头的）
IPAddress=`ip a |grep "10[.].*" | awk -F '[ /]+' '{print $3}'`
#磁盘使用率
risk=`df -h | grep -E "/$" |awk -F '[ G]+' '{print $4"/"$3}'`
if [[ -d /app  ]];then
   risk=`df -h | grep -E "/App$" |awk -F '[ G]+' '{print $4"/"$3}'`
fi
#tcp连接数
tcpConnection=`netstat -na|grep ESTABLISHED|wc -l`
#内存总量
mem_all=$((`/usr/bin/free -g | sed -n '2p' |awk '{print $2}'`/1+1))
#cpu数量
cpu=`top -bn 1 -i -c|grep "us,"|awk '{print $2}'`
echo -e "\t${IPAddress}\t${mem_all}\t${mem_pused}\t${cpu}\t${tcpConnection}\t${risk}"
#获取系统版本
#version=`cat /etc/redhat-release`
#echo -e "\t${IPAddress}\t${mem_all}\t${mem_pused}\t${cpu}\t${tcpConnection}\t${risk}\t${version}"
#获取系统时间
#date=`date +%Y%m%d-%H:%M:%S`
#echo -e "\t${IPAddress}\t${mem_all}\t${mem_pused}\t${cpu}\t${tcpConnection}\t${risk}\t${date}"



经常用于查看远程主机的信息,将输出信息输出到本机的log文件中
ssh -T icsapp@${i}  < systeminfo.sh >>show.log


当主机多的时候,可以多谢几行,也可以将ip列表写入到文本文件中,然后写脚本从host.txt文件中读取ip
比如:以下脚本

#主机列表写于host.txt
-bash-4.2$ cat ssh.sh
#!/bin/bash
>show.log
for i in `cat host.txt`
do
ssh -T icsapp@${i}  < echo.sh >>show.log
sleep 1s


