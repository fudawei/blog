title: "[Docker学习三]Docker入门"
tags: [虚拟化,Docker]
categories: [虚拟化,Docker]
date: 2015-10-17 09:44:19
---
前面的文章讲解了怎么安装Docker，本文将迈出使用Docker的第一步，学习第一个Docker容器。
<!--more-->
## 确保Docker已经就绪

使用如下命令可以查看docker程序是否存在，功能是否正常：
```
[qifuguang@winwill~]$ sudo docker info
Containers: 5
Images: 72
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 82
 Dirperm1 Supported: false
Execution Driver: native-0.2
Kernel Version: 3.13.0-53-generic
Operating System: Ubuntu 14.04.2 LTS
CPUs: 8
Total Memory: 15.56 GiB
Name: qifuguang-OptiPlex-9010
ID: SNVW:WBCG:76BZ:2L63:AFQR:ZMDS:KI4Z:XIQZ:ENHV:O7PI:QMDP:6DQ3
Username: quinn2012
Registry: [https://index.docker.io/v1/]
WARNING: No swap limit support
```
上述的info命令返回docker中所有的容器和镜像的数量，docker使用的执行驱动和存储驱动，以及docker的基本配置。

## 运行第一个容器

现在，我们尝试启动第一个容器。我们可以使用docker run命令创建容器，docker run命令提供了容器的创建和启动功能，在本文中我们使用该命里那个创建新容器：

![这里写图片描述](http://img.blog.csdn.net/20150627111304649)

首先，我们告诉docker执行docker run命令，并指定-i和-t两个命令行参数。-i标识保证容器的STDIN是开启的，尽管我们并没有附着在容器中。持久的标准输入是交互式shell的“半边天”，而-t则是另外“半边天”，它告诉docker要为创建的容器分配一个伪tty终端。这样，创建的容器才能提供一个交互式的shell。如果要在命令行创建一个我们能与之进行交互的容器，这两个命令参数最基本的参数。

接下来，告诉docker基于什么镜像来创建容器，上面示例使用的是ubuntu镜像。ubuntu镜像是一个常备镜像，也可以称为“基础镜像”，它由Docker公司提供，保存在Docker Hub Registry上。本例中我们基于ubuntu镜像创建、启动了一个容器，并没有做任何修改。

这个命令背后的执行流程是怎样的呢？首先Docker会检查本地是否有ubuntu镜像，如果没有该镜像的话，Docker连接官方维护的Docker Hub Registry，查看Docker Hub中是否有该镜像，Docker一旦找到该镜像，就会下载该镜像并保存到本地宿主机中。随后Docker在文件系统内部用这个镜像创建 一个新容器。该容器拥有自己的网络，IP地址，以及一个用来和宿主机进行通信的桥接网络接口。最后，告诉Docker要在新容器中执行什么命令，在本例中执行/bin/bash命令启动一个Bash shell。

##使用第一个容器
我们已经以root用户登录到 了新的容器中，容器ID为faa127f03be9，看起来很不和谐，非常难以记忆，后续会告诉大家怎么为容器命名。
### 查看/etc/hosts文件
看看hosts文件的配置情况：
```
root@faa127f03be9:/# cat /etc/hosts
172.17.0.45 faa127f03be9
127.0.0.1   localhost
::1 localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
root@faa127f03be9:/#
```
可以看到，Docker已经使用容器ID在/etc/hosts文件中为容器添加了一条主机配置项。
### 查看网络配置情况
我们可以看看容器的网络配置情况：
```
root@faa127f03be9:/# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
100: eth0: <BROADCAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:11:00:2d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.45/16 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe11:2d/64 scope link
       valid_lft forever preferred_lft forever
root@faa127f03be9:/#
```
可以看到，这里有lo回环接口，还有IP为172.17.0.45的白哦准的eth0网络接口，和普通的宿主机完全一样。
### 查看容器中运行的进程
通过如下的命令可以查看容器中运行的进程：
```
root@faa127f03be9:/# ps -aux
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0  18164  2020 ?        Ss   03:11   0:00 /bin/bash
root        17  0.0  0.0  15564  1152 ?        R+   03:17   0:00 ps -aux
root@faa127f03be9:/#
```
### 在容器中安装软件
刚刚启动的容器中是没有vim软件包的：
```
root@faa127f03be9:/# vim /etc/hosts
bash: vim: command not found
root@faa127f03be9:/#
```
现在我们在容器中安装vim软件包：
```
root@faa127f03be9:/# sudo apt-get install vim
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following extra packages will be installed:
  libgpm2 libpython2.7 libpython2.7-minimal libpython2.7-stdlib vim-runtime
Suggested packages:
  gpm ctags vim-doc vim-scripts
The following NEW packages will be installed:
  libgpm2 libpython2.7 libpython2.7-minimal libpython2.7-stdlib vim
  vim-runtime
0 upgraded, 6 newly installed, 0 to remove and 0 not upgraded.
Need to get 9083 kB of archives.
After this operation, 42.9 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://archive.ubuntu.com/ubuntu/ trusty/main libgpm2 amd64 1.20.4-6.1 [16.5 kB]
Get:2 http://archive.ubuntu.com/ubuntu/ trusty/main libpython2.7-minimal amd64 2.7.6-8 [307 kB]
Get:3 http://archive.ubuntu.com/ubuntu/ trusty/main libpython2.7-stdlib amd64 2.7.6-8 [1872 kB]
Get:4 http://archive.ubuntu.com/ubuntu/ trusty/main libpython2.7 amd64 2.7.6-8 [1044 kB]
Get:5 http://archive.ubuntu.com/ubuntu/ trusty/main vim-runtime all 2:7.4.052-1ubuntu3 [4888 kB]
......
Processing triggers for libc-bin (2.19-0ubuntu6.6) ...
root@faa127f03be9:/#
```
vim软件包就已经安装好了，怎么样？是不是和普通宿主机安装软件包一样简单！

### 退出容器
使用如下命令可以退出容器：
```
root@faa127f03be9:/# exit
exit
[qifuguang@winwill~]$
```
现在，容器已经退出了，我们可以使用如下命令看看当前有哪些容器正在运行：

![这里写图片描述](http://img.blog.csdn.net/20150627112734913)

可以看到，当前没有处于运行状态的容器，但是如果使用如下命令，便会显示所有容器，包含没有处于运行状态的：

![这里写图片描述](http://img.blog.csdn.net/20150627112852973)

也可以使用如下的命令列出最后一次运行的容器，包含正在运行和没有运行的：

![这里写图片描述](http://img.blog.csdn.net/20150627113045970)

## 为容器命名
上面的例子运行的容器的ID默认是一串没有规律的字符串，可读性非常差，还好，我们可以在创建启动容器的时候给它指定一个名字：
```
[qifuguang@winwill~]$ sudo docker run -t -i --name ubuntu ubuntu /bin/bash
root@fdbcdbed6749:/#
root@fdbcdbed6749:/#
root@fdbcdbed6749:/#
root@fdbcdbed6749:/#
```
上面的命令通过参数项--name为创建的容器命名为ubuntu，我们看看生效没有：
![这里写图片描述](http://img.blog.csdn.net/20150627113908706)
从图中可以看到，命名已经生效。

顺便说一下，容器的命名规则：只能包含大小写字母，数字，下划线，圆点，横线，如果用正则表达式表示这些符号就是[a-zA-Z0-9_.]。

## 重启已经停止的容器
我们可以使用start命令启动已经停止的容器：
![这里写图片描述](http://img.blog.csdn.net/20150627114405311)
也可以使用docker restart命令重新启动一个正在运行的容器。

## 附着在容器上
Docker容器重新启动的时候，会沿用创建容器时（docker run时）指定的参数来运行，因此指定了-t -i参数的容器重新启动之后会运行一个交互式的会话shell，我们可以使用docker attach命令重新附着到该容器的会话上：
![这里写图片描述](http://img.blog.csdn.net/20150627114728424)

## 创建守护式进程
除了运行交互式的容器，我们还可以创建长期运行的容器，守护式进程没有交互式会话，非常适合于运用程序和服务，大多数时候我们都需要使用交互式方式运行容器。下面我们启动一个守护式容器：
```
[qifuguang@winwill~]$ sudo docker run -d --name deamon_ubuntu ubuntu /bin/bash -c "while true; do echo hello word; sleep 1; done"
48fcd5b118fd86ebee6fefb376cda3235384ddd3c41fa502ef0b59c9e1f2f1d3
[qifuguang@winwill~]$
```
可以看到，这个容器运行之后并没有像交互式容器一样将主机的控制台附着在新的shell会话上，而是仅仅返回一个容器ID。使用docker ps可以看到刚刚创建的交互式的容器正在运行：

![这里写图片描述](http://img.blog.csdn.net/20150627120122298)

## 查看容日日志
对于守护式的容器，我们不能知道他到底在干些什么，但是我们可以通过查看docker容器的日志了解：
![这里写图片描述](http://img.blog.csdn.net/20150627120306595)
可以看到，刚才创建的守护式容器正在后台不停地打印“hello world”。

也可以使用docker logs -f来监控docker容器的日志，就像ubuntu系统下使用tail -f 一样：

## 查看容器内的进程
除了容器的日志，我们还可以查看容器内部的进程：
![这里写图片描述](http://img.blog.csdn.net/20150627120548711)
通过这个命令，我们可以看到容器内部的所有进程，运行进程的用户以及进程ID。

## 在容器内部运行进程
Docker 1.3之后，可以通过docker exec命令在容器内部额外启动新进程。可以在容器内部运行的进程有两种形式：后台任务和交互式任务。
```
[qifuguang@winwill~]$ sudo docker exec -d deamon_ubuntu touch /etc/new_file
[qifuguang@winwill~]$
[qifuguang@winwill~]$
[qifuguang@winwill~]$
```
这里的-d标志表明需要运行一个后台任务，-d后面紧跟的是要在哪个容器内部执行命令，接下来是需要执行的命令。

我们也可以在deamon_ubuntu容器中启动一个打开shell的交互式任务，代码如下：
```
[qifuguang@winwill~]$ sudo docker exec -i -t deamon_ubuntu /bin/bash
root@48fcd5b118fd:/#
root@48fcd5b118fd:/#
root@48fcd5b118fd:/#
root@48fcd5b118fd:/#
root@48fcd5b118fd:/#
```
这里的-i和-t参数和运行容器时的含义是一样的。

## 停止守护式容器
要停止守护式容器，可以使用stop命令：
![这里写图片描述](http://img.blog.csdn.net/20150627121343870)

## 自动重启容器
如果由于某种错误导致容器停止运行，我们可以通过--restart表示，让Docker自动重启容器。--restart会检查容器的推出代码，并以此来决定是否要重启容器，默认行为是docker不会重启容器。

## 深入容器
可以使用哪个docker inspect查看容器的详细信息：

![这里写图片描述](http://img.blog.csdn.net/20150627121639396)

由于信息量太大，还可以使用-f或者--format标识来选定查看结果：

![这里写图片描述](http://img.blog.csdn.net/20150627121827553)

## 删除容器
可以使用docker rm命令删除容器：

![这里写图片描述](http://img.blog.csdn.net/20150627121932771)

docker基本的操作大概就这么多。

