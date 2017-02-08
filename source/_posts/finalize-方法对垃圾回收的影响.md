title: "finalize-方法对垃圾回收的影响"
date: 2013-08-06 09:08:10
tags: [Java,JVM]
categories: [Java,JVM]
---
### 概述
>Java中提供了一个类似C++析构函数的机制: finalize()方法，该函数允许子类重载，用于在对象被回收是释放资源。

但是一般情况下，尽量不要使用finalize函数进行资源的释放，原因主要有一下几点:
<!--more-->
* finalize函数调用时，有可能导致对象复活。
* finalize函数执行的时间没有保障，他完全由GC线程决定，正常情况下，若不发生gc，则finalize一直都没有机会被执行。
* 一个糟糕的finalize函数会严重影响gc的性能。

### 实验
下面通过一个实验来看看：

```
package com.winwill.jvm;

/**
 * @author qifuguang
 * @date 15-5-29 下午8:24
 */
public class TestFinalizer {
    public static class LY {
        private byte[] content = new byte[512];

        @Override
        protected void finalize() {
            try {
                System.out.println("回收线程:" + Thread.currentThread().getId());
                Thread.sleep(1000);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        long tsStart = System.currentTimeMillis();
        for (int i = 0; i < 50000; i++) {
            LY ly = new LY();
        }
        System.out.println("耗时:" + (System.currentTimeMillis() - tsStart));
    }
}
```
上面这个例子创建了一个内部类TestFinalizer$LY，这个类有一个成员变量，只占用512字节，还重载了finalize函数，其中的sleep操作模拟一个比较耗时的动作。然后主函数中通过一个循环不断地创建LY对象，因为循环中创建的对象没有被其他对象引用，所以创建之后就应该被回收。

### 实验结果
我们使用如下参数运行该程序：
>-Xmx10m  -Xms10m  -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/qifuguang/dump.bin

也就是将虚拟机的初始和最大堆内存都设置为10m，并且如果发生OOM，则将内存信息dump出来。按照前文所说，每个对象创建之后都应该立马被回收，所以10m空间创建这么多对象应该是没有问题的，只不过会多发生几次gc而已，但是运行的结果却是这样的：
>回收线程:3
java.lang.OutOfMemoryError: Java heap space
Dumping heap to /home/qifuguang/dump.bin ...
Heap dump file created [11569716 bytes in 0.046 secs]
Exception in thread "main" 
Exception: java.lang.OutOfMemoryError thrown from the UncaughtExceptionHandler in thread "main"

发生了内存溢出！！！

### 结果分析
为什么会出现上面的结果呢？我们找到dump出来的文件，然后使用eclipse的MAT插件打开这个文件之后可以看到内存中存在大量的java.lang.ref.Finalizer对象。
![这里写图片描述](http://img.blog.csdn.net/20150529205328228)

这会是什么原因呢？原来finalize函数是由FinalizerThread线程处理的，每一个即将回收的并且包含finalize函数的对象都会在正式回收前加入FinalizerThread的执行队列，该队列为java.lang.ref.ReferenceQueue引用队列，内部实现为链表结构，队列中的每一项为java.lang.ref.Finalizer引用对象，它本质为一个引用，在该例中这些引用就指向了LF对象。由于LF对象被加入了引用队列，并且被“强引用”，所以就阻止了对象的正常回收，并且引用队列中的对象排队执行finalize函数，处理得比较慢，回收速度比不上创建对象的速度，所以就出现了OOM(Out Of Memory)错误。

### 结论
但是话又说回来了，虽然finalize函数不推荐使用，但是在某些场合，使用finalize函数可以起到双保险为作用，比如在Mysql的JDBC驱动中，com.mysql.jdbc.ConnectionImpl就实现了finalize函数，在函数中执行了连接的关闭操作，这样如果开发人员开发过程中忘记关闭不需要的连接，在对象回收时也会被强制关闭，确保数据库没有连接泄露。

