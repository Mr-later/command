这篇中是只需要expect password的,ssh远程主机只有提示password的

#!/usr/bin/bash

password=123456
for i in `cat host.txt`
do
{
ping -c1 -W1 $i &>/dev/null
if [ $? = 0 ];then
echo "$i">>ip.txt

  /usr/bin/expect <<-EOF
  set timeout 10
  spawn ssh-copy-id -i ~/.ssh/id_rsa.pub -p 22 root@$i
  expect {
           "password:" { send "$password\r" }
         }
  expect eof
EOF
fi
}&
done
wait
echo "fininsh.."

