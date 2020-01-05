功能:使用nslookup命令批量将域名解析为ip
一使用shell脚本,二使用python脚本,三域名IP使用sed替换

一.批量查询域名解析shell脚本
1.先配置好DNS:
# cat /etc/resolv.conf
nameserver 114.114.114.114

2.在Linux安装nslookup命令:
yum install -y bind-utils

3.输入参数为一个文件,文件里面是域名列表,输出为IP和域名的键值对
[root@node2 data]# cat yuming.txt
www.baidu.com
www.powerdns.com

[root@node2 data]# chmod +x jiexi.sh

4.执行方式
[root@node2 data]# ./jiexi.sh yuming.txt
www.baidu.com	www.a.shifen.com.
www.powerdns.com	188.166.104.92

5.脚本内容
[root@node2 data]# cat jiexi.sh
#!/bin/bash
function lookupSingleIp(){
  for ip in $@;
  do
    [[ -z $ip ]] && continue;
    panduan=`nslookup $ip | egrep 'name.*='`
    if [ ! -z $panduan ]; then
        domain=`nslookup $ip | egrep 'name.*=' |  awk '{if(NR==1) print $NF}'`  #查询cname地址,如果只需查询IP地址可屏蔽这一句,使用下面的方法
    else
        domain=`nslookup $ip  | egrep 'Address:' |  awk '{if(NR==2) print $NF}'` #查询IP地址
    fi
    echo  "$ip	$domain"   #如果想把输出结果输出到文件中,可追加重定向到文件中.
  done
}

cat $1 | while read line
do
 [[ -n $line ]] && lookupSingleIp $line;
done


二.批量查询域名解析python查询

1.执行方式
[root@node2 data]# python pyjiexi.py

2.执行结果
[root@node2 data]# cat result.txt
www.baidu.com 115.239.210.27
www.powerdns.com 188.166.104.92

3.脚本内容
[root@node2 data]# cat pyjiexi.py
#!/usr/bin/env python
#coding:utf-8

from socket import gethostbyname
DOMAIN= "yuming.txt"

with open(DOMAIN,'r') as f:

     for line in f.readlines():
        try:
            host = gethostbyname(line.strip('\n'))  #域名反解析得到的IP
        except Exception as e:
            with open('error.txt','a+') as ERR:  #error.txt为没有IP绑定的域名
                ERR.write(line.strip()+ '\n')
        else:
            with open('result.txt','a+') as r: #result.txt里面存储的是批量解析后的结果
                r.write(line.strip('\n') + ' ')   #显示有ip绑定的域名,用空格隔开
                r.write(host + '\n')


三.将域名替换为IP
直接利用sed命令,将找到的域名转换为对应的ip
#cat sed.sh
sed  -i   's/域名/ip/g'     123.txt