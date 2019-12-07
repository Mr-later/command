#清理日期最早的一天的elasticsearch日志

#!/bin/bash
#获取最早一天的日志索引名称
logst=`curl -XGET 'http://127.0.0.1:9200/_cat/indices/?v' |sort | grep 'logstash-20' | head -1  | awk '{print $3}'`
sleep 3
echo ${logst}
#删除获取到的最早一天的日志索引
curl -XDELETE  http://127.0.0.1:9200/${logst}