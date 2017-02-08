title: '[Java并发包学习六]Semaphore介绍'
tags: [Java,并发库]
categories: [Java,并发库]
date: 2013-08-26 00:36:36
---
# 概述
emaphore字面意思是信号量。他主要用于控制有限的资源的访问数量。我们看一个生活中常常出现的场景：
<!--more-->
> 一个厕所只有3个坑位，但是有10个人来上厕所，那怎么办？假设10的人的编号分别为1-10，并且1号先到厕所，10号最后到厕所。那么1-3号来的时候必然有可用坑位，顺利如厕，4号来的时候需要看看前面3人是否有人出来了，如果有人出来，进去，否则等待。同样的道理，4-10号也需要等待正在上厕所的人出来后才能进去，并且谁先进去这得看等待的人是否有素质，是否能遵守先来先上的规则。


在这种场景下，Semaphore便派上了用场。
# 基本函数介绍
## 构造函数
构造函数使用一个初始非零整数初始化Semaphore，表示最开始的时候的可用资源（上例中的厕所坑位）数量。有两种类型的构造函数，函数签名分别如下：

```
public Semaphore(int permits)
public Semaphore(int permits, boolean fair)
```
其中permits参数表示初始的可用资源数量，fair参数表示是否使用公平策略（是否按照先来线上的顺序）选择正在等候的使用者（上例中的上厕所的人），fair为**true**表示公平策略，采用先来先用的算法，为**false**表示非公平策略，完全随机，默认使用非公平策略。

## acquire函数
acquire函数用来申请资源，有两种不同的函数，签名分别如下：

```
public void acquire() throws InterruptedException 
public void acquire(int permits) throws InterruptedException
```
第一个函数用来申请一个资源，第二个函数用来申请permits个资源，当没有需要申请的数量这么多个资源时，申请线程会被阻塞，直到有可用资源或者申请线程被打断，如果申请线程被打断，则抛出InterruptedException异常。

## acquireUninterruptibly函数
翻译过来就是不可能被打断的申请，对，该函数用来申请可用资源，并且不会被打断，也有两种类型，函数签名分别如下：

```
public void acquireUninterruptibly()
public void acquireUninterruptibly(int permits)
```
第一个函数用来申请一个资源，第二个函数用来申请permits个资源。就算线程在申请资源过程中被打断，依然会继续申请，只不过获取资源的时间可能会有所变化。

## tryAcquire函数
tryAcquire函数用来获取可用资源，但是这类函数能够有时间的限制，如果超时，立即返回，有几种类型的函数，签名分别如下：

```
public boolean tryAcquire()
public boolean tryAcquire(long timeout, TimeUnit unit)
        throws InterruptedException
public boolean tryAcquire(int permits)
public boolean tryAcquire(int permits, long timeout, TimeUnit unit)
        throws InterruptedException
```
1. 第一个函数用来申请一个资源，如果当前有可用资源，立即返回true，否则立即返回false；
2. 第二个函数用来申请一个资源，指定一个超时时间，如果当前可以资源数量足够，立即返回true，否则最多等待给定的时间，如果时间到还是未能获取资源，则返回false；如果等待过程中线程被打断，抛出InterruptedException异常；
3. 和1一样，只是申请permits个资源；
4. 和2一样，只是申请permits个资源。

## release函数
release函数用来释放资源，就好比说蹲厕所的人出来了，让出了坑位。有两种类型，函数签名分别如下：

```
public void release()
public void release(int permits)
```
第一个函数释放一个资源，第二个函数释放permits个资源。

## availablePermits函数
availablePermits函数用来获取当前可用的资源数量，函数签名如下：

```
public int availablePermits()
```

## drainPermits函数
drainPermits函数用来申请当前所有可用的资源，函数签名如下：

```
public int drainPermits()
```
函数返回申请到的资源的个数。

## reducePermits函数
reducePermits函数用来禁止某些资源不可用，函数签名如下：

```
protected void reducePermits(int reduction)
```
reduction表示禁止的数量，比如由于厕所马桶坏了，有一个坑位不能用，此时就可以调用该函数禁止一个资源不可用。如果reduction小于零，则抛出IllegalArgumentException异常。

## isFair函数
isFair函数用来判断当前的信号量是采用什么类型的策略，函数签名如下：

```
public boolean isFair()
```
函数返回**true**表示采用的是公平策略，返回**false**表示采用非公平策略。

## hasQueuedThreads函数
hasQueuedThreads函数用来判断是否有现成正在等待申请资源，函数签名如下：

```
public final boolean hasQueuedThreads()
```
返回**true**表示有现成正在等待申请资源，**false**表示没有，需要注意的是：**因为申请过程是可以取消的，函数返回true并不表示肯定会申请资源，该函数设计的初衷是用来做系统监控的。**

## getQueueLength函数
getQueueLength函数用来返回正在等待申请资源的线程的数量，函数签名如下：

```
public final int getQueueLength()
```
返回当前正在等待申请资源的线程数。

## getQueuedThreads函数
getQueuedThreads函数返回当前正在等待申请资源的线程集合，函数签名如下：

```
protected Collection<Thread> getQueuedThreads()
```

# 模拟实验
下面用代码来模拟如下场景：

> 一个厕所只有3个坑位，有6个人（编号1-6）先后来上厕所，采用先来先上的策略。

代码如下:

```
package com.winwill.test;

import java.util.Random;
import java.util.concurrent.Semaphore;

/**
 * @author qifuguang
 * @date 15/8/25 23:23
 */
public class TestSemaphore {
    public static void main(String[] args) throws Exception {
        Semaphore wc = new Semaphore(3, true); // 3个坑位
        for (int i = 1; i <= 6; i++) {
            Thread t = new Thread(new Person("第" + i + "个人", wc));
            t.start();
            Thread.sleep(new Random().nextInt(300));
        }
    }

    static class Person implements Runnable {
        private String name;
        private Semaphore wc;

        public Person(String name, Semaphore wc) {
            this.name = name;
            this.wc = wc;
        }

        public void run() {
            System.out.print(name + "：憋死老子了!");
            if (wc.availablePermits() > 0) {
                System.out.println("天助我也，有坑位！");
            } else {
                System.out.println("卧槽，没坑位了，等会儿吧...");
            }
            try {
                wc.acquire(); //申请坑位
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(name + "：终于轮到我了，拉屎就是爽！");
            try {
                Thread.sleep(new Random().nextInt(1000)); // 模拟上厕所时间。
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(name + "：拉完了，好臭!");
            wc.release();
        }
    }
}
```
运行结果：
>第1个人：憋死老子了!天助我也，有坑位！  
第1个人：终于轮到我了，拉屎就是爽！  
第2个人：憋死老子了!天助我也，有坑位！  
第2个人：终于轮到我了，拉屎就是爽！  
第3个人：憋死老子了!天助我也，有坑位！  
第3个人：终于轮到我了，拉屎就是爽！  
第3个人：拉完了，好臭!  
第4个人：憋死老子了!天助我也，有坑位！  
第4个人：终于轮到我了，拉屎就是爽！  
第5个人：憋死老子了!卧槽，没坑位了，等会儿吧...  
第6个人：憋死老子了!卧槽，没坑位了，等会儿吧...  
第2个人：拉完了，好臭!  
第5个人：终于轮到我了，拉屎就是爽！  
第4个人：拉完了，好臭!  
第6个人：终于轮到我了，拉屎就是爽！  
第1个人：拉完了，好臭!  
第6个人：拉完了，好臭!  
第5个人：拉完了，好臭!  

可以看到，任何时候在用坑位的人数都控制在3人之内，并且开始蹲坑的顺序一定是按编号从小到大来的（公平策略）。

# 注意事项
* release函数和acquire并没有要求一定是同一个线程都调用，可以A线程申请资源，B线程释放资源；
* 调用release函数之前并没有要求一定要先调用acquire函数。
