title: "[JDK工具学习六]jstack命令使用"
tags: [Java,JDK工具]
categories: [Java,JDK工具]
date: 2015-08-01 09:36:05
---
## 概述
jstack可用于导出java运用程序的线程堆栈，其基本使用语法为：
> jstack [-l] pid

-l 选项用于打印锁的额外信息。
<!--more-->
## 使用示例
下面这段代码运行之后会出现死锁现象(因为线程1持有lock1，在等待lock2，线程2持有lock2在等待lock1，造成了循环等待，形成死锁)：
```
package com.winwill.deadlock;

/**
 * @author qifuguang
 * @date 15/6/4 16:45
 */
public class TestDeadLock {
    private static final Object lock1 = new Object();
    private static final Object lock2 = new Object();

    public static void main(String[] args) {

        Thread t1 = new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (lock1) {
                    try {
                        Thread.sleep(1000);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    synchronized (lock2) {
                        System.out.println("线程1执行....");
                    }
                }
            }
        });

        Thread t2 = new Thread(new Runnable() {
            @Override
            public void run() {
                synchronized (lock2) {
                    try {
                        Thread.sleep(1000);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                    synchronized (lock1) {
                        System.out.println("线程2执行...");
                    }
                }
            }
        });

        t1.start();
        t2.start();
    }
}
```

我们运行这段代码，然后使用jstack命令导出这个程序的线程堆栈信息：
>[qifuguang@Mac~]$ jstack -l 21023 > /tmp/deadlock.txt

打开导出的线程堆栈信息文件，文件末尾如下所示：

![这里写图片描述](http://img.blog.csdn.net/20150604165946198)

如图所示，导出的线程堆栈文件中明确提示发现死锁，并且指明了死锁的原因。

## 总结
jstack不仅能够导出线程堆栈，还能自动进行死锁检测，输出线程死锁原因。

