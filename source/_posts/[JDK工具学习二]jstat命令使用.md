title: "[JDK工具学习二]jstat命令使用"
tags: [Java,JDK工具]
categories: [Java,JDK工具]
date: 2015-08-01 09:30:55
---
jstat是一个可以用于观察java应用程序运行时相关信息的工具，功能非常强大，可以通过它查看堆信息的详细情况。 

## 基本用法
jstat命令的基本使用语法如下：
<!--more-->
**jstat -option [-t] [-h] pid [interval] [count]**

 * 选项option可以由以下值构成。
     * **-class**：显示ClassLoader的相关信息。
     * **-compiler**：显示JIT编译的相关信息。
     * **-gc**：显示与gc相关的堆信息。
     * **-gccapacity**：显示各个代的容量及使用情况。
     *  **-gccause**：显示垃圾回收的相关信息（同-gcutil），同时显示最后一次或当前正在发生的垃圾回收的诱因。
     *  **-gcnew**：显示新生代信息。
     *  **-gcnewcapacity**：显示新生代大小与使用情况。
     *  **-gcold**：显示老生代和永久代的信息。
     *  **-gcoldcapacity**：显示老年代的大小。
     *  **-gcpermcapacity**：显示永久代的大小。
     *  **-gcutil**：显示垃圾收集信息。
     *  **-printcompilation**：输出JIT编译的方法信息。  
 * -t参数可以在输出信息前面加上一个Timestamp列，显示程序运行的时间。
 * -h参数可以在周期性的数据输出时，输出多少行数据后，跟着输出一个表头信息。
 * interval参数用于指定输出统计数据的周期，单位为毫秒(ms)。
 * count参数用于指定一共输出多少次数据。

## 详细使用
### -class使用
下面命令输出pid为2500这个进程的ClassLoader相关信息，每秒统计一次信息，一共输出两次。
![这里写图片描述](http://img.blog.csdn.net/20150602003709009)
Loaded表示载入的类的数量，第一个Bytes表示载入的类的合计大小，Unloaded表示卸载的类数量，第二个Bytes表示卸载的类的合计大小，Time表示加载和卸载类花的总的时间。

### -compiler使用
下面的命令查看JIT编译的信息：
![这里写图片描述](http://img.blog.csdn.net/20150602004116925)

Compiled表示编译任务执行的次数，Failed表示编译失败的次数，Invalid表示编译不可用的次数，Time表示编译的总耗时，FailedType表示最后一次编译的类型，FailedMethod表示最后一次编译失败的类名和方法名。

### -gc使用
下面的命令显示与gc相关的堆信息的输出：
![这里写图片描述](http://img.blog.csdn.net/20150602004613119)

* S0C：s0(from)的大小(KB)
* S1C：s1(from)的大小(KB)
* S0U：s0(from)已使用的空间(KB)
* S1U：s1(from)已经使用的空间(KB)
* EC：eden区的大小(KB)
* EU：eden区已经使用的空间(KB)
* OC：老年代大小(KB)
* OU：老年代已经使用的空间(KB)
* PC：永久区大小(KB)
* PU：永久区已经使用的空间(KB)
* YGC：新生代gc次数
* YGCT：新生代gc耗时
* FGC：Full gc次数
* FGCT：Full gc耗时
* GCT：gc总耗时

### -gccapacity使用
下面的命令显示了各个代的信息，与-gc相比，它不仅输出了各个代的当前大小，还输出了各个代的最大值与最小值：
![这里写图片描述](http://img.blog.csdn.net/20150602005310719)
* NGCMN：新生代最小值(KB)
* NGCMX：新生代最大值(KB)
* NGC：当前新生代大小(KB)
* OGCMN：老年大最小值(KB)
* OGCMX：老年代最大值(KB)
* OGC：当前老年代大小(KB)
* PGCMN：永久代最小值(KB)
* PGCMX：永久代最大值(KB)

### -gccause使用
下面命令显示最近一次gc的原因，以及当前gc的原因：
![这里写图片描述](http://img.blog.csdn.net/20150602005843699)

* LGCC：上次gc的原因，从图中可以看到上次gc的原因是Allocation Failure
* GCC：当前gc的原因，图中当前没有gc

### -gcnew使用
下面的命令显示新生代的详细信息:
![这里写图片描述](http://img.blog.csdn.net/20150602005922047)
* TT：新生代对象晋升到老年代对象的年龄。
* MTT：新生代对象晋升到老年代对象的年龄的最大值。
* DSS：所需的Survivor区的大小。

### -gcnewcapacity使用
下面的命令详细输出了新生代各个区的大小信息：
![这里写图片描述](http://img.blog.csdn.net/20150602010141932)
* S0CMX：s0区的最大值(KB)
* S1CMX：s1区的最大值(KB)
* ECMX：eden区的最大值(KB)

### -gcold使用
下面的命令显示老年代gc概况：
![这里写图片描述](http://img.blog.csdn.net/20150602010345984)

### -gcoldcapacity使用
下面的命令用于显示老年代的容量信息：
![这里写图片描述](http://img.blog.csdn.net/20150602010443688)

### -gcpermcapacity使用
下面的命令用于显示永久区的使用情况：
![这里写图片描述](http://img.blog.csdn.net/20150602010716581)
