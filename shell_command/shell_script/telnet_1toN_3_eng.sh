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
#				echo $line
				telstr=`(sleep 2;) | telnet $line  2>&1`

#                   echo "telstr:+++++++"
#			       echo $telstr
#                   echo  "---------"

				if [[ $telstr =~ "^]" ]]
				then
					echo $line "success!" >>passip.txt
				elif [[ $telstr =~ "refuse" ]]
				then
				    echo $line "refuse!" >>refuse.txt
				else
					echo $line "fail!" >>impassabilityip.txt
				fi
				echo -ne "\n" 1>&9
			} &
		}
		done < $1
		wait
		echo "done"
	else
		echo "doc_name?"
fi

#from one host telnet  many  ip  and different  ports
#$1 is args
#$1 format :  destip destport
#$1 forexample:  
#              cat  iptext.txt
#				 10.133.212.214 8001
#                10.133.212.214 8002
#                10.133.212.214 8009
#execute:  sh  telnet_1toN_3_eng.sh  iptext.txt

#------
#执行位置：在源ip主机执行脚本

#说明：此脚本在原有基础上添加了elif判断，将防火墙已通但是目标端口未占用的划分出来;将结果分成了三种情况分析.

#执行参数：
#位置变量$1为iptext.txt
#$1的格式为： 远程ip 空格 远程端口.一个（远程ip 空格 远程端口）占用一行.

#执行方式：sh  telnet_1toN_3_eng.sh  iptext.txt

