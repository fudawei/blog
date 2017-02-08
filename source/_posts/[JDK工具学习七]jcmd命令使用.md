title: "[JDK工具学习七]jcmd命令使用"
tags: [Java,JDK工具]
categories: [Java,JDK工具]
date: 2015-08-01 09:37:15
---
## 概述
在JDK 1.7之后，新增了一个命令行工具jcmd。它是一个多功能工具，可以用来导出堆，查看java进程，导出线程信息，执行GC等。

## 使用示例
下面这个命令能够列出当前运行的所有虚拟机：
<!--more-->
![这里写图片描述](http://img.blog.csdn.net/20150604171002087)

参数-l表示列出所有java虚拟机，针对每一个虚拟机，可以使用help命令列出该虚拟机支持的所有命令，如下图所示，以21024这个进程为例：

![这里写图片描述](http://img.blog.csdn.net/20150604171153752)

### 查看虚拟机启动时间VM.uptime
![这里写图片描述](http://img.blog.csdn.net/20150604171358740)

### 打印线程栈信息Thread.print
![这里写图片描述](http://img.blog.csdn.net/20150604171538533)

### 查看系统中类统计信息GC.class_histogram
执行如下命令：
> [qifuguang@Mac~]$ jcmd 21024 GC.class_histogram

得到结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150604172039832)

### 导出堆信息GC.heap_dump
使用如下命令可以导出当前堆栈信息，这个命令功能和 [jmap -dump](http://blog.csdn.net/飞鸟/article/details/46337339)
功能一样

![这里写图片描述](http://img.blog.csdn.net/20150604172154322)

### 获取系统Properties内容VM.system_properties
![这里写图片描述](http://img.blog.csdn.net/20150604172452662)

### 获取启动参数VM.flags
![这里写图片描述](http://img.blog.csdn.net/20150604172713990)

### 获取所有性能相关数据PerfCounter.print
![这里写图片描述](http://img.blog.csdn.net/20150604172655777)


## 总结
从以上示例可以看出，jcmd拥有jmap的大部分功能，并且Oracle官方也建议使用jcmd代替jmap。
