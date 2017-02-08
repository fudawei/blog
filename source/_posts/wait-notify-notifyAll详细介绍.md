title: 'wait,notify,notifyAll详细介绍'
tags: [Java]
categories: [Java]
date: 2012-10-23 14:05:18
---

# 概述
wait，notify和notifyAll方法是Object类的成员函数，所以Java的任何一个对象都能够调用这三个方法。这三个方法主要是用于线程间通信，协调多个线程的运行。

<!--more-->
# wait函数
调用线程的sleep，yield方法时，线程并不会让出对象锁，wait却不同。

**wait函数必须在同步代码块中调用(也就是当前线程必须持有对象的锁)**，他的功能是这样的：

>我累了，休息一会儿，对象的锁你们拿去用吧，CPU也给你们。


调用了wait函数的线程会一直等待，直到有其他线程调用了同一个对象的notify或者notifyAll方法才能被唤醒，需要注意的是：被唤醒并不代表立即获得对象的锁。也就是说，一个线程调用了对象的wait方法后，他需要等待两件事情的发生：

1. 有其他线程调用同一个对象的notify或者notifyAll方法（调用notify/notifyAll方法之前）
2. 被唤醒之后重新获得对象的锁(调用notify/notifyAll方法之后)

才能继续往下执行后续动作。

如果一个线程调用了某个对象的wait方法，但是后续并没有其他线程调用该对象的notify或者notifyAll方法，则该线程将会永远等下去...

# notify和notifyAll方法
**notofy/notifyAll方法也必须在同步代码块中调用(也就是调用线程必须持有对象的锁)**，他们的功能是这样的：

> 女士们，先生们请注意，锁的对象我即将用完，请大家醒醒，准备一下，马上你们就能使用锁了。


不同的是，notify方法只会唤醒一个正在等待的线程(至于唤醒谁，不确定！)，而notifyAll方法会唤醒所有正在等待的线程。还有一点需要特别强调：**调用notify和notifyAll方法后，当前线程并不会立即放弃锁的持有权，而必须要等待当前同步代码块执行完才会让出锁。**

如果一个对象之前没有调用wait方法，那么调用notify方法是没有任何影响的。

# 小试牛刀
下面我们举例子来巩固上面讲到的理论知识,下面的代码创建了两个线程，Thread1在同步代码块中调用wait，Thread2在同步代码块中调用notify：

```
package com.winwill.test;

/**
 * @author 飞鸟
 * @date 15/8/14 16:37
 */
public class Test {
    private static final Object lock = new Object();

    public static void main(String[] args) {
        new Thread(new Thread1()).start();
        new Thread(new Thread2()).start();
    }

    static class Thread1 implements Runnable {

        @Override
        public void run() {
            System.out.println("Thread1 start...");
            synchronized (lock) {
                try {
                    lock.wait();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            System.out.println("Thread1 stop...");
        }
    }

    static class Thread2 implements Runnable {

        @Override
        public void run() {
            System.out.println("Thread2 start...");
            synchronized (lock) {
                lock.notify();
                System.out.println("Thread2 stop...");
            }
        }
    }
}

```
运行结果如下：
>Thread1 start...  
Thread2 start...  
Thread2 stop...  
Thread1 stop...  

从上面的例子可以证实上面说到的一个结论：**线程调用notify方法后并不会让出锁，而必须等待同步代码块执行完毕之后再让出**，可以看到执行结果中Thread2的开始和结束是成对挨着出现的。

# 总结
这三个函数的相互通信可以做很多事情，比如常见的生产者-消费者模式，生产者要往队列里面生产东西，就必须等待队列有空间，同样的，消费者要同队列里面消费东西，就必须等待队列里有东西。使用wait,notify,notifyAll方法可以协调生产者和消费者之间的行为。在JDK1.4之后出现了一个Condition类，这个类也能够实现相同的功能，并且一般建议使用Condition替代wait,notify,notifyAll家族，实现更安全的线程间通信功能，比如ArrayBlockingQueue就是使用Condition实现阻塞队列的。

# 声明
本文为作者原创，转载请注明出处，本文链接：[http://fudawei.github.io/2015/10/23/wait-notify-notifyAll%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D/](http://fudawei.github.io/2015/10/23/wait-notify-notifyAll%E8%AF%A6%E7%BB%86%E4%BB%8B%E7%BB%8D/)

