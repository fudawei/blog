title: '[并发锁(二)]AQS阻塞队列'
tags: [Java,并发库]
categories: [Java,并发库]
date: 2017-02-14 20:07:52
---

## 自旋锁

我们知道一个线程在尝试获取锁失败后将被阻塞并加入等待队列中，它是一个怎样的队列？又是如何管理此队列？这节聊聊CHL Node FIFO队列。
 在谈到CHL Node FIFO队列之前，我们先分析这种队列的几个要素。首先要了解的是自旋锁，所谓自旋锁即是某一线程去尝试获取某个锁时，如果该锁已经被其他线程占用的话，此线程将不断循环检查该锁是否被释放，而不是让此线程挂起或睡眠。它属于为了保证共享资源而提出的一种锁机制，与互斥锁类似，保证了公共资源在任意时刻最多只能由一条线程获取使用，不同的是互斥锁在获取锁失败后将进入睡眠或阻塞状态。下面利用代码实现一个简单的自旋锁，

```
public class SpinLock {
	private static Unsafe unsafe = null;
	private static final long valueOffset;
	private volatile int value = 0;

	static {
		try {
			unsafe=getUnsafeInstance();
			valueOffset = unsafe.objectFieldOffset(SpinLock.class.getDeclaredField("value"));
		} catch (Exception ex) {
			throw new Error(ex);
		}
	}

	private static Unsafe getUnsafeInstance() throws SecurityException,NoSuchFieldException,IllegalArgumentException,IllegalAccessException {
		Field theUnsafeInstance = Unsafe.class.getDeclaredField("theUnsafe");
		theUnsafeInstance.setAccessible(true);
		return (Unsafe) theUnsafeInstance.get(Unsafe.class);
	}

	public void lock() {
		for (;;) {
            int newV = value + 1;
            if(newV==1)
                if (unsafe.compareAndSwapInt(this, valueOffset, 0, newV)){
                	return ;
                }
        	}
		}
	}

    public void unlock() {
		unsafe.compareAndSwapInt(this, valueOffset, 1, 0);
	}
}

```

这是一个很简单的自旋锁，主要看加粗加红的两个方法lock和unlock，Unsafe仅仅是为操作提供了硬件级别的原子CAS操作，暂时忽略此类，只要知道它的作用即可，我们将在后面的“原子性如何保证”小节中对此进行更加深入的阐述。对于lock方法，假如有若干线程竞争，能成功通过CAS操作修改value值为newV的线程即是成功获取锁的线程，将直接通过，而其他的线程则不断在循环检测value值是否又改回0，而将value改为0的操作就是获取锁的线程执行完后对该锁进行释放，通过unlock方法释放锁，释放后若干线程又对该锁竞争。如此一来，没获取的锁也不会被挂起或阻塞，而是不断循环检查状态。图2-5-9-3可加深自旋锁的理解，五条线程轮询value变量，t1获取成功后将value置为1，此状态时其他线程无法竞争锁，t1使用完锁后将value置为0，剩下的线程继续竞争锁，以此类推。这样就保证了某个区域块的线程安全性。

![](/img/sy/sy-1.jpg)
自旋锁

> 自旋锁缺点
> 自旋锁适用于锁占用时间短，即锁保护临界区很小的情景，同时它需要硬件级别操作，也要保证各缓存数据的一致性，另外，无法保证公平性，不保证先到先获得，可能造成线程饥饿。在多处理器机器上，每个线程对应的处理器都对同一个变量进行读写，而每次读写操作都将要同步每个处理器缓存，导致系统性能严重下降。


### 自旋锁优化
看Craig, Landin, and Hagersten发明的CLH锁如何优化同步带来的花销，其核心思想是：通过一定手段将所有线程对某一共享变量轮询竞争转化为一个线程队列且队列中的线程各自轮询自己的本地变量。这个转化过程由两个要点，一是构建怎样的队列&如何构建队列，为了保证公平性，构建的将是一个FIFO队列，构建的时候主要通过移动尾部节点tail实现队列的排队，每个想获取锁的线程创建一个新节点并通过CAS原子操作将新节点赋予tail，然后让当前线程轮询前一节点的某个状态位，如图2-5-9-3，如此就成功构建线程排队队列；二是如何释放队列，执行完线程后只需将当前线程对应的节点状态位置为解锁状态，由于下一节点一直在轮询，可获取到锁

![](/img/sy/sy-2.jpg)

CLH锁的核心思想貌似是将众多线程长时间对某资源的竞争，通过有序化这些线程转化为只需对本地变量检测。唯一存在竞争的地方就是在入队列之前对尾节点tail的竞争，但竞争的线程的数量已经少了很多，且比起所有线程直接对某资源竞争的轮询次数也减少了很多，节省了很多CPU缓存同步操作，大大提升系统性能，利用空间换取性能。下面提供一个简单的CLH锁实现代码，lock与unlock两方法提供加锁解锁操作，每次加锁解锁必须将一个CLHNode对象作为参数传入，lock方法的for循环是通过CAS操作将新节点插入队列，而while循环则是检测前驱节点的锁状态位，一旦前驱节点锁状态位允许则结束检测让线程往下执行。解锁操作先判断当前节点是否为尾节点，如是则直接将尾节点置为空，此时说名仅仅只有一条线程在执行，否则将当前节点的锁状态位置为解锁状态。

```
public class CLHLock {

	private static Unsafe unsafe = null;
	private static final long valueOffset;
	private volatile CLHNode tail;
	public class CLHNode {
		private boolean isLocked = true;
	}

	static {
		try {
			unsafe = getUnsafeInstance();
     		valueOffset = unsafe.objectFieldOffset(CLHLock.class.getDeclaredField("tail"));
		} catch (Exception ex) {
			throw new Error(ex);
		}
	}

	public void lock(CLHNode currentThreadNode) {
		CLHNode preNode = null;
		for (;;) {
			preNode = tail;
			if (unsafe.compareAndSwapObject(this, valueOffset, tail,currentThreadNode))
				break;
			}
			if (preNode != null)
				while (preNode.isLocked) {
				}
			}

		}

	public void unlock(CLHNode currentThreadNode) {
  		if (!unsafe.compareAndSwapObject(this, valueOffset, currentThreadNode,null))
   			currentThreadNode.isLocked = false;
		}

	private static Unsafe getUnsafeInstance() throws SecurityException,
							NoSuchFieldException, IllegalArgumentException,IllegalAccessException {
		Field theUnsafeInstance = Unsafe.class.getDeclaredField("theUnsafe");
		theUnsafeInstance.setAccessible(true);
		return (Unsafe) theUnsafeInstance.get(Unsafe.class);
	}
}
```
### CLH锁改造

在CLH锁核心思想的影响下，Java并发包的基础框架AQS以CLH锁作为基础而设计，其中主要是考虑到CLH锁更容易实现取消与超时功能。比起原来的CLH锁已经做了很大的改造，主要从两方面进行了改造：节点的结构与节点等待机制。在结构上引入了头结点和尾节点，他们分别指向队列的头和尾，尝试获取锁、入队列、释放锁等实现都与头尾节点相关，并且每个节点都引入前驱节点和后后续节点的引用；在等待机制上由原来的自旋改成阻塞唤醒。如图2-5-9-4，通过前驱后续节点的引用一节节连接起来形成一个链表队列，对于头尾节点的更新必须是原子的。下面详细看看入队、检测挂起、释放出队、超时、取消等操作。

![](/img/sy/sy-3.jpg)

1. 入队，整块逻辑其实是用一个无限循环进行CAS操作，即用自旋方式竞争直到成功。将尾节点tail的旧值赋予新节点node的前驱节点，并尝试CAS操作将新节点node赋予尾节点tail，原先的尾节点的后续节点指向新建节点node。完成上面步骤就建立起一条如图2-5-9-4所示的链表队列。代码简化如下：
```
for (;;) {
   Node t = tail;
   node.prev = t;
   if (compareAndSetTail(t, node)) {
      t.next = node;
      return node;
   }
}
```
2.  检测挂起，上面我们说到节点等待机制已经被AQS作者由自旋机制改造成阻塞机制，一个新建的节点完成入队操作后，如果是自旋则直接进入循环检测前驱节点是否为头结点即可，但现在被改为阻塞机制，当前线程将首先检测是否为头结点且尝试获取锁，如果当前节点为头结点并成功获取锁则直接返回，当前线程不进入阻塞，否则将当前线程阻塞。代码简化如下：
```
 for (;;) {
    if (node.prev == head)
	if(尝试获取锁成功){
         head=node;
         node.next=null;
         return;
     }
   阻塞线程
}
```
3.  释放出队，出队的主要工作是负责唤醒等待队列中后续节点，让所有等待节点环环相接，每条线程有序地往下执行。代码简化如下：
Node s = node.next;
唤醒节点s包含的线程

4.  超时，在支持超时的模式下需要LockSupport类的parkNanos方法支持，线程在阻塞一段时间后会自动唤醒，每次循环将累加消耗时间，当总消耗时间大于等于自定义的超时时间时就直接分返。代码简化如下：
```
for (;;) {
   尝试获取锁
   if (nanosTimeout <= 总消耗时间)
      return;
   LockSupport.parkNanos(this, nanosTimeout);
 }
```
5.  取消，队列中等待锁的队列可能因为中断或超时而涉及到取消操作，这种情况下被取消的节点不再进行锁竞争。此过程主要完成的工作是将取消的节点移除，先将节点的。先将节点node状态设置成取消，再将前驱节点pred的后续节点指向node的后续节点，这里由于涉及到竞争，必须通过CAS进行操作，CAS操作就算失败也不必理会，因为已经改了节点的状态，在尝试获取锁操作中会循环对节点的状态判断。
```
node.waitStatus = Node.CANCELLED;
Node pred = node.prev;
Node predNext = pred.next;
Node next = node.next;
compareAndSetNext(pred, predNext, next);
```

### 公平性

所谓公平性指所有线程对临界资源申请访问权限的成功率都一样，不会让某些线程拥有优先权。通过前面的CLH Node FIFO学习知道了等待队列是一个先进先出的队列，那么是否就可以说每条线程获取锁时就是公平的呢？关于公平性这里分拆成三个点分别阐述：
1. 准备入队列的节点，此情况讨论的是线程加入等待队列时产生的竞争是否公平，线程在尝试获取锁失败后将被加入等待队列，这时多个线程通过自旋将节点加入队列，所有线程在自旋过程中是无法保证其公平性的，可能后来的线程比早到的先进入队列，所以节点入队列不具公平性。

3. 等待队列中的节点，情况①中成功加入队列后即成为等待队列中的节点，我们知道此队列是一个先入先出队列，那么很简单能得到，队列中的所有节点是公平的，他们都按照顺序等待自己被前驱节点唤醒并获取锁，所以等待队列中的节点具有公平性。

5. 闯入的节点，这种情况是指一个新线程到达共享资源边界时不管等待队列中是否存在其他等待节点它都将优先尝试去获取锁，这种称为可闯入策略。可闯入特性破坏了公平性，AQS框架对外体现的公平性主要由此体现，下面将对闯入特性展开分析。

AQS提供的基础获取锁算法是一种可闯入的算法，即如果有新线程到来先进行一次获取尝试，不成功的情况下才将当前线程加入等待队列。如图2-5-9-6所示，等待队列中节点线程按照顺序一个接一个尝试去获取共享资源的使用权，某时刻头结点线程准备尝试获取的同时另外一条线程闯入，此线程并非直接加入等待队列的尾部，而是先跟头结点线程竞争获取资源，闯入线程如果成功获取共享资源则直接执行，头结点线程则继续等待下一次尝试，如此一来闯入线程成功插队，后来的线程比早到的线程先执行，说明AQS基础获取算法是不严格公平的。

![](/img/sy/sy-4.png)

基础获取算法逻辑简化如下：首先尝试获取锁，假如获取失败才创建节点并加入到等待队列的尾部，接着通过不断循环检查是否轮到自己执行，当然此过程为了提高性能可能将线程先挂起，最终由前驱节点唤醒。

```
if (尝试获取锁失败) {
    创建node
    使用CAS方式把node插入到队列尾部
    while(true){
    if(尝试获取锁成功 并且 node的前驱节点为头节点){
	把当前节点设置为头节点
    跳出循环
} else {
    使用CAS方式修改node前驱节点的waitStatus标识为signal
    if(修改成功)
        挂起当前线程
	}
}
```

为什么要使用闯入策略？可闯入的策略通常可以提供更高的总吞吐量。由于一般同步器颗粒度比较小，也可以说共享资源的范围较小，而线程从阻塞状态到被唤醒所消耗的时间周期可能是通过共享资源时间周期的几倍甚至几十倍，如此一来线程唤醒过程中将存在一个很大的时间周期空窗期，导致资源没有得到充分利用，为了提高吞吐量，引入这种闯入策略，它可以使在等待队列头结点从阻塞到被唤醒的时间段内闯入的线程直接获取锁并通过同步器，以便充分利用唤醒过程这一空窗期，大大增加了吞吐率。另外，闯入机制的实现对外提供一种竞争调节机制，即开发者可以在自定义同步器中定义闯入尝试获取的次数，假设次数为n则不断重复获取直到n次都获取不成功才把线程加入等待队列中，随着次数n的增加可以增大成功闯入的几率。同时，这种闯入策略可能导致等待队列中的线程饥饿，因为锁可能一直被闯入的线程获取，但由于一般持有同步器的时间很短暂而避免饥饿的发生，反之如果保护的代码体很长并且持有同步器的时间较长，这将大大增加等待队列无限等待的风险。


在实际情况中还是要根据用户需求制定策略，在一个公平性要求很高的场景，则可以把闯入策略去除掉以达到公平。在自定义同步器中可以通过AQS预留方法tryAcquire方法实现，只需判断当前线程是否为等待队列中头结点对应的线程，若不是则直接返回false，尝试获取失败。但前面这种公平性是相对Java语法语义层面上的公平性，在现实中JVM的实现会直接影响线程执行的顺序。


### AQS超时机制

AQS框架提供的另外一个优秀机制是锁获取超时的支持，当大量线程对某一锁竞争时可能导致某些线程在很长一段时间都获取不了锁，在某些场景下可能希望如果线程在一段时间内不能成功获取锁就取消对该锁的等待以提高性能，这时就需要用到超时机制。在JDK1.5之前还没有juc工具，当时的并发控制职能通过JVM内置的synchronized关键词实现锁，但对一些特殊要求却力不从心，例如超时取消控制。JDK1.5开始引入juc工具完美解决了此问题，而这正得益于并发基础框架AQS提供了超时的支持。

为了更精确地保证时间间隔统计的准确性，实现时使用了System.nanoTime()更为精确的方法，它能精确到纳秒级别。超时机制的思想就是在不断进行锁竞争的同时记录竞争的时间，一旦时间段超过指定的时间则停止轮询直接返回，返回前对等待队列中对应节点进行取消操作。往下看实现的逻辑，

```
if(尝试获取锁失败) {
long lastTime = System.nanoTime();
    创建node
    使用CAS方式把node插入到队列尾部
    while(true){
    if(尝试获取锁成功 并且 node的前驱节点为头节点){
	把当前节点设置为头节点
    跳出循环
} else {
    if (nanosTimeout <= 0){
	取消等待队列中此节点
	跳出循环
}
    使用CAS方式修改node前驱节点的waitStatus标识为signal
    if(修改成功)
        if(nanosTimeout > spinForTimeoutThreshold)
        阻塞当前线程nanosTimeout纳秒
   		long now = System.nanoTime();
    	nanosTimeout -= now - lastTime;
    	lastTime = now;
	}
}
```

上面正是在前面章节锁的获取逻辑中添加超时处理，核心逻辑是不断循环减去处理的时间消耗，一旦小于0就取消节点并跳出循环，其中有两点必须要注意，一个是真正的阻塞时间应该是扣除了竞争入队的时间后剩余的时间，保证阻塞事件的准确性，我们可以看到每次循环都会减去相应的处理时间；另外一个是关于spinForTimeoutThreshold变量阀值，它是决定使用自旋方式消耗时间还是使用系统阻塞方式消耗时间的分割线，juc工具包作者通过测试将默认值设置为1000ns，即如果在成功插入等待队列后剩余时间大于1000ns则调用系统底层阻塞，否则不调用系统底层，取而代之的是仅仅让之在Java应用层不断循环消耗时间，属于优化的措施。

### 同步状态的管理

整个AQS框架核心功能都是围绕着其32位整型属性state进行，一般可以说它表示锁的数量，对同步状态的控制可以实现不同的同步工具，例如闭锁、信号量、栅栏等等。为了保证可见性此变量被声明为volatile，保证每次的原子更新都将及时反映到每条线程上。而对于同步状态的管理可以大体分为两块，一是独占模式的管理，另外是共享模式的管理。通过对这两种模式的灵活变换可以实现多种不同的同步器，如下图，对state的控制可以看成一个管道，管道的大小决定了同时通过的线程，独占模式好比宽度只容许一个线程通过的管道，在这种模式下线程只能逐一通过管道，任意时刻管内只能存在一条线程，这便形成了互斥效果。而共享模式就是管道宽度大于1的管道，可以同时让n条管道通过，吞吐量增加但可能存在共享数据一致性问题。（注意：两种模式的讨论忽略了队列的管理逻辑，实际上CLH Node的引入是为了优化竞争带来的性能问题，不影响同步状态管理的探讨）

![](/img/sy/sy-4.png)
图5 独占模式与共享模式

如何通过state实现独占模式和共享模式？在此之前先了解AQS框架中相关的getState、setState、compareAndSetState三个操作state的基本方法，前两个方法是普通的获取设置方法，其必须保证不存在数据竞争的情况下使用，compareAndSetState方法则提供了CAS方式的硬件级别的原子更新。两种模式就是通过这些方法对state操作实现不同同步模式，下面给出最简单的实现。

 独占模式
```
public boolean tryAcquire(int acquires) {
	if (compareAndSetState(0, 1)) {
		return true;
	}
	return false;
}

protected boolean tryRelease(int releases) {
	setState(0);
	return true;
}
```
多条线程通过tryAcquire尝试把state变量改为1，由于CAS算法的保证，最终有且仅有一条线程成功修改state，修改成功的线程代表获取锁成功，将拥有往下执行的权利，进入管道。当执行完毕退出管道时执行tryRelease尝试把state变量改为0，让出管道，此处由于不存在线程竞争所以可直接使用setState，接着其他未通过的线程继续重复尝试

 共享模式
```
public int tryAcquireShared(int interval) {
	for (;;) {
		int current = getState();
		int newCount = current - 1;
		if (newCount < 0 || compareAndSetState(current, newCount)) {
			return newCount;
		}
	}
}

public boolean tryReleaseShared(int interval) {
	for (;;) {
		int current = getState();
		int newCount = current + 1;
		if (compareAndSetState(current, newCount)) {
			return true;
		}
	}
}
```

与独占模式不同的是对state的管理及判断条件，独占模式state的值只能为0或1，而共享模式的state是可以被出事换成任意整数，一般初始值表示提供一个同时n条线程通过的管道宽度，这样一来，多条线程通过tryAcquireShared尝试将state的值减去1，成功修改state后就返回新值，只有当新值大于等于0才表示获取锁成功，拥有往下执行的权利，进入管道。在执行完毕时线程将调用tryReleaseShared尝试修改state值使之增加1，表示我已经执行完了并让出管道的通道供后面线程使用，需要说明的是与独占模式不同，由于可能存在多条线程并发释放锁，所以此处必须使用基于CAS算法的修改方法，修改成功后其他线程便可继续竞争锁。

ASQ框架提供了对同步状态state的基本操作，了解了两种模式对state操作开发者可能很自由地自定义自己的同步器。实际中AQS框架在提供state状态管理接口的同时也将维护等待队列的工作，两项工作被封装成一个模板，规定了工作流程，工作流程包括什么条件下加入等待队列、什么条件移除等待节点、如何操作等待队列、需不需要阻塞、支不支持中断等等，对外仅仅提供state状态操作接口供开发者自定义，而队列的维护工作已经绑定在模板中，无需你自己动手。
