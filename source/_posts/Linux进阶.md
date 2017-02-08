title: Linux进阶
date: 2015-09-05 20:24:46
categories: [Linux]
tags: [Linux,vim]
---
welcome to you

## Linux skill

### command

1. Linux系统中的/proc文件系统有什么用？
/proc文件系统是一个基于内存的文件系统，其维护着关于当前正在运行的内核状态信息，其中包括CPU、内存、分区划分、I/O地址、直接内存访问通道 和正在运行的进程
2. 如何在/usr目录下找出大小超过10MB的文件？
find /usr -size +10M
3. 如何在/home目录下找出120天之前被修改过的文件？
find /home -mtime +120
4. 如何在/var目录下找出90天之内未被访问过的文件？
find /var \! -atime -90
5. 整个目录树下查找文件core，如发现则无需提示直接删除它们
find / -name core -exec {} \;
6. ll | awk {print $3,owns,$9} 这条命令是在做什么？
7. Linux中的at命令有什么用？
at命令用来安排一个程序在未来的做一次一次性执行。所有提交的任务都被放在 /var/spool/at 目录下并且到了执行时间的时候通过atd守护进程来执行。
8. linux中lspci命令的作用是什么？
lspci命令用来显示你的系统上PCI总线和附加设备的信息。
9. export PS1 = `$LOGNAME@hostname:\$PWD:` 这条命令是在做什么？
这条export命令会更改登录提示符来显示用户名、本机名和当前工作目录。
10. CSSViewer
它有一个浮动面板，上面不但指明鼠标所在之地的身份，还提供其字体、文本、颜色、背景、框、定位和效果属性的说明。 CSSViewer可以快速提供你所需要的基本CSS信息。
11. Vim 会记录文件的更改，你很容易可以回退到之前某个时间。该命令是相当直观的。比如： :earlier 1m
会把文件回退到 1 分钟以前的状态。
可以使用下面的命令进行相反的转换：:later
12. ls *[0-9]* 显示包含数字的文件名和目录名
13. tree 显示文件和目录由根目录开始的树形结构(1)
lstree 显示文件和目录由根目录开始的树形结构(2)
14. cp dir/* . 复制一个目录下的所有文件到当前工作目录
cp -a /tmp/dir1 . 复制一个目录到当前工作目录
cp -a dir1 dir2 复制一个目录
15. ln -s file1 lnk1 创建一个指向文件或目录的软链接
ln file1 lnk1 创建一个指向文件或目录的物理链接

### find

find /home/user1 -name \*.bin 在目录 '/ home/user1' 中搜索带有'.bin' 结尾的文件
find /usr/bin -type f -atime +100 搜索在过去100天内未被使用过的执行文件
find /usr/bin -type f -mtime -10 搜索在10天内被创建或者修改过的文件
find / -name \*.rpm -exec chmod 755 '{}' \; 搜索以 '.rpm' 结尾的文件并定义其权限
locate \*.ps 寻找以 '.ps' 结尾的文件 - 先运行 'updatedb' 命令
whereis halt 显示一个二进制文件、源码或man的位置
which halt 显示一个二进制文件或可执行文件的完整路径
17. useradd -s /bin/sh -d /usr/gem -g group –G adm,root gem
新建了一个用户gem，该用户的登录Shell是/bin/sh，它属于group用户组，同时又属于adm和root用户组，group用户组是其主组
18. tar -xvf archive.tar -C /tmp 将压缩包释放到 /tmp目录下
19. tar -zcvf archive.tar.gz dir1 创建一个gzip格式的压缩包
20. 
dos2unix filedos.txt fileunix.txt 将一个文本文件的格式从MSDOS转换成UNIX
unix2dos fileunix.txt filedos.txt 将一个文本文件的格式从UNIX转换成MSDOS
21. 文本处理
cat file1 file2 ... | command <> file1_in.txt_or_file1_out.txt general syntax for text manipulation using PIPE, STDIN and STDOUT

cat file1 | command( sed, grep, awk, grep, etc...) > result.txt 合并一个文件的详细说明文本，并将简介写入一个新文件中

cat file1 | command( sed, grep, awk, grep, etc...) >> result.txt 合并一个文件的详细说明文本，并将简介写入一个已有的文件中
### grep 
grep Aug /var/log/messages 在文件 '/var/log/messages'中查找关键词"Aug"
grep ^Aug /var/log/messages 在文件 '/var/log/messages'中查找以"Aug"开始的词汇
grep [0-9] /var/log/messages 选择 '/var/log/messages' 文件中所有包含数字的行
grep Aug -R /var/log/* 在目录 '/var/log' 及随后的目录中搜索字符串"Aug"

### sed

sed 's/stringa1/stringa2/g' example.txt 将example.txt文件中的 "string1" 替换成 "string2"
sed '/^$/d' example.txt 从example.txt文件中删除所有空白行
sed '/ *#/d; /^$/d' example.txt 从example.txt文件中删除所有注释和空白行
echo 'esempio' | tr '[:lower:]' '[:upper:]' 合并上下单元格内容
sed -e '1d' result.txt 从文件example.txt 中排除第一行
sed -n '/stringa1/p' 查看只包含词汇 "string1"的行
sed -e 's/ *$//' example.txt 删除每一行最后的空白字符
sed -e 's/stringa1//g' example.txt 从文档中只删除词汇 "string1" 并保留剩余全部
sed -n '1,5p;5q' example.txt 查看从第一行到第5行内容
sed -n '5p;5q' example.txt 查看第5行
sed -e 's/00*/0/g' example.txt 用单个零替换多个零
cat -n file1 标示文件的行数
cat example.txt | awk 'NR%2==1' 删除example.txt文件中的所有偶数行
echo a b c | awk '{print $1}' 查看一行第一栏
echo a b c | awk '{print $1,$3}' 查看一行的第一和第三栏
paste file1 file2 合并两个文件或两栏的内容
paste -d '+' file1 file2 合并两个文件或两栏的内容，中间用"+"区分
sort file1 file2 排序两个文件的内容
sort file1 file2 | uniq 取出两个文件的并集(重复的行只保留一份)
sort file1 file2 | uniq -u 删除交集，留下其他的行
sort file1 file2 | uniq -d 取出两个文件的交集(只留下同时存在于两个文件中的文件)
comm -1 file1 file2 比较两个文件的内容只删除 'file1' 所包含的内容
comm -2 file1 file2 比较两个文件的内容只删除 'file2' 所包含的内容
comm -3 file1 file2 比较两个文件的内容只删除两个文件共有的部分
22.
ifconfig eth0 显示一个以太网卡的配置
ifup eth0 启用一个 'eth0' 网络设备
ifdown eth0 禁用一个 'eth0' 网络设备
ifconfig eth0 192.168.1.1 netmask 255.255.255.0 控制IP地址
## UML skill
开发模型： 瀑布模型 螺线模型  增量模型
黑盒测试：考虑程序的功能，而不是实际代码
百合测试：通过程序代码来设计测试数据，使测试数据能很好覆盖语句及执行路径
泛化绘制为从孩子指向双亲的空三角箭头
泛化使多态操作成为可能，即操作的实现方法由实际对象的类来决定
内部类可以看成是服务类的特殊形式，即类可以服务包含它的外部类，内部类作为外部类的一部分，可以提取器外部类的私有属性
如果多个活动者之间存在很多共性，就可以使用泛化来分解共性行为。
与包含关系不同，在扩展关系中，箭头的方向是从扩展用例到基用例。
通过多态，一个通用接口可以实现不同的行为特征
关联用一条无线线段表示，代表一种双向关系

## vim skill

U可以撤销一行的改变
u命令和ctrl-R来撤销和重做
w 2w  b 2b  向前或者向后移动word个长度   e 到达当前单词的末尾
fx 在当前航搜寻字符 
%匹配跳转
/the\> 匹配以the结尾的单词  /\<the 匹配以the开头的单词  
/\<the\>匹配the
set incsearch 在输入时开始搜索
3dw 3次删除word   d3w 删除3个word
f< 找到第一个<    df< 删除到<   .重复之前的操作
four ->> five    /four  cwfive  n .  n .
ye y$复制到尾部
diw 删除光标所在的单词
set filetype 检测语言类型
多次匹配 ： /a*  匹配 a aa aaa...
/(ab)*   
/ab\+
/folder\=
/a.*b
/foo\|bar
/one\|two\|three
