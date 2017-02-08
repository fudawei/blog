title: "[Spark源码三】作业运行过程"
tags: [大数据,Spark]
categories: [大数据,Spark]
date: 2016-10-25 22:42:01
---

官方给的例子里面，一执行collect方法就能出结果，那我们就从collect开始看吧，进入RDD，找到collect方法。

```
def collect(): Array[T] = {
    val results = sc.runJob(this, (iter: Iterator[T]) => iter.toArray)
    Array.concat(results: _*)
  }
```

它进行了两个操作：


1、调用SparkContext的runJob方法，把自身的引用传入去，再传了一个匿名函数（把Iterator转换成Array数组）
2、把result结果合并成一个Array，注意results是一个Array[Array[T]]类型，所以第二句的那个写法才会那么奇怪。这个操作是很重的一个操作，如果结果很大的话，这个操作是会报OOM的，因为它是把结果保存在Driver程序的内存当中的result数组里面。

我们点进去runJob这个方法吧。

```
val callSite = getCallSite
    val cleanedFunc = clean(func)
    dagScheduler.runJob(rdd, cleanedFunc, partitions, callSite, allowLocal, resultHandler, localProperties.get)
    rdd.doCheckpoint()
```




追踪下去，我们会发现经过多个不同的runJob同名函数调用之后，执行job作业靠的是dagScheduler，最后把结果通过resultHandler保存返回。


DAGScheduler如何划分作业

好的，我们继续看DAGScheduler的runJob方法，提交作业，然后等待结果，成功什么都不做，失败抛出错误，我们接着看submitJob方法。
```
     val start = System.nanoTime
    // 记录作业成功与失败的数据结构，一个作业的Task数量是和分片的数量一致的，Task成功之后调用resultHandler保存结果。
    val waiter = submitJob(rdd, func, partitions, callSite, resultHandler, properties)
    val awaitPermission = null.asInstanceOf[scala.concurrent.CanAwait]
    waiter.completionFuture.ready(Duration.Inf)(awaitPermission)
    waiter.completionFuture.value.get match {
      case scala.util.Success(_) =>
        logInfo("Job %d finished: %s, took %f s".format
          (waiter.jobId, callSite.shortForm, (System.nanoTime - start) / 1e9))
      case scala.util.Failure(exception) =>
        logInfo("Job %d failed: %s, took %f s".format
          (waiter.jobId, callSite.shortForm, (System.nanoTime - start) / 1e9))
        // SPARK-8644: Include user stack trace in exceptions coming from DAGScheduler.
        val callerStackTrace = Thread.currentThread().getStackTrace.tail
        exception.setStackTrace(exception.getStackTrace ++ callerStackTrace)
        throw exception
    }

```

    val jobId = nextJobId.getAndIncrement()
    val func2 = func.asInstanceOf[(TaskContext, Iterator[_]) => _]
    
    val waiter = new JobWaiter(this, jobId, partitions.size, resultHandler)
    eventProcessActor ! JobSubmitted(jobId, rdd, func2, partitions.toArray, allowLocal, callSite, waiter, properties)




走到这里，感觉有点儿绕了，为什么到了这里，还不直接运行呢，还要给DAGSchedulerEventProcessLoop发送一个JobSubmitted请求呢，new一个线程和这个区别有多大？


不管了，搜索一下DAGSchedulerEventProcessLoop吧，结果发现它是一个DAGSchedulerEventProcessLoop，它的定义也在DAGScheduler这个类里面。它的receive方法里面定义了12种事件的处理方法，这里我们只需要看JobSubmitted的就行，它也是调用了自身的handleJobSubmitted方法。但是这里很奇怪，没办法打断点调试，但是它的结果倒是能返回的，因此我们得用另外一种方式，打开test工程，找到scheduler目录下的DAGSchedulerSuite这个类，我们自己写一个test方法，首先我们要在import那里加上import org.apache.spark.SparkContext._  ，然后加上这一段测试代码。
