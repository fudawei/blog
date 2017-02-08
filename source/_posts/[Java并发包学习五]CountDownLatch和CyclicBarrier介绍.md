title: '[Java并发包学习五]CountDownLatch和CyclicBarrier介绍'
tags: [Java,并发库]
categories: [Java,并发库]
date: 2013-08-25 01:06:01
---
# 概述
JDK中提供了一些用于线程之间协同等待的工具类，CountDownLatch和CyclicBarrier就是最典型的两个线程同步辅助类。下面分别详细介绍这两个类，以及他们之间的异同点。
<!--more-->

# CountDownLatch类
CountDownLatch顾名思义：**倒计数锁存器**。没错，他就是一个计数器，并且是倒着计数的。他的应用场景如下：
> 一个任务A，他需要等待其他的一些任务都执行完毕之后它才能执行。就比如说赛跑的时候，发令员需要等待所有运动员都准备好了才能发令，否则不被K才怪嘞！

此时CountDownLatch就可以大展身手了。

## 常用操作
本节介绍CountDownLatch的基本操作函数。
### 构造函数
函数签名如下：

```
public CountDownLatch(int count)
```
用一个给定的数值初始化CountDownLatch，之后计数器就从这个值开始倒计数，直到计数值达到零。

### await函数
await函数用两种形式，签名分别如下：

```
public void await() throws InterruptedException
public boolean await(long timeout, TimeUnit unit)
```
这两个函数的作用都是让线程阻塞等待其他线程，直到CountDownLatch的计数值变为0才继续执行之后的操作。区别在于第一个函数没有等待时间限制，可以等到天荒地老，海枯石烂，第二个函数给定一个等待超时时间，超过该时间就直接放弃了，并且第二个函数具有返回值，超时时间之内CountDownLatch的值达到0就返回**true**,等待时间结束计数值都还没达到0就返回**false**。这两个操作在等待过程中如果等待的线程被中断，则会抛出InterruptedException异常。

### countDown函数
这个函数用来将CountDownLatch的计数值减一，函数签名如下：

```
public void countDown()
```
需要说明的是，如果调用这个函数的时候CountDownLatch的计数值已经为0，那么这个函数什么也不会做。

### getCount函数
该函数用来获取当前CountDownLatch的计数值，函数签名如下：

```
public void countDown()
```

## 模拟实验
理论知识讲完了，需要真枪实战地来演示一下这个类的作用，我们就以下面这个场景为例子，用CountDownLatch来实现这个需求：
> 有5个运动员赛跑，开跑之前，裁判需要等待5个运动员都准备好才能发令，并且5个运动员准备好之后也都需要等待裁判发令才能开跑。

首先分析一下依赖关系：
> 裁判发令 -> 5个运动员都准备好；  
> 5个运动员开跑 -> 裁判发令。

好，依赖关系已经出来了，代码实现：

```
package com.winwill.test;

import java.util.Random;
import java.util.concurrent.CountDownLatch;

/**
 * @author qifuguang
 * @date 15/8/24 23:35
 */
public class TestCountDownLatch {
    private static final int RUNNER_NUMBER = 5; // 运动员个数
    private static final Random RANDOM = new Random();

    public static void main(String[] args) {
        // 用于判断发令之前运动员是否已经完全进入准备状态，需要等待5个运动员，所以参数为5
        CountDownLatch readyLatch = new CountDownLatch(RUNNER_NUMBER);
        // 用于判断裁判是否已经发令，只需要等待一个裁判，所以参数为1
        CountDownLatch startLatch = new CountDownLatch(1);
        for (int i = 0; i < RUNNER_NUMBER; i++) {
            Thread t = new Thread(new Runner((i + 1) + "号运动员", readyLatch, startLatch));
            t.start();
        }
        try {
            readyLatch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        startLatch.countDown();
        System.out.println("裁判：所有运动员准备完毕，开始...");
    }

    static class Runner implements Runnable {
        private CountDownLatch readyLatch;
        private CountDownLatch startLatch;
        private String name;

        public Runner(String name, CountDownLatch readyLatch, CountDownLatch startLatch) {
            this.name = name;
            this.readyLatch = readyLatch;
            this.startLatch = startLatch;
        }

        public void run() {
            int readyTime = RANDOM.nextInt(1000);
            System.out.println(name + "：我需要" + readyTime + "秒时间准备.");
            try {
                Thread.sleep(readyTime);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(name + "：我已经准备完毕.");
            readyLatch.countDown();
            try {
                startLatch.await();  // 等待裁判发开始命令
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(name + "：开跑...");
        }
    }
}
```
运行结果如下：

>1号运动员：我需要389秒时间准备.  
2号运动员：我需要449秒时间准备.  
3号运动员：我需要160秒时间准备.  
4号运动员：我需要325秒时间准备.  
5号运动员：我需要978秒时间准备.  
3号运动员：我已经准备完毕.  
4号运动员：我已经准备完毕.  
1号运动员：我已经准备完毕.  
2号运动员：我已经准备完毕.  
5号运动员：我已经准备完毕.  
裁判：所有运动员准备完毕，开始...  
1号运动员：开跑...  
5号运动员：开跑...  
2号运动员：开跑...  
4号运动员：开跑...  
3号运动员：开跑...  

可以看到，一切都是如此地完美，运动员准备好了之后裁判才发令，裁判发令之后运动员才开跑。

# CyclicBarrier类
CyclicBarrier翻译过来就是：循环的屏障。什么是循环？可以重复利用呗，对这个类就是一个可以重复利用的屏障类。CyclicBarrier主要用于一组固定大小的线程之间，各个线程之间相互等待，当所有线程都完成某项任务之后，才能执行之后的任务。
如下场景：

> 有若干个线程都需要向一个数据库写数据，但是必须要所有的线程都讲数据写入完毕他们才能继续做之后的事情。

分析一下这个场景的特征： 
 
* 各个线程都必须完成某项任务(写数据)才能继续做后续的任务；  
* 各个线程需要相互等待，不能独善其身。

这种场景便可以利用CyclicBarrier来完美解决。

## 常用函数
本节介绍CyclicBarrier的基本操作函数。
### 构造函数
有两种类型的构造函数，函数签名分别如下：

```
public CyclicBarrier(int parties, Runnable barrierAction)
public CyclicBarrier(int parties)
```
参数parties表示一共有多少线程参与这次“活动”，参数barrierAction是可选的，用来指定当所有线程都完成这些必须的“神秘任务”之后需要干的事情，所以barrierAction这里的动作在一个相互等待的循环内只会执行一次。

### getParties函数
getParties用来获取当前的CyclicBarrier一共有多少线程参数与，函数签名如下：
 
```
public int getParties()
```
返回参与“活动”的线程个数。

### await函数
await函数用来执行等待操作，有两种类型的函数签名：

```
public int await() throws InterruptedException, BrokenBarrierException
public int await(long timeout, TimeUnit unit)
        throws InterruptedException,
               BrokenBarrierException,
               TimeoutException 
```
第一个函数是一个无参函数，第二个函数可以指定等待的超时时间。它们的作用是：一直等待知道所有参与“活动”的线程都调用过await函数，如果当前线程不是即将调用await函数的的最后一个线程，当前线程将会被挂起，直到下列某一种情况发生：

* 最后一个线程调用了await函数；
* 某个线程打断了当前线程；
* 某个线程打断了其他某个正在等待的线程；
* 其他某个线程等待时间超过给定的超时时间；
* 其他某个线程调用了reset函数。

如果等待过程中线程被打断了，则会抛出InterruptedException异常；  
如果等待过程中出现下列情况中的某一种情况，则会抛出BrokenBarrierException异常：

* 其他线程被打断了；
* 当前线程等待超时了；
* 当前CyclicBarrier被reset了；
* 等待过程中CyclicBarrier损坏了；
* 构造函数中指定的barrierAction在执行过程中发生了异常。

如果等待时间超过给定的最大等待时间，则会抛出TimeoutException异常，并且这个时候其他已经嗲用过await函数的线程将会继续后续的动作。

返回值：返回当前线程在调用过await函数的所以线程中的编号，编号为**parties-1**的表示第一个调用await函数，编号为0表示是最后一个调用await函数。

### isBroken函数
给函数用来判断barrier是否已经损坏，函数签名如下：

```
public boolean isBroken()
```
如果因为任何原因被损坏返回**true**，否则返回**false**。

### reset函数
顾名思义，这个函数用来重置barrier，函数签名如下：

```
public void reset()
```
如果调用了该函数，则在等待的线程将会抛出BrokenBarrierException异常。

### getNumberWaiting函数
该函数用来获取当前正在等待该barrier的线程数，函数签名如下：

```
public int getNumberWaiting()
```

## 模拟实验
下面用代码实现下面的场景：
> 有5个线程都需要向一个数据库写数据，但是必须要所有的线程都讲数据写入完毕他们才能继续做之后的事情。

### 一般情况
代码：

```
package com.winwill.test;

import java.util.Random;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

/**
 * @author qifuguang
 * @date 15/8/25 00:34
 */
public class TestCyclicBarrier {
    private static final int THREAD_NUMBER = 5;
    private static final Random RANDOM = new Random();

    public static void main(String[] args) {
        CyclicBarrier barrier = new CyclicBarrier(THREAD_NUMBER, new Runnable() {
            public void run() {
                System.out.println(Thread.currentThread().getId() + "：我宣布，所有小伙伴写入数据完毕");
            }
        });
        for (int i = 0; i < THREAD_NUMBER; i++) {
            Thread t = new Thread(new Worker(barrier));
            t.start();
        }
    }

    static class Worker implements Runnable {
        private CyclicBarrier barrier;

        public Worker(CyclicBarrier barrier) {
            this.barrier = barrier;
        }

        public void run() {
            int time = RANDOM.nextInt(1000);
            System.out.println(Thread.currentThread().getId() + "：我需要" + time + "毫秒时间写入数据.");
            try {
                Thread.sleep(time);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：写入数据完毕，等待其他小伙伴...");
            try {
                barrier.await(); // 等待所有线程都调用过此函数才能进行后续动作
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (BrokenBarrierException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：所有线程都写入数据完毕，继续干活...");
        }
    }
}

```
运行结果如下：

> 10：我需要16毫秒时间写入数据.  
11：我需要353毫秒时间写入数据.  
12：我需要101毫秒时间写入数据.  
13：我需要744毫秒时间写入数据.  
14：我需要51毫秒时间写入数据.  
10：写入数据完毕，等待其他小伙伴...  
14：写入数据完毕，等待其他小伙伴...  
12：写入数据完毕，等待其他小伙伴...  
11：写入数据完毕，等待其他小伙伴...  
13：写入数据完毕，等待其他小伙伴...  
13：我宣布，所有小伙伴写入数据完毕  
13：所有线程都写入数据完毕，继续干活...  
10：所有线程都写入数据完毕，继续干活...  
12：所有线程都写入数据完毕，继续干活...  
14：所有线程都写入数据完毕，继续干活...  
11：所有线程都写入数据完毕，继续干活...   

可以看到，线程小伙伴们非常团结，写完自己的数据之后都在等待其他小伙伴，所有小伙伴都完成之后才继续后续的动作。

### 重复使用
上面的例子并没有体现CyclicBarrier可以循环使用的特点，所以有如下代码：

```
package com.winwill.test;

import java.util.Random;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;

/**
 * @author qifuguang
 * @date 15/8/25 00:34
 */
public class TestCyclicBarrier {
    private static final int THREAD_NUMBER = 5;
    private static final Random RANDOM = new Random();

    public static void main(String[] args) throws Exception {
        CyclicBarrier barrier = new CyclicBarrier(THREAD_NUMBER, new Runnable() {
            public void run() {
                System.out.println(Thread.currentThread().getId() + "：我宣布，所有小伙伴写入数据完毕");
            }
        });
        for (int i = 0; i < THREAD_NUMBER; i++) {
            Thread t = new Thread(new Worker(barrier));
            t.start();
        }
        Thread.sleep(10000);
        System.out.println("================barrier重用==========================");
        for (int i = 0; i < THREAD_NUMBER; i++) {
            Thread t = new Thread(new Worker(barrier));
            t.start();
        }
    }

    static class Worker implements Runnable {
        private CyclicBarrier barrier;

        public Worker(CyclicBarrier barrier) {
            this.barrier = barrier;
        }

        public void run() {
            int time = RANDOM.nextInt(1000);
            System.out.println(Thread.currentThread().getId() + "：我需要" + time + "毫秒时间写入数据.");
            try {
                Thread.sleep(time);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：写入数据完毕，等待其他小伙伴...");
            try {
                barrier.await(); // 等待所有线程都调用过此函数才能进行后续动作
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (BrokenBarrierException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：所有线程都写入数据完毕，继续干活...");
        }
    }
}

```
运行结果：
>10：我需要228毫秒时间写入数据.  
11：我需要312毫秒时间写入数据.  
12：我需要521毫秒时间写入数据.  
13：我需要720毫秒时间写入数据.  
14：我需要377毫秒时间写入数据.  
10：写入数据完毕，等待其他小伙伴...  
11：写入数据完毕，等待其他小伙伴...  
14：写入数据完毕，等待其他小伙伴...  
12：写入数据完毕，等待其他小伙伴...  
13：写入数据完毕，等待其他小伙伴...  
13：我宣布，所有小伙伴写入数据完毕  
13：所有线程都写入数据完毕，继续干活...  
10：所有线程都写入数据完毕，继续干活...  
11：所有线程都写入数据完毕，继续干活...  
14：所有线程都写入数据完毕，继续干活...  
12：所有线程都写入数据完毕，继续干活...  
================barrier重用==========================  
15：我需要212毫秒时间写入数据.  
16：我需要691毫秒时间写入数据.  
17：我需要530毫秒时间写入数据.  
18：我需要758毫秒时间写入数据.  
19：我需要604毫秒时间写入数据.  
15：写入数据完毕，等待其他小伙伴...  
17：写入数据完毕，等待其他小伙伴...  
19：写入数据完毕，等待其他小伙伴...  
16：写入数据完毕，等待其他小伙伴...  
18：写入数据完毕，等待其他小伙伴...  
18：我宣布，所有小伙伴写入数据完毕  
18：所有线程都写入数据完毕，继续干活...  
15：所有线程都写入数据完毕，继续干活...  
19：所有线程都写入数据完毕，继续干活...  
16：所有线程都写入数据完毕，继续干活...  
17：所有线程都写入数据完毕，继续干活...  

可以看到，barrier的确是重用了。

### 等待超时
如果await的时候设置了一个最长等待时间，并且等待超时，则会怎么样呢？下面的例子故意让一个线程延迟一段时间才开始写数据，这样就会出现先等待的线程等待最后一个线程抛出等待超时异常的情况。

```
package com.winwill.test;

import java.util.Random;
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

/**
 * @author qifuguang
 * @date 15/8/25 00:34
 */
public class TestCyclicBarrier {
    private static final int THREAD_NUMBER = 5;
    private static final Random RANDOM = new Random();

    public static void main(String[] args) throws Exception {
        CyclicBarrier barrier = new CyclicBarrier(THREAD_NUMBER, new Runnable() {
            public void run() {
                System.out.println(Thread.currentThread().getId() + "：我宣布，所有小伙伴写入数据完毕");
            }
        });
        for (int i = 0; i < THREAD_NUMBER; i++) {
            if (i < THREAD_NUMBER - 1) {
                Thread t = new Thread(new Worker(barrier));
                t.start();
            } else {  //最后一个线程故意延迟3s创建。
                Thread.sleep(3000);
                Thread t = new Thread(new Worker(barrier));
                t.start();
            }
        }
    }

    static class Worker implements Runnable {
        private CyclicBarrier barrier;

        public Worker(CyclicBarrier barrier) {
            this.barrier = barrier;
        }

        public void run() {
            int time = RANDOM.nextInt(1000);
            System.out.println(Thread.currentThread().getId() + "：我需要" + time + "毫秒时间写入数据.");
            try {
                Thread.sleep(time);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：写入数据完毕，等待其他小伙伴...");
            try {
                barrier.await(2000, TimeUnit.MILLISECONDS); // 只等待2s，必然会等待最后一个线程超时
            } catch (InterruptedException e) {
                e.printStackTrace();
            } catch (BrokenBarrierException e) {
                e.printStackTrace();
            } catch (TimeoutException e) {
                e.printStackTrace();
            }
            System.out.println(Thread.currentThread().getId() + "：所有线程都写入数据完毕，继续干活...");
        }
    }
}

```
运行结果：
> 10：我需要820毫秒时间写入数据.  
11：我需要140毫秒时间写入数据.  
12：我需要640毫秒时间写入数据.  
13：我需要460毫秒时间写入数据.  
11：写入数据完毕，等待其他小伙伴...  
13：写入数据完毕，等待其他小伙伴...  
12：写入数据完毕，等待其他小伙伴...  
10：写入数据完毕，等待其他小伙伴...  
java.util.concurrent.BrokenBarrierException  
12：所有线程都写入数据完毕，继续干活...  
    at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:250)  
    at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)  
13：所有线程都写入数据完毕，继续干活...  
11：所有线程都写入数据完毕，继续干活...  
10：所有线程都写入数据完毕，继续干活...  
    at com.winwill.test.TestCyclicBarrier$Worker.run(TestCyclicBarrier.java:52)  
    at java.lang.Thread.run(Thread.java:744)  
java.util.concurrent.BrokenBarrierException  
    at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:250)  
    at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)  
    at com.winwill.test.TestCyclicBarrier$Worker.run(TestCyclicBarrier.java:52)  
    at java.lang.Thread.run(Thread.java:744)  
java.util.concurrent.TimeoutException  
    at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:257)  
    at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)  
    at com.winwill.test.TestCyclicBarrier$Worker.run(TestCyclicBarrier.java:52)  
    at java.lang.Thread.run(Thread.java:744)  
java.util.concurrent.BrokenBarrierException  
    at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:250)  
    at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)  
    at com.winwill.test.TestCyclicBarrier$Worker.run(TestCyclicBarrier.java:52)  
    at java.lang.Thread.run(Thread.java:744)  
14：我需要850毫秒时间写入数据.  
java.util.concurrent.BrokenBarrierException  
14：写入数据完毕，等待其他小伙伴...  
14：所有线程都写入数据完毕，继续干活...  
    at java.util.concurrent.CyclicBarrier.dowait(CyclicBarrier.java:207)  
    at java.util.concurrent.CyclicBarrier.await(CyclicBarrier.java:435)  
    at com.winwill.test.TestCyclicBarrier$Worker.run(TestCyclicBarrier.java:52)  
    at java.lang.Thread.run(Thread.java:744)  


可以看到，前面四个线程等待最后一个线程超时了，这个时候他们不再等待最后这个小伙伴了，而是抛出异常并都继续后续的动作。最后这个线程屁颠屁颠地完成写入数据操作之后也继续了后续的动作。需要说明的是，发生了超时异常时候，还没有完成“神秘任务”的线程在完成任务之后不会做任何等待，而是会直接执行后续的操作。

# 总结
CountDownLatch和CyclicBarrier都能够实现线程之间的等待，只不过它们侧重点不同：

* CountDownLatch一般用于某个线程A等待若干个其他线程执行完任务之后，它才执行；
* CyclicBarrier一般用于一组线程互相等待至某个状态，然后这一组线程再同时执行；
* CountDownLatch是不能够重用的，而CyclicBarrier是可以重用的。

# 注意事项
转载请注明出处：[http://fudawei.github.io/2015/08/25/[Java并发包学习五]CountDownLatch和CyclicBarrier介绍](http://fudawei.github.io/2015/08/25/[Java并发包学习五]CountDownLatch和CyclicBarrier介绍)
