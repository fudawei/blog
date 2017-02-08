title: "[Java锁学习三]锁在应用层的优化思路"
tags: [Java,内置锁]
categories: [Java,内置锁]
date: 2014-08-01 09:39:57
---
## 减少锁持有时间
如下面的代码：
```
public synchronized void test() {
        executeMethod1();
        multiThreadExecute();
        executeMethod2();
    }
```
<!--more-->
如果真正存在资源的竞争，需要加锁的函数是multiThreadExecute(),其他两个函数executeMethod1和executeMethod2都没有资源的竞争时，这样写只会增加线程持有锁的时间，就会导致其他线程等待这个锁的时间增长，影响性能。这种情况下，应该修改为：
```
    public void test() {
        executeMethod1();
        synchronized (this) {
            MultiThreadExecute();
        }
        executeMethod2();
    }
```

## 减小锁粒度
这个思路最典型的例子就是JDK中的重要成员ConcurrentHashMap，ConcurrentHashMap将整个区间分成若干个Segment（默认是16个），每一个Segment都是一个子map，每个Segment都拥有自己的一把锁。当需要向map中插入数据时，并不是先申请所有的锁，而是根据需要插入的数据的key的hashcode计算出应该从插入到哪一个Segment，然后再申请这个Segment的锁。所以理想情况下，ConcurrentHashMap最多可能有16个线程真正同时插入数据。

但是较小锁粒度会有一个问题：如果需要访问全局数据（这时需要取得全局锁），消耗的资源会比较多。以ConcurrentHashMap为例，put操作使用分段锁提高了并发，但是size()函数却没那么幸运，size函数返回map中所有有效的元素个数，所以需要访问所有数据，也就需要取得所有的锁，损耗的性能是比较多的。

## 锁分离
同样以JDK中的重要成员LinkedBlockingQueue为例，take()和put()函数分别从队列中取得数据和向队列中添加元素。因为LinkedBlockingQueue是链表实现的，take和put操作分别在队头和队尾操作，互不影响，所以这两个操作就不应该公用一把锁。下面是jdk中LinkedBlockingQueue的代码的一部分：
```
    /**
     * Tail of linked list.
     * Invariant: last.next == null
     */
    private transient Node<E> last;

    /** Lock held by take, poll, etc */
    private final ReentrantLock takeLock = new ReentrantLock();

    /** Wait queue for waiting takes */
    private final Condition notEmpty = takeLock.newCondition();

    /** Lock held by put, offer, etc */
    private final ReentrantLock putLock = new ReentrantLock();

    /** Wait queue for waiting puts */
    private final Condition notFull = putLock.newCondition();
```
可以看到分别定义了takeLock和putLock，这两个操作不适用同一把锁，削弱了锁竞争的可能性，提高了性能。

## 锁粗化
所谓的锁粗化就是如果代码中有连续的对同一把锁的申请操作，则需要考虑将这些锁操作合并为一个。比如：
```
    public void test() {
        synchronized (this) {
            // do sth
        }
        synchronized (this) {
            // do sth
        }
    }
```
这样的代码应该合并为：
```
    public void test() {
        synchronized (this) {
            // do sth
        }
    }
```
锁粗化的思想和减少锁持有时间是相反的，但是在不同的场合下，他们的效果并不相同，需要我们权衡利弊再做决策。

