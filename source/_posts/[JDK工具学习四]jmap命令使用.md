title: "[JDK工具学习四]jmap命令使用"
tags: [Java,JDK工具]
categories: [Java,JDK工具]
date: 2015-08-01 09:34:05
---
## 概述
jmap是一个多功能的命令。它可以生成java程序的堆dump文件，也可以查看堆内对象实例的统计信息，查看ClassLoader的信息以及Finalizer队列。
<!--more-->
## 使用示例
### 导出对象统计信息
下面的命令生成PID为2500的java成粗的对象的统计信息，并输出到out.txt文件中：
```
[qifuguang@winwill~]$ jmap -histo 2500 > out.txt
[qifuguang@winwill~]$
[qifuguang@winwill~]$
[qifuguang@winwill~]$
[qifuguang@winwill~]$
[qifuguang@winwill~]$
```
生成的文件如下：
![这里写图片描述](http://img.blog.csdn.net/20150602231204933)
从文件中可以看到，统计信息显示了内存中实例的数量和合计。

### 导出程序堆快照
下面的命令导出PID为2500的java程序当前的堆快照：
```
[qifuguang@winwill~]$ jmap -dump:format=b,file=dump.bin 2500
Dumping heap to /home/qifuguang/dump.bin ...
Heap dump file created
```
该命令成功地将运用程序的当前的堆快照导出到了dump.bin文件，之后可以使用Visual VM，MAT等工具分析对快照文件。

### 查看Finalizer队列
下面的命令查看虚拟机Finalizer队列的信息：
![这里写图片描述](http://img.blog.csdn.net/20150602233132638)
从图中可以看到，队列中堆积了大量的TestFinalizer$LY对象实例，还有其他一些对象。

### 查看ClassLoader信息
下面的命令显示了虚拟机当前的ClassLoader信息：
![这里写图片描述](http://img.blog.csdn.net/20150602233406536)
从图中可以看到，当前虚拟机一共有3个ClassLoader，bootstrap加载了492个对象，对象总大小为943655byte，同时还显示了各个ClassLoader之间的父子关系。
