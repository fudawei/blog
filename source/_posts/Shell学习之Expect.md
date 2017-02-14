title: Shell--Expect
tags: [Linux,Shell]
categories: [Linux,Shell]
date: 2017-01-24 10:30:02
---

### 一、概述
   我们通过Shell可以实现简单的控制流功能，如：循环、判断等。但是对于需要交互的场合则必须通过人工来干预，有时候我们可能会需要实现和交互程序如telnet服务器等进行交互的功能。而expect就使用来实现这种功能的工具。

   expect是一个免费的编程工具语言，用来实现自动和交互式任务进行通信，而无需人的干预。expect是不断发展的，随着时间的流逝，其功能越来越强大，已经成为系统管理员的的一个强大助手。expect需要Tcl编程语言的支持，要在系统上运行expect必须首先安装Tcl。

### 二、expect的安装
expect是在Tcl基础上创建起来的，所以在安装expect前我们应该先安装Tcl。

（一）Tcl 安装
主页: http://www.tcl.tk
下载地址: http://www.tcl.tk/software/tcltk/downloadnow84.tml
1.下载源码包

```
wget http://nchc.dl.sourceforge.net/sourceforge/tcl/tcl8.4.11-src.tar.gz

```
2.解压缩源码包

```
tar xfvz tcl8.4.11-src.tar.gz

```
3.安装配置

```
cd tcl8.4.11/unix
./configure --prefix=/usr/tcl --enable-shared
make
make install
```
注意：
1、安装完毕以后，进入tcl源代码的根目录，把子目录unix下面的tclUnixPort.h copy到子目录generic中。

2、暂时不要删除tcl源代码，因为expect的安装过程还需要用。

（二）expect 安装 (需Tcl的库)

主页: http://expect.nist.gov/

1.下载源码包

```
wget http://sourceforge.net/projects/expect/files/Expect/5.45/expect5.45.tar.gz/download  

```
2.解压缩源码包

```
tar xzvf expect5.45.tar.gz

```
3.安装配置

```
cd expect5.45
./configure --prefix=/usr/expect --with-tcl=/usr/tcl/lib --with-tclinclude=../tcl8.4.11/generic
make
make install
ln -s /usr/tcl/bin/expect /usr/expect/bin/expect
```

### 三、Expect工作原理

   从最简单的层次来说，Expect的工作方式象一个通用化的Chat脚本工具。Chat脚本最早用于UUCP网络内，以用来实现计算机之间需要建立连接时进行特定的登录会话的自动化。

   Chat脚本由一系列expect-send对组成：expect等待输出中输出特定的字符，通常是一个提示符，然后发送特定的响应。例如下面的 Chat脚本实现等待标准输出出现Login:字符串，然后发送somebody作为用户名；然后等待Password:提示符，并发出响应 sillyme。

引用：

Login: somebody Password: sillyme
Expect最简单的脚本操作模式本质上和Chat脚本工作模式是一样的。

### 四、实例详解

1. expect 是基于tcl 演变而来的，所以很多语法和tcl 类似，基本的语法如下
所示：
  1.1 首行加上/usr/bin/expect
  1.2 spawn: 后面加上需要执行的shell 命令，比如说spawn sudo touch testfile
  1.3 expect: 只有spawn 执行的命令结果才会被expect 捕捉到，因为spawn 会启
动一个进程，只有这个进程的相关信息才会被捕捉到，主要包括：标准输入的提
示信息，eof 和timeout。
  1.4 send 和send_user：send 会将expect 脚本中需要的信息发送给spawn 启动
的那个进程，而send_user 只是回显用户发出的信息，类似于shell 中的echo 而
已。


2. 一个小例子，用于linux 下账户的建立：
filename: account.sh，可以使用./account.sh newaccout 来执行；

```
#!/usr/bin/expect

set passwd "mypasswd"
set timeout 60
if {$argc != 1} {
  send "usage ./account.sh \$newaccount\n"
  exit
}

set user [lindex $argv [expr $argc-1]]
spawn sudo useradd -s /bin/bash -g mygroup -m $user
expect {
  "assword" {
    send_user "sudo now\n"
    send "$passwd\n"
    exp_continue
  }
  eof{
    send_user "eof\n"
  }
}

spawn sudo passwd $user
expect {
 "assword" {
    send "$passwd\n"
     exp_continue
 }
 eof {
      send_user "eof"
    }
}

spawn sudo smbpasswd -a $user
expect {
         "assword" {
         send "$passwd\n"
         exp_continue
      }

     eof {
        send_user "eof"
     }
}
```

3. 注意点：

第3 行： 对变量赋值的方法；
第4 行： 默认情况下，timeout 是10 秒；
第6 行： 参数的数目可以用$argc 得到；
第11 行：参数存在$argv 当中，比如取第一个参数就是[lindex $argv 0]；并且
如果需要计算的话必须用expr，如计算2-1，则必须用[expr 2-1]；
第13 行：用spawn 来执行一条shell 命令，shell 命令根据具体情况可自行调整；
有文章说sudo 要加-S，经过实际测试，无需加-S 亦可；
第15 行：一般情况下，如果连续做两个expect，那么实际上是串行执行的，用。expect 与“{ ”之间直接必须有空格或则TAB间隔，否则会出麻烦，会报错invalid command name "expect{" 
例子中的结构则是并行执行的，主要是看匹配到了哪一个；在这个例子中，如果
你写成串行的话，即
expect "assword"
send "$passwd\n"
expect eof
send_user "eof"
那么第一次将会正确运行，因为第一次sudo 时需要密码；但是第二次运行时由于
密码已经输过（默认情况下sudo 密码再次输入时间为5 分钟），则不会提示用户
去输入，所以第一个expect 将无法匹配到assword，而且必须注意的是如果是
spawn 命令出现交互式提问的但是expect 匹配不上的话，那么程序会按照timeout
的设置进行等待；可是如果spawn 直接发出了eof 也就是本例的情况，那么expect
"assword"将不会等待，而直接去执行expect eof。
这时就会报expect: spawn id exp6 not open，因为没有spawn 在执行，后面的
expect 脚本也将会因为这个原因而不再执行；所以对于类似sudo 这种命令分支
不定的情况，最好是使用并行的方式进行处理；
第17 行：仅仅是一个用户提示而已，可以删除；
第18 行：向spawn 进程发送password；
第19 行：使得spawn 进程在匹配到一个后再去匹配接下来的交互提示；
第21 行：eof 是必须去匹配的，在spawn 进程结束后会向expect 发送eof；如果
不去匹配，有时也能运行，比如sleep 多少秒后再去spawn 下一个命令，但是不
要依赖这种行为，很有可能今天还可以，明天就不能用了；

4. 其他
下面这个例子比较特殊，在整个过程中就不能expect eof 了：
```
#!/usr/bin/expect
set timeout 30
spawn ssh 10.192.224.224
expect "password:"
send "mypassword\n"
expect "*$"
send "mkdir tmpdir\n" #远程执行命令用send发送，不用spawn
expect "*$" #注意这个地方，要与操作系统上环境变量PS1相匹配，尤其是有PS1有空格的情况下，一定在expct "*$ " 把空格加上，加不上你就完蛋了。我试过。
```
这个例子实际上是通过ssh 去登录远程机器，并且在远程机器上创佳一个目录，
我们看到在我们输入密码后并没有去expect eof，这是因为ssh 这个spawn 并没
有结束，而且手动操作时ssh 实际上也不会自己结束除非你exit；所以你只能
expect bash 的提示符，当然也可以是机器名等，这样才可以在远程创建一个目
录。
注意，请不要用spawn mkdir tmpdir，这样会使得上一个spawn 即ssh 结束，那
么你的tmpdir 将在本机建立。
当然实际情况下可能会要你确认ssh key，可以通过并行的expect 进行处理，不
多赘述。


6 实例：下面这个脚本是完成对单个服务器scp任务。
```
#!/usr/bin/expect

set timeout 10
set host [lindex $argv 0]
set username [lindex $argv 1]
set password [lindex $argv 2]
set src_file [lindex $argv 3]
set dest_file [lindex $argv 4]

spawn scp  $src_file $username@$host:$dest_file
expect {
     "(yes/no)?"
        {
            send "yes\n"
            expect "*assword:" { send "$password\n"}
        }
    "*assword:"
        {
            send "$password\n"
        }
    }
expect "100%"
expect eof
```

意代码刚开始的第一行，指定了expect的路径，与shell脚本相同，这一句指定了程序在执行时到哪里去寻找相应的启动程序。代码刚开始还设定了timeout的时间为10秒，如果在执行scp任务时遇到了代码中没有指定的异常，则在等待10秒后该脚本的执行会自动终止。
spawn代表在本地终端执行的语句，在该语句开始执行后，expect开始捕获终端的输出信息，然后做出对应的操作。expect代码中的捕获的(yes/no)内容用于完成第一次访问目标主机时保存密钥的操作。有了这一句，scp的任务减少了中断的情况。代码结尾的expect eof与spawn对应，表示捕获终端输出信息的终止。

有了这段expect的代码，还只能完成对单个远程主机的scp任务。如果需要实现批量scp的任务，则需要再写一个shell脚本来调用这个expect脚本。
```
#!/bin/sh

list_file=$1
src_file=$2
dest_file=$3

cat $list_file | while    read line
 do
     host_ip=`echo $line | awk '{print $1}'`
     username=`echo $line | awk '{print $2}'`
     password=`echo $line | awk '{print $3}'`
     echo "$host_ip"
     ./expect_scp $host_ip $username $password $src_file $dest_file
 done
```

很简单的代码，指定了3个参数：列表文件的位置、本地源文件路径、远程主机目标文件路径。需要说明的是其中的列表文件指定了远程主机ip、用户名、密码，这些信息需要写成以下的格式：
IP username password
中间用空格或tab键来分隔，多台主机的信息需要写多行内容。
这样就指定了两台远程主机的信息。注意，如果远程主机密码中有“$”、“#”这类特殊字符的话，在编写列表文件时就需要在这些特殊字符前加上转义字符，否则expect在执行时会输入错误的密码。