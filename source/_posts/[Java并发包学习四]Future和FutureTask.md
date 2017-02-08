title: "[Java并发包学习四]Future和FutureTask"
tags: [Java,并发库]
categories: [Java,并发库]
date: 2013-08-21 14:02:02
---
# 概述
Future主要用来表示线程异步执行的结果，他提供了检查异步执行的程序是否已经执行完毕、是否已经被取消，并且获取执行结果的方法。它是一个接口，接口的定义如下：
<!--more-->
```
public interface Future<V> {
    boolean cancel(boolean mayInterruptIfRunning);
    boolean isCancelled();
    boolean isDone();
    V get() throws InterruptedException, ExecutionException;
    V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException;
}
```
JDK中的FutureTask类是这个接口的最基本的实现。

# 成员函数介绍
## cancel函数
cancel函数用来取消一个正在异步执行的任务，如果任务还没有开始，则该任务将不会再被执行，如果任务已经在执行，则可以通过mayInterruptIfRunning参数来决定是否需要尝试取消正在执行的任务，如果mayInterruptIfRunning参数为**true**则将取消正在运行的任务，为**false**则不会打断，该任务能正常结束。    

## isCanceled函数
isCanceled函数用来判断一个任务是否已经被取消，如果一个任务在正常执行结束之前被取消，则该函数返回**true**，否则返回**false**。

## isDone函数
isDone函数用来检测一个任务是否已经结束，结束的原因可以分为以下几种情况：  

* 正常完成； 
* 抛出异常而退出；
* 被cancel函数取消；

以上这三种情况，该函数都会返回**true**，否则返回**false**。

## get函数
get函数用来获取异步执行的结果，需要说明的是，对于没有参数的get函数，如果任务没有执行完毕，该函数会一直阻塞，直到任务结束，然后再返回执行的结果；而有timeout和unit两个参数的get函数能提供一个最长等待时间，如果过了给定的时间，任务仍然没有完毕，则抛出TimeoutException，否则返回任务执行结果。

# 基本用法
下面的例子演示怎么使用Future来获取异步执行的结果，假设这样一个场景：
> 我们现在正在家里打dota(笔者是个dota爱好者^_^)，突然口渴了，想喝点白开水，于是我们需要烧开水，烧开水是一个比较耗时的事情，所以热水器(烧水线程)在烧开水的时候我们（主线程）不应该在一旁干等着，而是可以继续玩dota。等到被干死了之后或者上了别人高地之后再去检查开水是否已经烧好了。

在这个场景中，我就好比是程序的主线程，而热水器就是我创建的副线程，它的主要任务就是烧水。副线程在进行比较耗时的时候主线程可以去干它自己喜欢的事情，等到空闲的时候再去检查副线程任务是否完成，然后获取任务执行结果。
## 代码演示
下面的代码演示上述场景：

```
package com.winwill.test;

import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

/**
 * @author qifuguang
 * @date 15/8/21 11:29
 */
public class TestFuture {
    static class BoilWater implements Callable<String> {
        public String call() throws Exception {
            Thread.sleep(5000);            // 模拟一个耗时操作
            return System.currentTimeMillis() + " | 热水器：主人，水烧开了";   //烧水完成
        }
    }

    public static void main(String[] args) throws Exception {
        //创建一个线程池，相当于找到一个热水器
        FutureTask futureTask = new FutureTask(new BoilWater());
        // 开始烧水
        // Executors.newCachedThreadPool().submit(futureTask); 这样使用线程池的形式，
        // 结果是一样的
        new Thread(futureTask).start();
        System.out.println(System.currentTimeMillis() + " | 我：小热，你可以开始烧水了...");

        // 继续打Dota
        System.out.println(System.currentTimeMillis() + " | 我：继续开心地玩Dota...");
        Thread.sleep(4000);
        System.out.println(System.currentTimeMillis() + " | 我：Oh，我死了...");

        // 被干了或者上对面高地了，有时间来检查水是否烧好了。
        System.out.println(System.currentTimeMillis() + " | 我：看看水烧好没...");
        while (!futureTask.isDone()) {
            System.out.println(System.currentTimeMillis() + " | 我：水还没烧开，小热，你快点烧，我再给你一秒钟...");
            Thread.sleep(1000);
        }
        // 使用get函数来获取烧水结果
        System.out.println((String) futureTask.get());
    }

}
```
执行结果为：
>1440129236549 | 我：小热，你可以开始烧水了...  
>1440129236549 | 我：继续开心地玩Dota...  
>1440129240554 | 我：Oh，我死了...  
>1440129240554 | 我：看看水烧好没...  
>1440129240554 | 我：水还没烧开，小热，你快点烧，我再给你一秒钟...  
>1440129241553 | 热水器：主人，水烧开了   

可以看到，我和小热分工明确，我玩dota，他烧水，**他烧水的时候我并没有傻傻地等着!**

# 其他
RunnableFuture继承了Runnable接口和Future接口，而FutureTask实现了RunnableFuture接口。所以它既可以作为Runnable被线程执行，又可以作为Future得到Callable的返回值。
