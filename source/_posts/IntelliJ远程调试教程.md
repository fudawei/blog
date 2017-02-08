title: IntelliJ远程调试教程
tags: [Java,开发工具]
categories: [Java,开发工具]
date: 2013-09-18 16:08:56
---
# 概述

对于分布式系统的调试不知道大家有什么好的方法。对于我来说，在知道远程调试这个方法之前就是在代码中打各种log，然后重新部署，上线，调试，这样比较费时。今天咱们来了解了解Java远程调试这个牛逼的功能，本文以Intellij IDEA为例讲解怎么使用远程调试。以[Thrift入门教程](http://fudawei.github.io/2015/09/11/Thrift%E5%85%A5%E9%97%A8%E6%95%99%E7%A8%8B/)这篇文章中使用的程序作为例子。这个程序由Thrift服务端和客户端组成。描述一下远程调试需要解决的问题：

<!--more-->
>服务端程序运行在一台远程服务器上，我们可以在本地服务端的代码（前提是本地的代码必须和远程服务器运行的代码一致）中设置断点，每当有请求到远程服务器时时能够在本地知道远程服务端的此时的内部状态。

下面按照步骤介绍怎么远程debug。

# 使用特定JVM参数运行服务端代码
要让远程服务器运行的代码支持远程调试，则启动的时候必须加上特定的JVM参数，这些参数是：

```
 -Xdebug -Xrunjdwp:transport=dt_socket,suspend=n,server=y,address=${debug_port}
```

其中的${debug_port}是用户自定义的，为debug端口，本例以5555端口为例。

# 本地连接远程服务器debug端口
打开Intellij IDEA，在顶部靠右的地方选择"Edit Configurations..."，进去之后点击+号，选择"Remote"，按照下图的只是填写红框内的内容，其中host为远程代码运行的机器的ip/hostname，port为上一步指定的debug_port，本例是5555
![](http://7xlune.com1.z0.glb.clouddn.com/images/IntelliJ远程调试教程/create_remote.png)
然后点击Apply，最后点击OK即可

# 启动debug模式
 现在在上一步选择"Edit Configurations..."的下拉框的位置选择上一步创建的remote的名字，然后点击右边的debug按钮(长的像臭虫那个)，看控制台日志，如果出现类似**"Connected to the target VM, address: 'xx.xx.xx.xx:5555', transport: 'socket'"**的字样，就表示连接成功过了。
 ![](http://7xlune.com1.z0.glb.clouddn.com/images/IntelliJ远程调试教程/start_remote.png)
 
# 设置断点，开始调试
远程debug模式已经开启，现在可以在需要调试的代码中打断点了，比如：
![](http://7xlune.com1.z0.glb.clouddn.com/images/IntelliJ远程调试教程/create_debug_point.png)
如图中所示，如果断点内有√，则表示选取的断点正确。


现在在本地发送一个到远程服务器的请求，看本地控制台的bug界面，划到debugger这个标签，可以看到当前远程服务的内部状态（各种变量）已经全部显示出来了，并且在刚才设置了断点的地方，也显示了该行的变量值。
![](http://7xlune.com1.z0.glb.clouddn.com/images/IntelliJ远程调试教程/show_debug_result1.png)
![](http://7xlune.com1.z0.glb.clouddn.com/images/IntelliJ远程调试教程/show_debug_result2.png)

# 注意事项
本文为作者原创，转载请注明出处，本文链接：[http://fudawei.github.io/2015/09/18/IntelliJ远程调试教程](http://fudawei.github.io/2015/09/18/IntelliJ远程调试教程)

