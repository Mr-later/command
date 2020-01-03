功能：每天打包前一天的日志
version1
version2

##############
version1：
#!/bin/bash
#备份前一天数据
logpath=/app/icsapp/local/log/
bak_path=/app/icsapp/local/bak_log
bakdate=`date -d "1 day ago" +%Y-%m-%d`

if [ ! -d $bak_path ]; then
  mkdir -p $bak_path
fi
cd $logpath
nohup   tar  -zcvf  ${bak_path}/${bakdate}.tar.gz    *${bakdate}*.log  --remove-files > tar.log 2>&1 &

crontab -e
00 01 * * * /bin/bash /app/tar.sh


核心命令
nohup   tar  -zcvf  /app/icsapp/local/bak_log/`date -d "2 day ago" +%Y-%m-%d`.tar.gz    *`date -d "2 day ago" +%Y-%m-%d`*.log   > tar.log 2>&1 &



说明：
1.  tar.log 在logpath下
2.  cd $logpath;nohuap   tar  --remove-files -zcvf  ${bak_path}/${bakdate}.tar.gz    ./*${bakdate}*.log >/dev/null 2>&1 &
3.  有待改进的点：tar打包时间长 需等到全部打包完成有输出信息提示end  wait的用法
4.  ./*${bakdate}*.log 会有./
5.   希望有输出日志能看到打包到哪一步了，打印出日志。
    nohup   tar  -zcvf  ${bak_path}/${bakdate}.tar.gz    *${bakdate}*.log  --remove-files > tar.log 2>&1 &



##################################################
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
version1：不加判断，没有日志文件路径，不会创建备份文件路径；且 没有当天日志，也会打当天的包
version2：加入判断之后，没有日志文件路径，则不会创建备份文件路径；没有当天日志，也不会打当天的包


