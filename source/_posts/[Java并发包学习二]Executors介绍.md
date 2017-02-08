title: "[Java并发包学习二]Executors介绍"
tags: [Java,并发库]
categories: [Java,并发库]
date: 2013-08-12 16:52:56
---
# 概述
Executors类是JDK 1.5开始自带的一个非常强大的主要用于创建各类线程池的工具类。
<!--more-->

# 常用方法介绍
## newFixedThreadPool
newFixedThreadPool方法有两种函数签名：  

```
public static ExecutorService newFixedThreadPool(int nThreads)  
public static ExecutorService newFixedThreadPool(int nThreads, ThreadFactory threadFactory)
```
这两个函数用于创建一个最大线程数目固定的线程池，该线程池用一个共享的无界队列来存储提交的任务。参数nThreads指定线程池的最大线程数，参数[threadFactory](http://飞鸟.com/2015/08/11/JDK8-%E5%B9%B6%E5%8F%91%E5%8C%85%E5%AD%A6%E4%B9%A0-ThreadFactory%E4%BB%8B%E7%BB%8D%EF%BC%88%E4%BA%8C%EF%BC%89/)是线程工厂类，主要用于自定义线程池中创建新线程时的行为。需要说明的是，创建线程池时，如果线程池没有接收到任何任务，则线程池中不会创建新线程，在线程池中线程数目少于最大线程数时，每来一个新任务就创建一个新线程，当线程数达到最大线程数时，不再创建新线程，新来的任务存储在队列中，之后线程数目不再变化！

## newWorkStealingPool
newWorkStealingPool方法有两种函数签名：

```
public static ExecutorService newWorkStealingPool(int parallelism)
public static ExecutorService newWorkStealingPool()
```
这两个方法用于创建ForkJoin框架中用到的ForkJoinPool线程池，第一个函数中的参数用于指定并行数，第二个函数没有参数，它默认使用当前机器可用的CPU个数作为并行数。

## newSingleThreadExecutor
newSingleThreadExecutor用于创建只有一个线程的线程池，有两种函数签名：

```
public static ExecutorService newSingleThreadExecutor()
public static ExecutorService newSingleThreadExecutor(ThreadFactory threadFactory)
```
线程池中的任务使用无界队列存储，第二个函数可以指定threadFactory，自定义创建线程时的行为。

## newCachedThreadPool
newCachedThreadPoolf方法用于创建线程数数目可以随着实际情况自动调节的线程池，也有两种类型的函数签名：

```
public static ExecutorService newCachedThreadPool()
public static ExecutorService newCachedThreadPool(ThreadFactory threadFactory)
```
这种线程池的最大线程数只受到操作系统可以创建的最大线程数数目限制，当线程池有很多任务需要处理时，会不断地创建新线程，当任务处理完毕之后，如果某个线程空闲时间大于60s，则该线程将会被销毁。因为这种线程池能够自动调节线程数量，所以比较适合执行大量的短期的小任务。

## newSingleThreadScheduledExecutor
newSingleThreadScheduledExecutor该方法用于创建只有一个线程的线程池，并且该线程定时周期性地执行给定的任务，有两种类型的函数签名：

```
public static ScheduledExecutorService newSingleThreadScheduledExecutor()
public static ScheduledExecutorService newSingleThreadScheduledExecutor(ThreadFactory threadFactory)
```
需要注意的是: **线程在周期性地执行任务时如果遇到Exception，则以后将不再周期性地执行任务。**

## newScheduledThreadPool
newScheduledThreadPool用于创建一个线程池，线程池中得线程能够周期性地执行给定的任务，有两种函数签名：

```
public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize)
public static ScheduledExecutorService newScheduledThreadPool(
            int corePoolSize, ThreadFactory threadFactory)
```

## unconfigurableExecutorService
unconfigurableExecutorService主要用于包装现有的线程池，包装之后的线程池不能修改，相当于final的，函数签名如下：

```
public static ExecutorService unconfigurableExecutorService(ExecutorService executor)
```

## unconfigurableScheduledExecutorService
unconfigurableScheduledExecutorService用于包装可以周期性执行任务的线程池，包装之后的线程池不能修改，相当于final，函数签名如下：

```
public static ScheduledExecutorService unconfigurableScheduledExecutorService(ScheduledExecutorService executor)
```

## defaultThreadFactory
defaultThreadFactory方法返回默认的工厂方法类，默认的工厂方法为线程池中新创建的线程命名为：
> pool-[虚拟机中线程池编号]-thread-[线程编号]

函数签名如下：

```
public static ThreadFactory defaultThreadFactory()
```


