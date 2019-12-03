#脚本功能：添加ssh-copy-id.sh批量传输密钥到远程服务器


#!/usr/bin/bash
###批量上传密钥
password=hlwztprd
for i in {2..254} ######批量获取ip地址
do
{
ip=192.28.1.$i
ping -c1 -W1 $ip &>/dev/null ####记录成功的ip
if [ $? = 0 ];then
echo "$ip">>ip.txt
EOF 交互内容容易出错,请注意
  /usr/bin/expect <<-EOF
  set timeout 10
  spawn ssh-copy-id -i /home/jenkins/.ssh/id_rsa.pub -p 22 hlwztprd@$ip   ##上传的密钥写全路径#
  expect {
          "yes/no" { send "yes\r";exp_continue }
           "password:" { send "$password\r" }
         }
  expect eof
EOF
fi
}&
done
wait
echo "fininsh.."

