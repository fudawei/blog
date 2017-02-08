title: Java锁类型
date: 2014-04-15 22:46:28
categories: [Java,Java基础]
tags: [Java,并发锁]
---
### 自旋锁
自旋锁适用于锁竞争不那么激烈的情况，和同步块比较小的情况，由于线程的阻塞和释放都是基于信号量（操作系统课本的汇编示例代码还记得不），并且
有用户态和内核态的频繁切换以及线程上下文切换开销比较大，对于前述的两种情况阻塞和释放竞争锁的线程显得没那么的必要，所以引入了自旋锁，但是
自旋锁也有不好的地方，ABA问题，单核无效（依赖环境），太依赖于当前线程的执行环境。
ABA 问题：在CAS操作中将判断“V的值是否仍然为A？”，并且如果是的话就继续执行更新操作。在大多数情况下，这种判断是足够的。然而，有时候还需要
知道 “自从上次看到V的值为A以来，这个值是否发生了变化？”在某些算法中，如果V值首先由A编程B,在由B编程A，那么仍然被认为发生了变化，并需要重新
执 行算法中的某些步骤。
解决方法： 使用原子工具类 AtomicStampedReference以 及AtomicMarkableReference支持在两个变量上执行原子的条件更新。AtomicStampedReference将
更新一个“对象 —-引用”二元组，通过在引用上加上“版本号”，从而避免ABA问题。
```
public class SpinLock {
    private AtomicReference<Thread> owner = new AtomicReference<>();

    public void lock(){
        Thread currentThread = Thread.currentThread();
        //循环cas来判断锁是否被占用，第一个为期望值，如果为null说明锁未被占用，设置当前线程占用
        while(owner.compareAndSet(null,currentThread)){
            //这里一般会调用java.util.concurrent.locks.AbstractOwnableSynchronizer的setExclusiveOwnerThread(Thread t)方法来设置独占锁
        }
    }

    public void unlock(){
        Thread currentThread = Thread.currentThread();

        owner.compareAndSet(currentThread,null);
    }
}
```
### 可重入锁
可重入锁，也叫做递归锁，指的是同一线程 外层函数获得锁之后 ，内层递归函数仍然有获取该锁的代码，但不受影响。
在JAVA环境下 ReentrantLock 和synchronized 都是 可重入锁
可重入锁最大的作用是避免死锁
Test1
```
public class Test implements Runnable{
	@Override
	public void run() {
		get();
	}
	public synchronized void get(){
		System.out.println(Thread.currentThread().getId());
		set();
	}
	public synchronized void set(){
		System.out.println(Thread.currentThread().getId());
	}
	public static void main(String[] args) {
		Test test = new Test();
		new Thread(test).start();
		new Thread(test).start();
		new Thread(test).start();
	}
}
```
Test2
```
public class Test implements Runnable{
	ReentrantLock lock = new ReentrantLock();
	@Override
	public void run() {
		get();
	}
	public void get(){
		lock.lock();
		System.out.println(Thread.currentThread().getId());
		set();
		lock.unlock();
	}
	public void set(){
		lock.lock();
		System.out.println(Thread.currentThread().getId());
		lock.unlock();
	}
	public static void main(String[] args) {
		Test test = new Test();
		new Thread(test).start();
		new Thread(test).start();
		new Thread(test).start();
	}
}
两次输出结果一样，即同一个线程id被连续输出两次
```
### 阻塞锁
能够进入\退出、阻塞状态或包含阻塞锁的方法有 ，synchronized 关键字，ReentrantLock，Object.wait()\notify(),LockSupport.park()/unpart()
阻塞锁的优势在于，阻塞的线程不会占用cpu时间， 不会导致 CPu占用率过高，但进入时间以及恢复时间都要比自旋锁略慢。
在竞争激烈的情况下 阻塞锁的性能要明显高于 自旋锁。
理想的情况则是; 在线程竞争不激烈的情况下，使用自旋锁，竞争激烈的情况下使用，阻塞锁。

### ThreadLocal 用法
```
static ThreadLocal<Long> TIME_THRE = new ThreadLocal<Long>(){
		protected Long initialValue() {
			return System.currentTimeMillis();
		};
	};
```



