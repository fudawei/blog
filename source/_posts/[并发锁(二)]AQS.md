title: '[并发锁(二)]AQS'
tags: [Java,并发库]
categories: [Java,并发库]
date: 2017-02-04 20:07:52
---

AQS


首先从理论知识开始，在了解了相关原理后会针对源码进行一些分析，最后加上一些实战来描述。

![](/img/lock/lock-1.png)

上面的继承体系中，AbstractQueuedSynchronizer是CountDownLatch/FutureTask/ReentrantLock/RenntrantReadWriteLock/Semaphore的基础，因此AbstractQueuedSynchronizer是Lock/Executor实现的前提。公平锁、不公平锁、Condition、CountDownLatch、Semaphore等放到后面的篇幅中说明。

完整的设计原理可以参考Doug Lea的论文  [The java .util .concurrent Synchronizer Framework](http://gee.cs.oswego.edu/dl/papers/aqs.pdf)   ，这里做一些简要的分析。

基本的思想是表现为一个同步器，支持下面两个操作：

获取锁：首先判断当前状态是否允许获取锁，如果是就获取锁，否则就阻塞操作或者获取失败，也就是说如果是独占锁就可能阻塞，如果是共享锁就可能失败。另外如果是阻塞线程，那么线程就需要进入阻塞队列。当状态位允许获取锁时就修改状态，并且如果进了队列就从队列中移除。

```
while(synchronization state does not allow acquire){
    enqueue current thread if not already queued;
    possibly block current thread;
}
```

dequeue current thread if it was queued;

释放锁:这个过程就是修改状态位，如果有线程因为状态位阻塞的话就唤醒队列中的一个或者更多线程。
```

update synchronization state;

if(state may permit a blocked thread to acquire)

    unlock one or more queued threads;
```

要支持上面两个操作就必须有下面的条件：

原子性操作同步器的状态位
阻塞和唤醒线程
一个有序的队列
目标明确，要解决的问题也清晰了，那么剩下的就是解决上面三个问题。

状态位的原子操作

这里使用一个32位的整数来描述状态位，前面章节的原子操作的理论知识整好派上用场，在这里依然使用CAS操作来解决这个问题。事实上这里还有一个64位版本的同步器（AbstractQueuedLongSynchronizer），这里暂且不谈。

阻塞和唤醒线程

标准的Java API里面是无法挂起（阻塞）一个线程，然后在将来某个时刻再唤醒它的。JDK 1.0的API里面有Thread.suspend和Thread.resume，并且一直延续了下来。但是这些都是过时的API，而且也是不推荐的做法。

在JDK 5.0以后利用JNI在LockSupport类中实现了此特性。

```
LockSupport.park()
LockSupport.park(Object)
LockSupport.parkNanos(Object, long)
LockSupport.parkNanos(long)
LockSupport.parkUntil(Object, long)
LockSupport.parkUntil(long)
LockSupport.unpark(Thread)
```

上面的API中park()是在当前线程中调用，导致线程阻塞，带参数的Object是挂起的对象，这样监视的时候就能够知道此线程是因为什么资源而阻塞的。由于park()立即返回，所以通常情况下需要在循环中去检测竞争资源来决定是否进行下一次阻塞。park()返回的原因有三：

其他某个线程调用将当前线程作为目标调用  unpark ；
其他某个线程中断 当前线程；
该调用不合逻辑地（即毫无理由地）返回。
其实第三条就决定了需要循环检测了，类似于通常写的while(checkCondition()){Thread.sleep(time);}类似的功能。

有序队列

在AQS中采用CHL列表来解决有序的队列的问题。

  ![](/img/lock/lock-2.png)


AQS采用的CHL模型采用下面的算法完成FIFO的入队列和出队列过程。

对于入队列(enqueue)： 采用CAS操作，每次比较尾结点是否一致，然后插入的到尾结点中。

```
do {
   pred = tail;
} while ( !compareAndSet(pred,tail,node) );
```

对于出队列(dequeue ):由于每一个节点也缓存了一个状态，决定是否出队列，因此当不满足条件时就需要自旋等待，一旦满足条件就将头结点设置为下一个节点。

```
while (pred.status != RELEASED) ;

head  = node;
```

实际上这里自旋等待也是使用LockSupport.park()来实现的。

AQS里面有三个核心字段：

```
private volatile int state;

private transient volatile Node head;

private transient volatile Node tail;
```

其中state描述的有多少个线程取得了锁，对于互斥锁来说state<=1。head/tail加上CAS操作就构成了一个CHL的FIFO队列。下面是Node节点的属性。

volatile int waitStatus;   节点的等待状态，一个节点可能位于以下几种状态：

CANCELLED = 1： 节点操作因为超时或者对应的线程被interrupt。节点不应该不留在此状态，一旦达到此状态将从CHL队列中踢出。
SIGNAL = -1： 节点的继任节点是（或者将要成为）BLOCKED状态（例如通过LockSupport.park()操作），因此一个节点一旦被释放（解锁）或者取消就需要唤醒（LockSupport.unpack()）它的继任节点。
CONDITION = -2：表明节点对应的线程因为不满足一个条件（Condition）而被阻塞。
0： 正常状态，新生的非CONDITION节点都是此状态。
非负值标识节点不需要被通知（唤醒）。
volatile Node prev; 此节点的前一个节点。节点的waitStatus依赖于前一个节点的状态。

volatile Node next; 此节点的后一个节点。后一个节点是否被唤醒（uppark()）依赖于当前节点是否被释放。

volatile Thread thread; 节点绑定的线程。

Node nextWaiter; 下一个等待条件（Condition）的节点，由于Condition是独占模式，因此这里有一个简单的队列来描述Condition上的线程节点。


AQS 在J.U.C里面是一个非常核心的工具，而且也非常复杂，里面考虑到了非常多的逻辑实现，所以在后面的章节中总是不断的尝试介绍AQS的特性和实现。

这一个小节主要介绍了一些理论背景和相关的数据结构，在下一个小节中将根据以上知识来了解Lock.lock/unlock是如何实现的。

 


