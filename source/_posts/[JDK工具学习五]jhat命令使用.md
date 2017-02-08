title: "[JDK工具学习五]jhat命令使用"
tags: [Java,JDK工具]
categories: [Java,JDK工具]
date: 2015-08-01 09:35:08
---
## 概述
jhat(Java Head Analyse Tool)是jdk自带的用来分析java堆快照的工具，具体的使用方法是：
> jhat dump_file_name
<!--more-->
## 使用示例
在此以[前文](http://blog.csdn.net/飞鸟/article/details/46337339)dump出来的文件（dump.bin）为例，演示怎么使用jhat分析堆文件。
![这里写图片描述](http://img.blog.csdn.net/20150602234741933)
![这里写图片描述](http://img.blog.csdn.net/20150602234954912)

上图中使用jhat命令打开了之前dump出来的堆快照文件，可以看到，命令成功执行后会在命令执行的本机启动一个http服务，可以在浏览器上打开本机的7000端口查看详细的分析结果：

![这里写图片描述](http://img.blog.csdn.net/20150602235100896)

页面中显示了所有非平台类信息，点击链接进入，可以查看选中的类的超类，ClassLoader以及该类的实例等信息。此外，在页面的地步，jhat还为开发人员提供了其他查询方式。如图所示：

![这里写图片描述](http://img.blog.csdn.net/20150602235508379)

通过这些链接，开发人员可以查看所有类信息（包含java平台的类），所有根节点，finalizer对象等等信息。最后提供了OQL查询工具，开发人员可以输入OQL语言查询相应的类。关于OQL，笔者就不过多介绍，想了解更多的可以点击[这里](http://su1216.iteye.com/blog/1535776)了解。
