最近服务器不太稳定,在查看日志时,会受到影响.
批量查看所有服务器的系统时间.
[jenkins@pjenkinsvapp uploadFile]$ cat showInfo.sh 
IPAddress=`ip a |grep "10[.].*" | awk -F '[ /]+' '{print $3}'`
nowDate=`date +"%Y-%m-%d %H-%M-%S"`
echo -e "${IPAddress}\t\t${nowDate}"

经常用于查看远程主机的信息,将输出信息输出到本机的log文件中
ssh -T icsapp@${i}  < echo.sh >>show.log