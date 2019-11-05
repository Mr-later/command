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
				telstr=`(sleep 2;) | telnet $line  2>&1`
		
                   echo "telstr:+++++++"
			       echo $telstr
                   echo  "---------"
				  
				if [[ $telstr =~ "^]" ]]
				then
					echo $line"success!" >>passip.txt
				elif [[ $telstr =~ "refuse" ]]
				then 
				    echo $line"refused!" >>refuse.txt
				else
					echo $line"fail!" >>impassabilityip.txt
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
#execute:  sh  telnet_1toN_eng.sh  iptext.txt
