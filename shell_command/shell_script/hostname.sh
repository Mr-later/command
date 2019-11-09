#execute this script in which has the  id_isa  of  other hosts.
#hosts.txt  is  args .  ($1 is the ip list which is splited by \n or \r\n)
#execute: sh  hostname.sh  hosts.txt
#-----
#在拥有私钥的机器上执行此脚本，区分用户，hosts.txt为远程主机列表，一行为一个ip
#执行方式：sh  hostname.sh  hosts.txt
#!/bin/bash
for HOST in `cat hosts.txt`
do
echo "${HOST}" >> hostname.txt
ssh user@${HOST}  -o "StrictHostKeyChecking no"  hostname >>  hostname.txt
echo '' >> hostname.txt
done


