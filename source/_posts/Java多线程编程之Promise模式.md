title: "Java多线程编程之Promise模式"
tags: [Java,多线程]
categories: [Java,多线程]
date: 2016-11-24 22:42:01
---

### Promise模式简介

Promise模式是一种异步编程模式 。它使得我们可以先开始一个任务的执行，并得到一个用于获取该任务执行结果的凭据对象，而不必等待该任务执行完毕就可以继续执行其他操作。等到我们需要该任务的执行结果时，再调用凭据对象的相关方法来获取。这样就避免了不必要的等待，增加了系统的并发性。这好比我们去小吃店，同时点了鸭血粉丝汤和生煎包。当我们点餐付完款后，我们拿到手的其实只是一张可借以换取相应食品的收银小票（凭据对象）而已，而不是对应的实物。由于鸭血粉丝汤可以较快制作好，故我们可以凭收银小票即刻兑换到。而生煎包的制作则比较耗时，因此我们可以先吃拿到手的鸭血粉丝汤，而不必饿着肚子等生煎包出炉再一起吃。等到我们把鸭血粉丝汤吃得差不多的时候，生煎包可能也出炉了，这时我们再凭收银小票去换取生煎包，如图所示。

![](/img/concurrent-1.png)

### Promise模式的架构

Promise模式中，客户端代码调用某个异步方法所得到的返回值仅是一个凭据对象（该对象被称为Promise，意为“承诺”）。凭借该对象，客户端代码可以获取异步方法相应的真正任务的执行结果。为了讨论方便，下文我们称异步方法对应的真正的任务为异步任务。

Promise模式的主要参与者有以下几种。其类图如图所示。

![](/img/concurrent-2.png)

- Promisor：负责对外暴露可以返回Promise对象的异步方法，并启动异步任务的执行。其主要方法及职责如下。
     - compute：启动异步任务的执行，并返回用于获取异步任务执行结果的凭据对象。
- Promise：包装异步任务处理结果的凭据对象。负责检测异步任务是否处理完毕、返回和存储异步任务处理结果。其主要方法及职责如下。
     - getResult：获取与其所属Promise实例关联的异步任务的执行结果。
     - setResult：设置与其所属Promise实例关联的异步任务的执行结果。
     - isDone：检测与其所属Promise实例关联的异步任务是否执行完毕。
- Result：负责表示异步任务处理结果。具体类型由应用决定。
- TaskExecutor：负责真正执行异步任务所代表的计算，并将其计算结果设置到相应的Promise实例。其主要方法及职责如下
     - run：执行异步任务所代表的计算。
客户端代码获取异步任务处理结果的过程如图所示的序列图。

![](/img/concurrent-3.png)

图中．获取异步任务的处理结果

第1步：客户端代码调用Promisor的异步方法compute。

第2、3步：compute方法创建Promise实例作为该方法的返回值，并返回。

第4步：客户端代码调用其所得到的Promise对象的getResult方法来获取异步任务处理结果。如果此时异步任务执行尚未完成，则getResult方法会阻塞（即调用方代码的运行线程暂时处于阻塞状态）。

异步任务的真正执行以及其处理结果的设置如图所示的序列图。

![](/img/concurrent-4.png)

图中．设置异步任务的处理结果

第1步：Promisor的异步方法compute创建TaskExecutor实例。

第2步：TaskExecutor的run方法被执行（可以由专门的线程或者线程池 来调用run方法）。

第3步：run方法创建表示其执行结果的Result实例。

第4、5步：run方法将其处理结果设置到相应的Promise实例上。

### Promise模式实战案例解析

某系统的一个数据同步模块需要将一批本地文件上传到指定的目标FTP服务器上。这些文件是根据页面中的输入条件查询数据库的相应记录生成的。在将文件上传到目标服务器之前，需要对FTP客户端实例进行初始化（包括与对端服务器建立网络连接、向服务器发送登录用户和向服务器发送登录密码）。而FTP客户端实例初始化这个操作比较耗时间，我们希望它尽可能地在本地文件上传之前准备就绪。因此我们可以引入异步编程，使得FTP客户端实例初始化和本地文件上传这两个任务能够并发执行，减少不必要的等待。另一方面，我们不希望这种异步编程增加了代码编写的复杂性。这时，Promise模式就可以派上用场了：先开始FTP客户端实例的初始化，并得到一个获取FTP客户端实例的凭据对象。在不必等待FTP客户端实例初始化完毕的情况下，每生成一个本地文件，就通过凭据对象获取FTP客户端实例，再通过该FTP客户端实例将文件上传到目标服务器上。代码如清单1所示 。

清单1．数据同步模块的入口类
```

public class DataSyncTask implements Runnable {

	private final Map<String, String> taskParameters;
	public DataSyncTask(Map<String, String> taskParameters) {
		this.taskParameters = taskParameters;
	}
	@Override
	public void run() {
		String ftpServer = taskParameters.get("server");
		String ftpUserName = taskParameters.get("userName");
		String password = taskParameters.get("password");
		
		//先开始初始化FTP客户端实例
		Future<FTPClientUtil> ftpClientUtilPromise = FTPClientUtil.newInstance(
		    ftpServer, ftpUserName, password);
		//查询数据库生成本地文件
		generateFilesFromDB();
		FTPClientUtil ftpClientUtil = null;
		try {
			// 获取初始化完毕的FTP客户端实例
			ftpClientUtil = ftpClientUtilPromise.get();
		} catch (InterruptedException e) {
			;
		} catch (ExecutionException e) {
			throw new RuntimeException(e);
		}
		// 上传文件
		uploadFiles(ftpClientUtil);
		//省略其他代码
	}
	private void generateFilesFromDB() {
		// 省略其他代码
	}
	private void uploadFiles(FTPClientUtil ftpClientUtil) {
		Set<File> files = retrieveGeneratedFiles();
		for (File file : files) {
			try {
				ftpClientUtil.upload(file);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	private Set<File> retrieveGeneratedFiles() {
		Set<File> files = new HashSet<File>();
		// 省略其他代码
		return files;
	}
}
```

从清单1的代码中可以看出，DataSyncTask类的run方法先开始FTP客户端实例的初始化，并得到获取相应FTP客户端实例的凭据对象ftpClientUtilPromise。接着，它直接开始查询数据库并生成本地文件。而此时，FTP客户端实例的初始化可能尚未完成。在本地文件生成之后，run方法通过调用ftpClientUtilPromise的get方法来获取相应的FTP客户端实例。此时，如果相应的FTP客户端实例的初始化仍未完成，则该调用会阻塞，直到相应的FTP客户端实例的初始化完成或者失败。run方法获取到FTP客户端实例后，调用其upload方法将文件上传到指定的FTP服务器。

清单1代码所引用的FTP客户端工具类FTPClientUtil的代码如清单6-2所示。

清单2．FTP客户端工具类源码

//模式角色：Promise.Promisor、Promise.Result
```
public class FTPClientUtil {
	private final FTPClient ftp = new FTPClient();

	private final Map<String, Boolean> dirCreateMap = new HashMap<String, Boolean>();

	private FTPClientUtil() {

	}

	//模式角色：Promise.Promisor.compute
	public static Future<FTPClientUtil> newInstance(final String ftpServer,
	    final String userName, final String password) {

		Callable<FTPClientUtil> callable = new Callable<FTPClientUtil>() {

			@Override
			public FTPClientUtil call() throws Exception {
				FTPClientUtil self = new FTPClientUtil();
				self.init(ftpServer, userName, password);
				return self;
			}

		};

		//task相当于模式角色：Promise.Promise
		final FutureTask<FTPClientUtil> task = new FutureTask<FTPClientUtil>(
		    callable);

		/*
		下面这行代码与本案例的实际代码并不一致，这是为了讨论方便。
		下面新建的线程相当于模式角色：Promise.TaskExecutor
		*/
		new Thread(task).start();
		return task;
	}

	private void init(String ftpServer, String userName, String password)
	    throws Exception {

		FTPClientConfig config = new FTPClientConfig();
		ftp.configure(config);

		int reply;
		ftp.connect(ftpServer);

		System.out.print(ftp.getReplyString());

		reply = ftp.getReplyCode();

		if (!FTPReply.isPositiveCompletion(reply)) {
			ftp.disconnect();
			throw new RuntimeException("FTP server refused connection.");
		}
		boolean isOK = ftp.login(userName, password);
		if (isOK) {
			System.out.println(ftp.getReplyString());

		} else {
			throw new RuntimeException("Failed to login." + ftp.getReplyString());
		}

		reply = ftp.cwd("~/subspsync");
		if (!FTPReply.isPositiveCompletion(reply)) {
			ftp.disconnect();
			throw new RuntimeException("Failed to change working directory.reply:"
			    + reply);
		} else {

			System.out.println(ftp.getReplyString());
		}

		ftp.setFileType(FTP.ASCII_FILE_TYPE);

	}

	public void upload(File file) throws Exception {
		InputStream dataIn = new BufferedInputStream(new FileInputStream(file),
		    1024 * 8);
		boolean isOK;
		String dirName = file.getParentFile().getName();
		String fileName = dirName + '/' + file.getName();
		ByteArrayInputStream checkFileInputStream = new ByteArrayInputStream(
		    "".getBytes());

		try {
			if (!dirCreateMap.containsKey(dirName)) {
				ftp.makeDirectory(dirName);
				dirCreateMap.put(dirName, null);
			}

			try {
				isOK = ftp.storeFile(fileName, dataIn);
			} catch (IOException e) {
				throw new RuntimeException("Failed to upload " + file, e);
			}
			if (isOK) {
				ftp.storeFile(fileName + ".c", checkFileInputStream);

			} else {

				throw new RuntimeException("Failed to upload " + file + ",reply:" + 
","+ ftp.getReplyString());
			}
		} finally {
			dataIn.close();
		}

	}

	public void disconnect() {
		if (ftp.isConnected()) {
			try {
				ftp.disconnect();
			} catch (IOException ioe) {
				// 什么也不做
			}
		}
	}
}
```

FTPClientUtil类封装了FTP客户端，其构造方法是private修饰的，因此其他类无法通过new来生成相应的实例，而是通过其静态方法newInstance来获得实例。不过newInstance方法的返回值并不是一个FTPClientUtil实例，而是一个可以获取FTPClientUtil实例的凭据对象java.util.concurrent.Future（具体说是java.util.concurrent.FutureTask，它实现了java.util.concurrent.Future接口）实例。因此，FTPClientUtil既相当于Promise模式中的Promisor参与者实例，又相当于Result参与者实例。而newInstance方法的返回值java.util.concurrent.FutureTask实例既相当于Promise参与者实例，又相当于TaskExecutor参与者实例：newInstance方法的返回值java.util.concurrent.FutureTask实例不仅负责该方法真正处理结果（初始化完毕的FTP客户端实例）的存储和获取，还负责执行异步任务（调用FTPClientUtil实例的init方法），并设置任务的处理结果。

从如清单2所示的Promise客户端代码（DataSyncTask类的run方法）来看，使用Promise模式的异步编程并没有本质上增加编程的复杂性：客户端代码的编写方式与同步编程并没有太大差别，唯一一点差别就是获取FTP客户端实例的时候多了一步对java.util.concurrent.FutureTask实例的get方法的调用。

### Promise模式的评价与实现考量

Promise模式既发挥了异步编程的优势——增加系统的并发性，减少不必要的等待，又保持了同步编程的简单性：有关异步编程的细节，如创建新的线程或者提交任务到线程池执行等细节，都被封装在Promisor参与者实例中，而Promise的客户端代码则无须关心这些细节，其编码方式与同步编程并无本质上差别。这点正如清单6-1代码所展示的，客户端代码仅仅需要调用FTPClientUtil的newInstance静态方法，再调用其返回值的get方法，即可获得一个初始化完毕的FTP客户端实例。这本质上还是同步编程。当然，客户端代码也不能完全无视Promise模式的异步编程这一特性：为了减少客户端代码在调用Promise的getResult方法时出现阻塞的可能，客户端代码应该尽可能早地调用Promisor的异步方法，并尽可能晚地调用Promise的getResult方法。这当中间隔的时间可以由客户端代码用来执行其他操作，同时这段时间可以给TaskExecutor用于执行异步任务。

Promise模式一定程度上屏蔽了异步、同步编程的差异。前文我们一直说Promisor对外暴露的compute方法是个异步方法。事实上，如果compute方法是一个同步方法，那么Promise模式的客户端代码的编写方式也是一样的。也就是说，无论compute方法是一个同步方法还是异步方法，Promise客户端代码的编写方式都是一样的。例如，本章案例中FTPClientUtil的newInstance方法如果改成同步方法，我们只需要将其方法体中的语句new Thread(task).start();改为task.run();即可。而该案例中的其他代码无须更改。这就在一定程度上屏蔽了同步、异步编程的差异。而这可以给代码调试或者问题定位带来一定的便利。比如，我们的本意是要将compute方法设计成一个异步方法，但在调试代码的时候发现结果不对，那么我们可以尝试临时将其改为同步方法。若此时原先存在的问题不再出现，则说明问题是compute方法被编码为异步方法后所产生的多线程并发访问控制不正确导致的。

1. 异步方法的异常处理

如果Promisor的compute方法是个异步方法，那么客户端代码在调用完该方法后异步任务可能尚未开始执行。另外，异步任务运行在自己的线程中，而不是compute方法的调用方线程中。因此，异步任务执行过程中产生的异常无法在compute方法中抛出。为了让Promise模式的客户端代码能够捕获到异步任务执行过程中出现的异常，一个可行的办法是让TaskExecutor在执行任务捕获到异常后，将异常对象“记录”到Promise实例的一个专门的实例变量上，然后由Promise实例的getResult方法对该实例变量进行检查。若该实例变量的值不为null，则getResult方法抛出异常。这样，Promise模式的客户端代码通过捕获getResult方法抛出的异常即可“知道”异步任务执行过程中出现的异常。JDK中提供的类java.util.concurrent.FutureTask就是采用这种方法对compute异步方法的异常进行处理的。

2. 轮询（Polling）

客户端代码对Promise的getResult的调用可能由于异步任务尚未执行完毕而阻塞，这实际上也是一种等待。虽然我们可以通过尽可能早地调用compute方法并尽可能晚地调用getResult方法来减少这种等待的可能性，但是它仍然可能会出现。某些场景下，我们可能根本不希望进行任何等待。此时，我们需要在调用Promise的getResult方法之前确保异步任务已经执行完毕。因此，Promise需要暴露一个isDone方法用于检测异步任务是否已执行完毕。JDK提供的类java.util.concurrent.FutureTask的isDone方法正是出于这种考虑，它允许我们在“适当”的时候才调用Promise的getResult方法（相当于FutureTask的get方法）。

3. 异步任务的执行

本章案例中，异步任务的执行我们是通过新建一个线程，由该线程去调用TaskExecutor的run方法来实现的（见清单6-2）。这只是为了讨论方便。如果系统中同时存在多个线程调用Promisor的异步方法，而每个异步方法都启动了各自的线程去执行异步任务，这可能导致一个JVM中启动的线程数量过多，增加了线程调度的负担，从而反倒降低了系统的性能。因此，如果Promise模式的客户端并发量比较大，则需要考虑由线程池负责执行TaskExecutor的run方法来实现异步任务的执行。例如，如清单2所示的异步任务如果改用线程池去执行，我们只需要将代码改为类似如清单3所示的代码即可。

清单3．用线程池执行异步任务
```
public class FTPClientUtil {
	private volatilestatic ThreadPoolExecutor threadPoolExecutor;

	static {
		threadPoolExecutor = new ThreadPoolExecutor(1,Runtime.getRuntime()
		    .availableProcessors() * 2, 
		    60, 
		    TimeUnit.SECONDS,
		    new ArrayBlockingQueue<Runnable>(10), new ThreadFactory() {
			    public Thread newThread(Runnable r) {
				    Thread t = new Thread(r);
				    t.setDaemon(true);
				    return t;
			    }
		    }, new ThreadPoolExecutor.CallerRunsPolicy());
	}
	
	private final FTPClient ftp = new FTPClient();
	private final Map<String, Boolean> dirCreateMap = new HashMap<String, Boolean>();

	//私有构造器
	private FTPClientUtil() {

	}

	public static Future<FTPClientUtil> newInstance(final String ftpServer,
	    final String userName, final String password) {

		Callable<FTPClientUtil> callable = new Callable<FTPClientUtil>() {

			@Override
			public FTPClientUtil call() throws Exception {
				FTPClientUtil self = new FTPClientUtil();
				self.init(ftpServer, userName, password);
				return self;
			}

		};
		final FutureTask<FTPClientUtil> task = new FutureTask<FTPClientUtil>(
		    callable);

		threadPoolExecutor.execute(task);
		return task;
	}

	private void init(String ftpServer, String userName, String password)
	    throws Exception {
		//省略与清单6-2中相同的代码
	}

	public void upload(File file) throws Exception {
		//省略与清单6-2中相同的代码
	}

	public void disconnect() {
		//省略与清单2中相同的代码
	}

}

```


Promise模式的可复用实现代码

JDK1.5开始提供的接口java.util.concurrent.Future可以看成是Promise模式中Promise参与者的抽象，其声明如下：

public interface Future<V>
该接口的类型参数V相当于Promise模式中的Result参与者。该接口定义的方法及其与Promise参与者相关方法之间的对应关系如表6-1所示。

表1．接口java.util.concurrent.Future与Promise参与者的对应关系

![](/img/concurrent-5.png)


接口java.util.concurrent.Future的实现类java.util.concurrent.FutureTask可以看作Promise模式的Promise参与者实例。

如清单2所示的代码中的异步方法newInstance展示了如何使用java.util.concurrent.FutureTask来作为Promise参与者。

Java标准库实例

JAX-WS 2.0 API中用于支持调用Web Service的接口javax.xml.ws.Dispatch就使用了Promise模式。该接口用于异步调用Web Service的方法声明如下：

```
Response<T>invokeAsync(T msg)
```

该方法不等对端服务器给响应就返回了（即实现了异步调用Web Service），从而避免了Web Service客户端进行不必要的等待。而客户端需要其调用的Web Service的响应时，可以调用invokeAsync方法的返回值的相关方法来获取。invokeAsync的返回值类型为javax.xml.ws.Response，它继承自java.util.concurrent.Future。因此，javax.xml.ws.Dispatch相当于Promise模式中的Promisor参与者实例，其异步方法invokeAsync(T msg)的返回值相当于Promise参与者实例

相关模式

1. Guarded Suspension模式

Promise模式的客户端代码调用Promise的getResult方法获取异步任务处理结果时，如果异步任务已经执行完毕，则该调用会直接返回。否则，该调用会阻塞直到异步任务处理结束或者出现异常。这种通过线程阻塞而进行的等待可以看作Guarded Suspension模式的一个实例。只不过，一般情况下Promise参与者我们可以直接使用JDK中提供的类java.util.concurrent.FutureTask来实现，而无须自行编码。关于java.util.concurrent.FutureTask如何实现通过阻塞去等待异步方法执行结束，感兴趣的读者可以去阅读JDK标准库的源码。

2. Active Object模式

Active Object模式可以看成是包含了Promise模式的复合模式。其Proxy参与者相当于Promise模式的Promisor参与者。Proxy参与者的异步方法返回值相当于Promise模式的Promise参与者实例。Active Object模式的Scheduler参与者相当于Promise模式的TaskExecutor参与者。

3. Master-Slave模式

Master-Slave模式中，Slave参与者返回其对子任务的处理结果可能需要使用Promise模式。此时，Slave参与者相当于Promise模式的Promisor参与者，其subService方法的返回值是一个Promise模式的Promise参与者实例。

4. Factory Method模式

Promise模式中的Promisor参与者可以看成是Factory Method模式的一个例子：Promisor的异步方法可以看成一个工厂方法，该方法的返回值是一个Promise实例。
