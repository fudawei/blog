title: "[Java]常用虚拟机参数"
date: 2013-08-01 03:38:29
tags: [Java,JVM]
categories: [Java,JVM]
---
* -XX:+PrintGC   启动java虚拟机后，只要遇到gc，就打印日志。
* -XX:+PrintGCDetails  gc发生时，打印更详细的日志。
* -XX:+PrintHeapAtGC  gc发生时，打印更详细的堆信息。
<!--more-->
* -XX:+PrintGCTimeStamps gc发生时，额外打印gc时间，该时间为虚拟机启动到现在的时间偏移量。
* -XX:+PrintGCApplicationConcurrentTime gc时打印应用程序执行的时间。
* -XX:+PrintGCApplicationStoppedTime gc时打印应用程序由于gc产生停顿的时间。
* -XX:+PrintReferenceGC  跟踪系统内的软引用，若引用，虚引用和Finallize队列。
* -Xloggc 指定gc日志的保存路径。
* -XX:+TraceClassLoading  跟踪类加载。
* -XX:+TraceClassUnloading 跟踪类卸载。
* -XX:+PrintVMOptions 程序运行时，打印虚拟机接收到的命令行显示参数。
* -XX:+PrintCommandLineFlags 打印传递给虚拟机的显式和隐式参数。
* -XX:+PrintFlagsFinal 打印所有系统参数的值。
* -Xms 指定初始堆空间的大小，例如-Xms20m
* -Xmx 指定最大堆空间的大小，例如-Xmx100m
* -Xmn 指定新生代的大小，例如-Xmn1m
* -XX:MaxHeapSize 指定最大内存。
* -XX:SurvivorRatio 指定新生代中eden区和from/to区的比例关系。
* -XX:NewRatio 设置新生代和老生带的比例，注意：这个值的含义是 老生带/新生代。
* -XX:+HeapDumpOnOutOfMemoryError 内存溢出时，导出整个堆的信息，和下一个参数配合使用。
* -XX:HeapDumpPath 导出的堆信息的保存路径，和上一个参数配合使用。
* -XX:OnOutOfMemoryError 内存溢出发生错误时执行一个脚本文件。
* -XX:PermSize 配置初始永久区的大小(JDK8中永久区已经被彻底移除，使用了新的元数据区存放类的元数据)。
* -XX:MaxPermSize 配置最大永久区的大小(JDK8中永久区已经被彻底移除，使用了新的元数据区存放类的元数据)。
* -XX:MaxMetaspaceSize 指定永久区最大可用值。
* -Xss 指定线程的栈大小。
* -XX:MaxDirectMemorySize 指定最大可用直接内存值。
* -server 指定虚拟机在server模式下工作。
* -client 指定虚拟机在client模式下工作。
