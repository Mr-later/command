THREAD_NUM=30
mkfifo tmp
exec 9<>tmp
rm -rf tmp
#预先写入指定数量的换行符，一个换行符代表一个进程
for ((i=0;i<$THREAD_NUM;i++))
do
    echo -ne "\n" 1>&9
done
if [ $# -gt 0 ];then
		while read line
		do
		{
			#进程控制
			read -u 9
			{
				echo $line     #这里可根据实际用途变化
				telstr=`(sleep 5;) | telnet $line`
				#echo $telstr
				if [[ $telstr =~ "^]" ]]
				then
					echo $line"连接正常！" >>passip.txt
				else
					echo $line"连接失败！" >>impassabilityip.txt
				fi
				echo -ne "\n" 1>&9
			} &
		}
		done < $1
		wait
		echo "测试完成！"
	else
		echo "请输入ip文档名称！"
fi

#初版
#将telnet的结果分成了两种情况，1.策略通且应用已经被占用，2.其他
#iptext.txt格式：
#     10.133.212.214 8001
#     10.133.212.214 8002
#     10.133.212.214 8009
#执行方式：sh telnet_1toN2_chi.sh iptext.txt


