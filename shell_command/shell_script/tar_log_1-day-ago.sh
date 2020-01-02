功能：每天打包前一天的日志

[root@tstgsjjhvapp ~]# cat tar.sh
#!/bin/bash
logpath=/app/icsapp/local/log/
bak_path=/app/icsapp/local/bak_log
bakdate=`date -d "1 day ago" +%Y-%m-%d`

if [ ! -d $bak_path ]; then
  mkdir -p $bak_path
fi
cd $logpath
nohup   tar  -zcvf  ${bak_path}/${bakdate}.tar.gz    *${bakdate}*.log  --remove-files > tar.log 2>&1 &


说明：
1.  tar.log 在logpath下
2.  cd $logpath;nohuap   tar  --remove-files -zcvf  ${bak_path}/${bakdate}.tar.gz    ./*${bakdate}*.log >/dev/null 2>&1 &
3.  有待改进的点：tar打包时间长 需等到全部打包完成有输出信息提示end  wait的用法
4.  ./*${bakdate}*.log 会有./
5.   希望有输出日志能看到打包到哪一步了
    nohup   tar  -zcvf  ${bak_path}/${bakdate}.tar.gz    *${bakdate}*.log  --remove-files > tar.log 2>&1 &
