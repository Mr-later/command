#!/bin/bash
for  i in `cat tel.txt`
do

#echo "$i --> $1 $2 filewalld policy"
echo "$i --> $1 $2 filewalld policy" >> telnet.log
#ssh  user@$i  "(sleep 0.5;) | telnet $1 $2  2>&1"
ssh  user@$i  "(sleep 0.5;) | telnet $1 $2  2>&1" >> telnet.log
#echo ''
echo '' >> telnet.log
done



#待改进,可操作成NtoN
#对于telnet的结果未作处理

#执行位置:在有远程主机的私钥的主机上执行脚本

#执行参数
#tel.txt:源端的ip,格式为:一个ip占用一行
#$1:目标端ip
#$2:目标端port

#执行结果:cat telnet.log
#10.0.41.198 --> 10.0.41.144 5044 filewalld policy
#Trying 10.0.41.144...
#Connected to 10.0.41.144.
#Escape character is '^]'.
#Connection closed by foreign host.

