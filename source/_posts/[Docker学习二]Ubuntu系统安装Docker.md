title: "[Docker学习二]Ubuntu系统安装Docker"
tags: [虚拟化,Docker]
categories: [虚拟化,Docker]
date: 2015-10-03 09:42:01
---
本文仅仅介绍在ubuntu系统主机上安装Docker的方法，OSX,windows等系统请读者参阅：

[window安装点击这里](http://blog.csdn.net/zistxym/article/details/42918339)
[OSX安装点击这里](http://www.oschina.net/translate/installing-docker-on-mac-os-x)
<!--more-->
## 在Ubuntu系统中安装Docker

目前，官方支持在西面的Ubuntu系统中安装Docker：

Ubuntu  14.04   64位
Ubuntu  13.04   64位
Ubuntu  13.10   64位
Ubuntu  12.04   64位
但是，并不是说在上述清单之外的Ubuntu（活着Debian）版本就不能安装Docker。只要有适当的内核和Docker所必须的支持，其他版本的Ubuntu也是可以安装Docker的，只不过这些版本没有得到官方支持，遇到bug无法得到官方的修复。

在Ubuntu系统下安装Docker需要如下步骤：

### 检查前提条件

#### 内核

使用如下命令检查系统内核版本：
```
[qifuguang@winwill~]$ uname -a
Linux qifuguang-OptiPlex-9010 3.13.0-53-generic #89-Ubuntu SMP Wed May 20 10:34:39 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
```
可以看到我的机器的内核版本是3.13.0-53，安装Docker需要Linux机器内核版本在3.8以上，所以符合要求。

#### 检查Device Mapper

我们将使用Device Mapper作为存储驱动，自2.6.9版本的linux内核已经开始集成了Device Mapper，并且提供了一个将快设备映射到高级虚拟设备的方法。Device Mapper支持“自动精简配置”的概念，可以在一中文件系统中存储多台虚拟设备。因此使用Device Mapper作为Docker的存储驱动再合适不过了。

可以通过如下的命令确认机器是否安装了Device Mapper：
```
[qifuguang@winwill~]$ ls -l /sys/class/misc/device-mapper
lrwxrwxrwx 1 root root 0  6月 26 20:26 /sys/class/misc/device-mapper -> ../../devices/virtual/misc/device-mapper
```

### 安装Docker

如果上述的条件都符合，就可以安装Docker了。首先要添加Docker的APT仓库，代码如下:

[qifuguang@winwill~]$ sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"


接下来，要添加Docker仓库的GPG密钥，命令如下：
```
[qifuguang@winwill~]$ curl -s https://get.docker.io/gpg | sudo apt-key add -
OK
```

之后，我们更新一下APT源：
```
[qifuguang@winwill~]$ sudo apt-get update
忽略 http://security.ubuntu.com trusty-security InRelease
忽略 http://ppa.launchpad.net trusty InRelease
获取：1 http://security.ubuntu.com trusty-security Release.gpg [933 B]
忽略 http://extras.ubuntu.com trusty InRelease
获取：2 http://security.ubuntu.com trusty-security Release [63.5 kB]
忽略 http://ppa.launchpad.net trusty InRelease
命中 http://extras.ubuntu.com trusty Release.gpg
获取：3 http://ppa.launchpad.net trusty Release.gpg [316 B]
命中 http://extras.ubuntu.com trusty Release
获取：4 https://get.docker.io docker InRelease
命中 http://ppa.launchpad.net trusty Release.gpg
命中 http://extras.ubuntu.com trusty/main Sources
命中 http://extras.ubuntu.com trusty/main amd64 Packages
获取：5 http://ppa.launchpad.net trusty Release [15.1 kB]
获取：6 http://security.ubuntu.com trusty-security/main amd64 Packages [304 kB]
忽略 https://get.docker.io docker InRelease
命中 http://extras.ubuntu.com trusty/main i386 Packages
25% [正在连接 cn.archive.ubuntu.com] [正在等待报头] [6 Packages 17.0
......
......
```
现在，就可以安装Docker软件包了：
```
[qifuguang@winwill~]$ sudo apt-get install lxc-docker
正在读取软件包列表... 完成
正在分析软件包的依赖关系树
正在读取状态信息... 完成
将会安装下列额外的软件包：
  lxc-docker-1.7.0
  下列软件包将被【卸载】：
    lxc-docker-1.6.2
    下列【新】软件包将被安装：
      lxc-docker-1.7.0
      下列软件包将被升级：
        lxc-docker
        升级了 1 个软件包，新安装了 1 个软件包，要卸载 1 个软件包，有 0 个软件包未被升级。
        需要下载 4,964 kB 的软件包。
        解压缩后会消耗掉 820 kB 的额外空间。
        您希望继续执行吗？ [Y/n]Y
        ```
## 检查Docker是否安装成功

        安装完成之后，可以使用docker info命令确认docker是否已经正确安装并运行了：
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
