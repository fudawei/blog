title: JDK并发工具类
date: 2016-04-12 21:44:27
categories: [Java,并发库]
tags: [Java,并发库]
---

### Fork/Join 框架测试
```
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.ForkJoinTask;
import java.util.concurrent.RecursiveTask;
/**
 * Fork/Join框架测试
 * @flyzyc
 */
public class ForkTest extends RecursiveTask<Integer>{
	public static int THRESHOLD = 2;
	public int start;
	public int end;
	public ForkTest(int start,int end){
		this.start = start;
		this.end = end;
	}
	@Override
	protected Integer compute() {
		int sum = 0;
		if(end-start <= THRESHOLD){
			for(int i=start;i<=end;i++){
				sum +=i;
			}
		}else{
			int middle = (start+end)/2;
			ForkTest leftTask = new ForkTest(start, middle);
			ForkTest rightTask = new ForkTest(middle+1,end);
			leftTask.fork();
			rightTask.fork();
			int leftResult = leftTask.join();
			int rightResult = rightTask.join();
			sum = leftResult + rightResult;
		}
		return sum;
	}
	public static void main(String[] args) {

		ForkJoinPool forkJoinPool = new ForkJoinPool();
		ForkTest task = new ForkTest(1, 100);
		ForkJoinTask<Integer> result = forkJoinPool.submit(task);
		try {
			System.out.println(result.get());
		} catch (InterruptedException | ExecutionException e) {
			e.printStackTrace();
		}
	}
}

```
### CountDownLatch 使用
#### 不使用 CountDownLatch实现
```
public class CDTest {
	public static void main(String[] args) throws InterruptedException {
		Thread t1 = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println("parse 1 finished!");
			}
		});
		Thread t2 = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println("parse 2 finished!");
			}
		});
		t1.start();
		t2.start();
		// join用于让当前线程等待join线程执行结束
		t1.join();
		t2.join();
		System.out.println("all parse finished!");
	}
}
```
#### 使用 CountDownLatch实现
```
public class CountDownTest {
	static CountDownLatch c = new CountDownLatch(2);
	public static void main(String[] args) throws InterruptedException {
		Thread t1 = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println("parse 1 finished!");
				c.countDown();
			}
		});
		Thread t2 = new Thread(new Runnable() {
			@Override
			public void run() {
				System.out.println("parse 2 finished!");
				c.countDown();
			}
		});
		t1.start();
		t2.start();
		// await方法会阻塞当前线程，直到N变为0.
		// countDown可以用在任何地方，可以是N个线程，也可以是1个线程里的N个执行步骤。
		c.await();  // 也可以指定等待时间  --- await(long time,TimeUnit unit)
		System.out.println("finished!");
	}
}
```
### CyclicBarrier 使用
#### CyclicBarrierTest1
```
public class CYclicBarrierTest_1 {
	/*
	 *  屏障拦截的线程数量，直到最后一个线程到达屏障时，屏障才会开门，所有被屏障拦截的线程才会继续运行
	 *
	 */
	static CyclicBarrier c = new CyclicBarrier(2);
	public static void main(String[] args) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					c.await();
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (BrokenBarrierException e) {
					e.printStackTrace();
				}
				System.out.println(1);
			}
		}).start();

		try {
			c.await();
		} catch (Exception e) {
		}
		System.out.println(2);
	}
}

```
#### CyclicBarrierTest2
```
import java.util.concurrent.BrokenBarrierException;
import java.util.concurrent.CyclicBarrier;
/**
 * CyclicBarrier还提供了一个更高级的构造函数CyclicBarrier(int parties,Runnable barrier-Action)
 * 用于在线程到达屏障时，优先执行barrierAction,，方便处理更复杂的业务场景
 * eg: 先输出3，再输出1,2，或者2,1。
 * @flyzyc
 */
public class CyclicBarrierTest_2 {
	static CyclicBarrier c = new CyclicBarrier(2,new A());
	public static void main(String[] args) {
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					c.await();
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (BrokenBarrierException e) {
					e.printStackTrace();
				}
				System.out.println(1);
			}
		}).start();

		try {
			c.await();
		} catch (Exception e) {
		}
		System.out.println(2);

	}
}
class A implements Runnable{

	@Override
	public void run() {
		System.out.println(3);
	}

}

```
#### CyclicBarrierTest3
```
public class CyclicBarrierTest_3 {
	static CyclicBarrier c =new CyclicBarrier(2);
	public static void main(String[] args) {

		Thread t = new Thread(new Runnable() {

			@Override
			public void run() {
				try {
					c.await();
				} catch (Exception e) {
				}
			}
		});
		t.start();
		t.interrupt();
		try {
			c.await();
		} catch (Exception e) {
			e.printStackTrace();
			// 此时发生BrokenBarrierException 异常执行该代码
			System.out.println("Exception"+c.isBroken());
		}
	}
}
```

#### CyclicBarrier的应用场景
例如用一个Excel保存了用户所有银行流水，每一个sheet保存一个账号近一年的银行流水，现在需要统计用户的日均银行流水。先用多线程处理每个sheet里的银行流水，都执行完之后，得到每个sheet的日均银行流水，最后再用barrierAction用这些线程的计算结果，计算出整个Excel的日均银行流水。
```
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
/**
 * 使用线程池创建4个线程，分别计算每个sheet里面的数据，每个sheet计算结果是1，
 * 再由BankWaterService汇总4个sheet计算出的结果
 */
public class BankWaterService implements Runnable {
	private CyclicBarrier c = new CyclicBarrier(4, this);
	private Executor executor = Executors.newFixedThreadPool(4);
	private ConcurrentHashMap<String, Integer> sheetBankWaterCount = new ConcurrentHashMap<String, Integer>();
	private void count(){
		for(int i=0;i<4;i++){
			executor.execute(new Runnable() {
				@Override
				public void run() {
					sheetBankWaterCount.put(Thread.currentThread().getName(), 1);
					try {
						c.await();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			});
		}
	}
	@Override
	public void run() {
		int result = 0;
		for(Entry<String,Integer> sheet:sheetBankWaterCount.entrySet()){
			result += sheet.getValue();
		}
		sheetBankWaterCount.put("result", result);
		System.out.println(result);
	}

	public static void main(String[] args) {

		BankWaterService bankWaterService = new BankWaterService();
		bankWaterService.count();

	}
}

```
#### CyclicBarrier和CountDownLatch的区别
 - CountDownLatch 的计数器只能使用一次，而CyclicBarrier的计数器可以使用reset方法重置，所以CyclicBarrier可以处理更为复杂的业务场景，例如，如果计算发生错误，可以重置计数器，并让线程重新执行一次。
 - CyclicBarrier 还提供其他有用的方法，比如getNumberWaiting方法可以获得CyclicBarrier阻塞的线程数量。isBroken()方法用来了解阻塞的线程是否被中断。
```
public class CyclicBarrierTest_3 {
	static CyclicBarrier c =new CyclicBarrier(2);
	public static void main(String[] args) {

		Thread t = new Thread(new Runnable() {

			@Override
			public void run() {
				try {
					c.await();
				} catch (Exception e) {
				}
			}
		});
		t.start();
		t.interrupt();
		try {
			c.await();
			System.out.println(c.isBroken());
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Exception"+c.isBroken());
		}
	}
}

```
### Semaphore 用法
```
public class SemaphoreTest {
	private static final int THREAD_COUNT = 30;
	static ExecutorService threadPool = Executors.newFixedThreadPool(THREAD_COUNT);
	private static Semaphore s = new Semaphore(10);
	public static void main(String[] args) {
		for(int i=0;i<THREAD_COUNT;i++){
			threadPool.execute(new Runnable() {
				@Override
				public void run() {
					try {
						s.acquire();
						Thread.sleep(1000);
						System.out.println(Thread.currentThread().getName()+" Save Data");
						s.release();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
			});
		}
		threadPool.shutdown();
	}
}
```
Semaphore 还有一些其他方法：
 - public int availablePermits() 返回此信号量中当前可用的许可数
 - public final int getQueueLength()  返回正在等待获取许可证的线程数
 - public final boolean hasQueuedThreads() 是否有线程正在等待获取许可证
 - protected Collection<Thread> getQueuedThreads()  返回所有等待获取许可证的线程集合，是个protected方法

### 线程间交换数据的Exchanger
一个用于线程间协作的工具类。它提供一个同步点，在这个同步点，两个线程更可以交换彼此的数据。这两个线程通过exchanger方法交换数据。如果第一个线程先执行exchange()方法，它会一直等待第二个线程也执行exchange方法。当两个线程都到达同步点时，这两个线程就可以交换数据。
```
public class ExchangerTest {
	static final Exchanger<String> exgr = new Exchanger<String>();
	static ExecutorService threadPool = Executors.newFixedThreadPool(2);
	public static void main(String[] args) {
		threadPool.execute(new Runnable() {
			@Override
			public void run() {
				try {
					String A = "银行流水A";
					String newA = exgr.exchange(A);
					System.out.println("newA "+newA);
				} catch (Exception e) {
				}
			}
		});
		threadPool.execute(new Runnable() {
			@Override
			public void run() {
				try {
					String B = "银行流水B";
					String newB = exgr.exchange(B);
					System.out.println("newB "+newB);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}
		});

	}
}
输出:
newB 银行流水A
newA 银行流水B
```











