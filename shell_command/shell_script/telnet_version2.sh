#难点: 主要在于 Telnet 完之后如何退出
#echo "(sleep 1;) | telnet $ip $port"
#        (sleep 1;) | telnet $ip $port >> result.txt
#可以实现Telnet之后自动退出的功能.

#成功ip的过滤：cut -d '.' -f 1,2,3,4
#由于telnet之后的ip结尾会多一个"."
#因此通过截取的方式过滤出ip.

#result.txt和 successIp 对比出result.txt有而successIp中没有的即为失败的ip
#cat result.txt successip.txt | sort | uniq -u |grep -v ^# > fail.txt




#一.批量Telnet不同ip的指定端口

#! /bin/bash
for i in `cat hosts`
do
sleep 1|telnet $i 22 >> telnet_result.txt
done
cat telnet_result.txt| grep -B 1 \] | grep [0-9] | awk '{print $3}' | cut -d '.' -f 1,2,3,4 > telnet_alive.txt
cat hosts telnet_alive.txt | sort | uniq -u > telnet_die.txt




#二.批量Telnet不同ip的不同端口

#!/bin/bash
for line in `cat "telnet_list.txt" |grep -v ^# |grep -v ^$ `
do
        ip=`echo $line | awk 'BEGIN{FS="|"} {print $1}'`
        port=`echo $line | awk 'BEGIN{FS="|"} {print $2}'`
        echo "(sleep 1;) | telnet $ip $port"
        (sleep 1;) | telnet $ip $port >> result.txt
        successIp=`cat result.txt | grep -B 1 \] | grep [0-9] | awk '{print $3}' | cut -d '.' -f 1,2,3,4`
        if [ -n "$successIp" ]; then
                echo "$successIp|$port" > successip.txt
        fi
done
cat result.txt successip.txt | sort | uniq -u |grep -v ^# > fail.txt


#执行参数：telnet_list.txt
#参数格式  ip|port



#bug是否可以改变以下语句解决，尚待验证：
#echo "$successIp|$port" > successip.txt
#改成echo $line >>successip.txt