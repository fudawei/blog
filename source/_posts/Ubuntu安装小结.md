title: Ubuntu安装小结
date: 2015-06-09 22:41:40
categories: [Linux]
tags: apt-get
---
### Ubuntu 中apt-get用法：
查找软件
命令： apt-cache search keyword

查询软件状态
命令： apt-cache policy softname

安装软件
命令： apt-get install softname1 softname2 softname3……

卸载软件
命令： apt-get remove softname1 softname2 softname3……

卸载并清除配置
命令： apt-get remove --purge softname1

更新软件信息数据库
命令： apt-get update

进行系统升级
命令： apt-get upgrade

搜索软件包
命令： apt-cache search softname1 softname2 softname3……

Deb软件包相关安装与卸载
安装deb软件包
命令： dpkg -i xxx.deb

### TimeNet4 的安装
apt-get install openjdk-7-jre
apt-get install build-essential
apt-get install unixodbc-dev
apt-get install liblpsolve55-dev

run /TimeNET/bin/startGUI

### Qt5.3安装
[下载](https://download.qt.io/archive/qt/5.3/5.3.0/) qt-opensource-linux-x64-5.3.0.run
安装依赖 sudo apt-get install build-essential libgl1-mesa-dev
赋予权限 chmod +x qt-opensource-linux-x64-5.3.0.run
执行 ./qt-opensource-linux-x64-5.3.0.run

### 安装java
解压之后
sudo gedit /etc/environment
添加如下
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/tecn/jdk1.7.0_55/bin"
CLASSPATH="/home/tecn/jdk1.7.0_55/lib:."       注意后面有个点
JAVA_HOME="/home/tecn/jdk1.7.0_55/"
注销或重启使环境变量生效  执行java -version

已经装有openjdk启用官方jdk的方法：
依次终端执行：
sudo update-alternatives --install /usr/bin/java java /home/tecn/jdk1.7.0_55/bin/java 445
sudo update-alternatives --install /usr/bin/javac javac /home/tecn/jdk1.7.0_55/bin/javac 445
sudo update-alternatives --config java
将会提示，要维持当前值[*]请按回车键，或者输入选择的编号：
输入优先级为 445 的那项的编号，回车即可。


### centso安装pip 下载源码安装
wget --no-check-certificate https://github.com/pypa/pip/archive/1.5.5.tar.gz
tar zvxf 1.5.5.tar.gz    #解压文件
cd pip-1.5.5/
python setup.py install

你可以检查日志或者控制 Shadowsocks 的运行：
supervisorctl tail -f shadowsocks stderr
supervisorctl restart shadowsocks




