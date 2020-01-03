
Version2：
优化脚本如下 加入判断语句
#1. 如果存在日志文件路径，再创建备份文件路径
#2.如果在日志文件路径下 不存在要备份的当天的数据，不执行备份命令，输出不存在信息到tar.log，因为没有当天日志文件不加判断也会生成打包日志文件，只是包里内容为空，此时直接不打包
#!/bin/bash
logpath=/app/icsapp/local/log/
bak_path=/app/icsapp/local/bak_log
bakdate=`date -d "1 day ago" +%Y-%m-%d`


if [  -d ${logpath} ]; then
		if [ ! -d ${bak_path} ]; then
			mkdir -p ${bak_path}
		fi
		cd ${logpath}
		ls | grep ${bakdate} > /dev/null
	    if [ $? == 0 ];then
				nohup   tar  -zcvf  ${bak_path}/${bakdate}.tar.gz *${bakdate}*.log  --remove-files >> ~/tar.log 2>&1 &
			else
				echo "no log ${bakdate}" exist  >>  ~/tar.log
      fi
else
  echo  "no ${logpath} exist"  >> ~/tar.log
fi

优化前后对比
不加判断，没有日志文件路径，不会创建备份文件路径；且 没有当天日志，也会打当天的包
加入判断之后，没有日志文件路径，则不会创建备份文件路径
