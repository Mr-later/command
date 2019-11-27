THREAD_NUM=30
mkfifo tmp
exec 9<>tmp
rm -rf tmp

for ((i=0;i<$THREAD_NUM;i++))
do
    echo -ne "\n" 1>&9
done
if [ $# -gt 0 ];then
		while read line
		do
		{

			read -u 9
			{
				echo $line
#telstr=`(sleep 2;) | telnet $line  2>&1`

				sourceip=`echo "$line"  |  awk '{print $1}'`
				destip=`echo "$line"  |  awk '{print $2}'`
				destport=`echo "$line"  |  awk '{print $3}'`
				#echo $sourceip
				#echo $destip
				#echo $destport
telstr=`ssh  icsapp@$sourceip  "(sleep 0.5;) | telnet $destip $destport  2>&1" `
				echo $telstr

				if [[ $telstr =~ "^]" ]]
				then
					echo $line"ok!" >>passip.txt
				elif [[ $telstr =~ "refuse" ]]
				then
				    echo $line"no!" >>refuse.txt
				else
					echo $line"fail" >>impassabilityip.txt
				fi
				echo -ne "\n" 1>&9
			} &
		}
		done < $1
		wait
		echo "done!"
	else
		echo "doc_name?"
fi

#attention：确认源ip主机有操作主机的公钥用户，本脚本中使用的icsapp用户，遇到不同情况需修改为不同的用户
#执行位置：有源ip主机的私钥的主机上执行

#执行参数：
#$1:第一个位置变量，文件名自定义，执行脚本时加上即可

#$1的文本格式：source_ip dest_ip  dest_port
#10.0.41.194   10.0.32.215 80
#10.0.41.194   10.0.32.219 80
#10.0.41.195    10.0.32.139 7001

#执行方式：sh telnet_NtoN_eng.sh $1(比如telnet_NtoN.txt)

#执行结果：
#cat  impassabilityip.txt  refuse.txt  passip.txt
#10.0.59.187 10.0.60.47 80no
#10.0.59.187 172.10.10.10 80fail
#10.10.68.219 10.0.60.47 8000ok





