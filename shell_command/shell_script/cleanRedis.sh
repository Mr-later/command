清理多套环境的redis缓存,同一key.

#清理同样的key,不同的环境(四套),$1为key
echo  '################################################################'
date +"%Y-%m-%d %H:%M:%S"
address[0]='ip0'
address[1]='ip1'
address[2]='ip2'
address[3]='ip3'
address[4]='ip4'
address[5]='ip5'
address[6]='ip6'
address[7]='ip7'
address[8]='ip8'
address[9]='ip9'
address[10]='ip10'
address[11]='ip11'

for i in ${address[@]}
do
    echo "${i}"
    /redis/redis-cli -h ${i} -p 6379 eval "local keys = redis.call('keys', ARGV[1])  for i=1,#keys,5000 do  redis.call('del', unpack(keys, i, math.min(i+4999, #keys)))  end  return keys" 0  *${1}*
done



