批量打tar包文件夹(inode节点大量占用)-1
生产上报文数量过多,虽然每个文件占用空间大小不大,但是占用inode节点.故而想到将所有以日期命名的文件夹都打包.


$ cat  test.sh
#!/bin/bash
#需要打包的文件夹在/app/xml/abc/201900这个路径中
cd /app/xml/abc/201900
#dir均为以日期命名的文件夹
for dir  in  $(ls)
do
#打过包的文件也在此路径下，所以判断为文件夹的变量继续进行打包
  [ -d  $dir ] &&  tar zcf  ${dir}.tar.gz $dir
done

