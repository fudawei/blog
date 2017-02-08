title: "[JDK工具学习一]jps命令使用"
date: 2015-08-01 09:09:32
tags: [Java,JDK工具]
categories: [Java,JDK工具]
---
jps命令类似于linux下的ps命令，用于列出当前正在运行的所有java进程。

### 基本用法
直接运行不加任何参数就能列出所有java进程的pid和类的短名称。例如：
<!--more-->
![这里写图片描述](http://img.blog.csdn.net/20150602000405556)
### 常用参数
#### -q参数
-q可以指定jps只列出pid,而不输出类的短名称，例如：

![这里写图片描述](http://img.blog.csdn.net/20150602000630371)

#### -m参数
-m参数可以用于列出传递给java进程主函数的参数，例如：

![这里写图片描述](http://img.blog.csdn.net/20150602000614119)
这里可以看到传递给jps（jps本身也是java进程）进程的参数就是-m

#### -l参数
-l参数用于输出主类的完整路径，例如：

![这里写图片描述](http://img.blog.csdn.net/20150602000748827)

#### -v参数
-v参数可以列出传递给java虚拟机的参数，例如：

![这里写图片描述](http://img.blog.csdn.net/20150602000948557)
