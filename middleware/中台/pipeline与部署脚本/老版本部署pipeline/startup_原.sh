#!/bin/sh
#应用 jar包
jar=$1'.jar'
#配置文件 yml全名
yml=$1'.yml'
#配置 环境dat、sit、uat、stg
active=$2
#端口号
port=$3
#计数 伪时间（秒）
count=30
#默认路径
url=$(echo "/app/`whoami`/${active}")
#tomcat 启动参数
tomcat="-Doracle.jdbc.DateZeroTime=true"$4
#输出 所有参数 检查是否正确
echo -e "\033[35m\njar:\t${jar}\nyml:\t${yml}\nurl:\t${url}\nactive:\t${active}\nport:\t${port}\ntomcat:\t${tomcat}\033[0m"
#记录当前 路径
nowUrl=`pwd`
echo -e "\033[35m\n当前路径${nowUrl}\033[0m"

#根据 端口号 查询 pid
pid=$(/usr/sbin/lsof -i:${port} | awk '{print $2}' | awk 'NR==2')
if [ "$pid" != "" ]
    then
		echo  "程序已运行 当前pid:$pid"
		echo -e "\033[35mcurl  --connect-timeout 10 -m 5 -d '' '127.0.0.1:$port/shutdown'\033[0m"
        curl  --connect-timeout 10 -m 5 -d '' "127.0.0.1:$port/shutdown"
		echo -e "\n"
		while( true )
		do
			pid=$(/usr/sbin/lsof -i:${port} | awk '{print $2}' | awk 'NR==2')
			if [ "$pid" != "" ]
			then
				if [ $count -le 0 ]
				then
					echo -e "\033[35m执行 kill -9 $pid\033[0m"
                        kill -9 $pid
					break;
				else
					echo "$count 未结束   pid:$pid"
					sleep 1s
				fi
			else
				echo "已结束。"
				break;
			fi
			let "count--"
		done
    else
        echo -e '\033[35m未运行。\033[0m'
    fi
echo -e "\033[35mnohup java ${tomcat} -jar ${url}/${jar} --spring.config.location=file:${url}/$yml --spring.profiles.active=$active >/dev/null 2>&1 &\033[0m"
nohup java ${tomcat} -jar ${url}/${jar} --spring.config.location=file:${url}/$yml --spring.profiles.active=$active >/dev/null 2>&1 &
echo "脚本执行完成。。。"