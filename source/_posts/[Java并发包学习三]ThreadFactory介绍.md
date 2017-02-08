title: "[Java并发包学习三]ThreadFactory介绍"
tags: [Java,并发库]
categories: [Java,并发库]
date: 2013-08-13 20:48:37
---
# 概述
ThreadFactory翻译过来是线程工厂，顾名思义，就是用来创建线程的，它用到了工厂模式的思想。它通常和线程池一起使用，主要用来控制创建新线程时的一些行为，比如设置线程的优先级，名字等等。它是一个接口，接口中只有一个方法:
<!--more-->
```
    /**
     * Constructs a new {@code Thread}.  Implementations may also initialize
     * priority, name, daemon status, {@code ThreadGroup}, etc.
     *
     * @param r a runnable to be executed by new thread instance
     * @return constructed thread, or {@code null} if the request to
     *         create a thread is rejected
     */
    Thread newThread(Runnable r);
```
子类实现此方法并在其中完成自定义的行为。  


# 实验
下面我们通过一个简单的实验来解释ThreadFactory的作用，下面的代码首先创建一个类MyThreadFactoryTest，实现了ThreadFactory，newThread()方法中做了一些简单的行为：  

* 创建新线程时，为线程设置一个名字；  
* 创建新线程时，在控制台打印一条提示信息，并附上新线程的名字




```
package com.winwill.thread;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author qifuguang
 * @date 15/8/11 20:28
 */
public class MyThreadFactoryTest implements ThreadFactory {
    private final AtomicInteger count = new AtomicInteger(0);

    public Thread newThread(Runnable r) {
        int c = count.incrementAndGet();
        Thread t = new Thread(r);
        t.setName("test_thread_no." + c);
        System.out.println("Create new thread, thread name: " + t.getName());
        return t;
    }

    public static void main(String[] args) throws Exception {
        ExecutorService service = Executors.newFixedThreadPool(5, new MyThreadFactoryTest());
        for (int i = 0; i < 5; i++) {
            service.submit(new Runnable() {
                public void run() {
                    System.out.println("Start execute...");
                }
            });
        }
    }
}
```
运行这段程序会得到如下的结果：
> Create new thread, thread name: test_thread_no.1
Create new thread, thread name: test_thread_no.2
Start execute...
Start execute...
Create new thread, thread name: test_thread_no.3
Start execute...
Create new thread, thread name: test_thread_no.4
Start execute...
Create new thread, thread name: test_thread_no.5
Start execute...

可以看到，运行结果符合我们的预期。

# JDK中默认的ThreadFactory
在JDK的Executors类中有一个DefaultThreadFactory类，它实现了ThreadFactory，它是JDK中默认的线程工厂类，从源码可以看到这个线程工厂类为线程池中新创建的线程设置的名字为：
> pool-[线程池编号]-thread-[该线程池的线程编号]

```
 /**
     * The default thread factory
     */
    static class DefaultThreadFactory implements ThreadFactory {
        private static final AtomicInteger poolNumber = new AtomicInteger(1);
        private final ThreadGroup group;
        private final AtomicInteger threadNumber = new AtomicInteger(1);
        private final String namePrefix;

        DefaultThreadFactory() {
            SecurityManager s = System.getSecurityManager();
            group = (s != null) ? s.getThreadGroup() :
                                  Thread.currentThread().getThreadGroup();
            namePrefix = "pool-" +
                          poolNumber.getAndIncrement() +
                         "-thread-";
        }

        public Thread newThread(Runnable r) {
            Thread t = new Thread(group, r,
                                  namePrefix + threadNumber.getAndIncrement(),
                                  0);
            if (t.isDaemon())
                t.setDaemon(false);
            if (t.getPriority() != Thread.NORM_PRIORITY)
                t.setPriority(Thread.NORM_PRIORITY);
            return t;
        }
    }
```
