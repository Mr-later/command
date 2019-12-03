脚本适用性说明:脚本置于elasticsearch机器上为127.0.0.1,若是其他机器上则是elasticsearch服务器ip地址.

功能:清除elasticsearch日志指定日期之前的所有日志,只要是包含指定的日期,无论是何种类型的都会被删除(logstash 或者kibana monitor)

脚本内容:
[root@tLogstgvapp2 icsapp]# cat qingrizhitest.sh
#/bin/bash
#指定日期(当前日期5天-50天前)
for i in {5..50}
do
#DATE为$i天以前的日期,%Y.%m.%d对$i天以前的日期格式化
DATE=`date -d "$i day ago" +%Y.%m.%d`
#time为当前日期
time=`date`
echo ${DATE}
#删除5天前的日志
curl -XGET "http://127.0.0.1:9200/_cat/indices/?v"|grep $DATE > /dev/null
if [ $? == 0 ];then
  curl -XDELETE "http://127.0.0.1:9200/*-${DATE}"  > /dev/null
  echo "于 $time 清理 $DATE 索引"
fi
done


计划任务:
crontab -e 添加如下内容
#0 1 * * *　/bin/sh /root/shscript/ES-index-clear.sh
