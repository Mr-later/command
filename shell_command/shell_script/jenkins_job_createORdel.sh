一.使用api创建jenkins的job
二.使用api删除jenkins的job

job.txt是另一个源jenkins中的需要迁移的job名称
本例演示的源和目标job的名称一样,未发生改变

1.1
jenkins_home为/app/jenkins时:
#!/bin/bash
for i in `cat job.txt`
do
curl -XPOST -u admin:admintest http://10.0.59.187:8080/createItem?name=${i} --data-binary "@/app/jenkins/jobs/${i}/config.xml" -H "Content-Type: text/xml"
done

1.2
#存放config.xml路径为/home/jenkins时:
#!/bin/bash
for i in `cat job.txt`
do
curl -XPOST -u admin:admintest http://10.0.59.187:8080/createItem?name=${i} --data-binary "@/home/jenkins/${i}/config.xml" -H "Content-Type: text/xml"
done


二.删除job
curl -XPOST -u admin:15245772130 http://[IP]:[PORT]/job/[job_name]/doDelete
