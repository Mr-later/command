#execute this script in which has the  id_isa  of  other hosts.
#hosts.txt  is  args .  ($1)
#execute: sh  hostname.sh  hosts.txt

#!/bin/bash
for HOST in `cat hosts.txt`
do
echo "${HOST}" >> hostname.txt
ssh user@${HOST}  -o "StrictHostKeyChecking no"  hostname >>  hostname.txt
echo '' >> hostname.txt
done


