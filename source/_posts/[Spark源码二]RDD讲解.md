title: "[Spark源码二】RDD讲解"
tags: [大数据,Spark]
categories: [大数据,Spark]
date: 2016-10-10 22:42:01
---

1、什么是RDD？

 RDD的全名是Resilient Distributed Dataset，意思是容错的分布式数据集，每一个RDD都会有5个特征：

1、有一个分片列表。就是能被切分，和hadoop一样的，能够切分的数据才能并行计算。
2、有一个函数计算每一个分片，这里指的是下面会提到的compute函数。
3、对其他的RDD的依赖列表，依赖还具体分为宽依赖和窄依赖，但并不是所有的RDD都有依赖。
4、可选：key-value型的RDD是根据哈希来分区的，类似于mapreduce当中的Paritioner接口，控制key分到哪个reduce。
5、可选：每一个分片的优先计算位置（preferred locations），比如HDFS的block的所在位置应该是优先计算的位置。


我们一项一项按着看。首先我们找到RDD这个文件

```
  //对一个分片进行计算，得出一个可遍历的结果
  def compute(split: Partition, context: TaskContext): Iterator[T]
  //只调用一次，返回RDD分区
  protected def getPartitions: Array[Partition]
   //也只会调用一次，返回依赖的Rdd
  protected def getDependencies: Seq[Dependency[_]] = deps

```

多种RDD之间的转换
下面用一个实例讲解一下吧，就拿我们常用的一段代码来讲吧，然后会把我们常用的RDD都会讲到。

```
    val hdfsFile = sc.textFile(args(1))
    val flatMapRdd = hdfsFile.flatMap(s => s.split(" "))
    val filterRdd = flatMapRdd.filter(_.length == 2)
    val mapRdd = filterRdd.map(word => (word, 1))
    val reduce = mapRdd.reduceByKey(_ + _)
```
这里涉及到多个RDD，首先sc.textFile得到一个HadoopRDD经过map之后MapPartitionsRDD经过flatMap之后为MapPartitionsRDD，经过filter之后MapPartitionsRDD经过map之后隐式转换未PairRDDFunctions静reduceByKey后转化为ShuffledRDD

我们先看一下
问题导读：
1.什么是RDD?
2.如何实现RDD转换？


1、什么是RDD？
上一章讲了Spark提交作业的过程，这一章我们要讲RDD。简单的讲，RDD就是Spark的input，知道input是啥吧，就是输入的数据。

RDD的全名是Resilient Distributed Dataset，意思是容错的分布式数据集，每一个RDD都会有5个特征：

1、有一个分片列表。就是能被切分，和hadoop一样的，能够切分的数据才能并行计算。
2、有一个函数计算每一个分片，这里指的是下面会提到的compute函数。
3、对其他的RDD的依赖列表，依赖还具体分为宽依赖和窄依赖，但并不是所有的RDD都有依赖。
4、可选：key-value型的RDD是根据哈希来分区的，类似于mapreduce当中的Paritioner接口，控制key分到哪个reduce。
5、可选：每一个分片的优先计算位置（preferred locations），比如HDFS的block的所在位置应该是优先计算的位置。

对应着上面这几点，我们在RDD里面能找到这4个方法和1个属性，别着急，下面我们会慢慢展开说这5个东东。


//只计算一次  
  protected def getPartitions: Array[Partition]  
  //对一个分片进行计算，得出一个可遍历的结果
  def compute(split: Partition, context: TaskContext): Iterator[T]
  //只计算一次，计算RDD对父RDD的依赖
  protected def getDependencies: Seq[Dependency[_]] = deps
  //可选的，分区的方法，针对第4点，类似于mapreduce当中的Paritioner接口，控制key分到哪个reduce
  @transient val partitioner: Option[Partitioner] = None
  //可选的，指定优先位置，输入参数是split分片，输出结果是一组优先的节点位置
  protected def getPreferredLocations(split: Partition): Seq[String] = Nil
复制代码




2、多种RDD之间的转换
下面用一个实例讲解一下吧，就拿我们常用的一段代码来讲吧，然后会把我们常用的RDD都会讲到。


val hdfsFile = sc.textFile(args(1))
    val flatMapRdd = hdfsFile.flatMap(s => s.split(" "))
    val filterRdd = flatMapRdd.filter(_.length == 2)
    val mapRdd = filterRdd.map(word => (word, 1))
    val reduce = mapRdd.reduceByKey(_ + _)
复制代码



这里涉及到很多个RDD，textFile是一个HadoopRDD经过map后的MappredRDD，经过flatMap是一个FlatMappedRDD，经过filter方法之后生成了一个FilteredRDD，经过map函数之后，变成一个MappedRDD，通过隐式转换成 PairRDD，最后经过reduceByKey。

我们首先看textFile的这个方法，进入SparkContext这个方法，找到它。

```
 def textFile(
      path: String,
      minPartitions: Int = defaultMinPartitions): RDD[String] = withScope {
    assertNotStopped()
    hadoopFile(path, classOf[TextInputFormat], classOf[LongWritable], classOf[Text],
      minPartitions).map(pair => pair._2.toString).setName(path)
  }
```
这个方法能读取hdfs文件、本地文件以及hadoop支持的其他文本文件，里面调用了hadoopFile,接着看这个方法
```
def hadoopFile[K, V](
      path: String,
      inputFormatClass: Class[_ <: InputFormat[K, V]],
      keyClass: Class[K],
      valueClass: Class[V],
      minPartitions: Int = defaultMinPartitions): RDD[(K, V)] = withScope {
    assertNotStopped()
    // A Hadoop configuration can be about 10 KB, which is pretty big, so broadcast it.
    val confBroadcast = broadcast(new SerializableConfiguration(hadoopConfiguration))
    val setInputPathsFunc = (jobConf: JobConf) => FileInputFormat.setInputPaths(jobConf, path)
    new HadoopRDD(
      this,
      confBroadcast,
      Some(setInputPathsFunc),
      inputFormatClass,
      keyClass,
      valueClass,
      minPartitions).setName(path)
  }

```

hadoopFile方法内静hadoop的配置文件放到广播变量，人后new 了一个HadoopRDD然后调用setName返回HadoopRDD，
以下构造HadoopRDD的参数
   sc:spark上下文
 　broadcastedConf：广播变量配置（hadoop的配置文件
 　initLocalJobConfFuncOpt:用于初始化HadoopRDD的job配置文件
   inputFormatClass:格式化读取数据文件
 　keyClass：为inputFormatClass指定的key
 　valueClass： inputFormatClass的Class
 　minPartitions：　HadoopRDD最小分区数
我们看一下HadoopRDD的主要方法：
首先getPartitions
```
override def getPartitions: Array[Partition] = {
    val jobConf = getJobConf()
    // add the credentials here as this can be called before SparkContext initialized
    SparkHadoopUtil.get.addCredentials(jobConf)
    val inputFormat = getInputFormat(jobConf)
    val inputSplits = inputFormat.getSplits(jobConf, minPartitions)
    val array = new Array[Partition](inputSplits.size)
    for (i <- 0 until inputSplits.size) {
      array(i) = new HadoopPartition(id, i, inputSplits(i))
    }
    array
  }
```
HadoopRDD按照inputSplits.size分割数据来分区的,然后把分片HadoopPartition包装到到array里面返回。



我们接下来看compute方法，它的输入值是一个Partition，返回是一个Iterator[(K, V)]类型的数据，这里面我们只需要关注2点即可。

1、把Partition转成HadoopPartition，然后通过InputSplit创建一个RecordReader
2、重写Iterator的getNext方法，通过创建的reader调用next方法读取下一个值。

```
override def compute(theSplit: Partition, context: TaskContext): InterruptibleIterator[(K, V)] = {
    val iter = new NextIterator[(K, V)] {

      val split = theSplit.asInstanceOf[HadoopPartition]
      logInfo("Input split: " + split.inputSplit)
      val jobConf = getJobConf()

      val inputMetrics = context.taskMetrics().inputMetrics
      val existingBytesRead = inputMetrics.bytesRead

      // Sets the thread local variable for the file's name
      split.inputSplit.value match {
        case fs: FileSplit => InputFileNameHolder.setInputFileName(fs.getPath.toString)
        case _ => InputFileNameHolder.unsetInputFileName()
      }

      // Find a function that will return the FileSystem bytes read by this thread. Do this before
      // creating RecordReader, because RecordReader's constructor might read some bytes
      val getBytesReadCallback: Option[() => Long] = split.inputSplit.value match {
        case _: FileSplit | _: CombineFileSplit =>
          SparkHadoopUtil.get.getFSBytesReadOnThreadCallback()
        case _ => None
      }

      // For Hadoop 2.5+, we get our input bytes from thread-local Hadoop FileSystem statistics.
      // If we do a coalesce, however, we are likely to compute multiple partitions in the same
      // task and in the same thread, in which case we need to avoid override values written by
      // previous partitions (SPARK-13071).
      def updateBytesRead(): Unit = {
        getBytesReadCallback.foreach { getBytesRead =>
          inputMetrics.setBytesRead(existingBytesRead + getBytesRead())
        }
      }

      var reader: RecordReader[K, V] = null
      val inputFormat = getInputFormat(jobConf)
      HadoopRDD.addLocalConfiguration(new SimpleDateFormat("yyyyMMddHHmm").format(createTime),
        context.stageId, theSplit.index, context.attemptNumber, jobConf)
      reader = inputFormat.getRecordReader(split.inputSplit.value, jobConf, Reporter.NULL)

      context.addTaskCompletionListener{ context => closeIfNeeded() }
      val key: K = reader.createKey()
      val value: V = reader.createValue()

      override def getNext(): (K, V) = {
       ......
      }

      override def close() {
       ......
      }
    }
    new InterruptibleIterator[(K, V)](context, iter)
  }
```
从这里我们可以看得出来compute方法是通过分片来获得Iterator接口，以遍历分片的数据。

getPreferredLocations方法就更简单了，直接调用InputSplit的getLocations方法获得所在的位置。

2.2 依赖
下面我们看RDD里面的map方法
```
def map[U: ClassTag](f: T => U): RDD[U] = withScope {
    val cleanF = sc.clean(f)
    new MapPartitionsRDD[U, T](this, (context, pid, iter) => iter.map(cleanF))
  }
```
直接new了一个MapPartitionsRDD然后讲函数穿进去，我们杀进MapPartitionsRDD
```
private[spark] class MapPartitionsRDD[U: ClassTag, T: ClassTag](
    var prev: RDD[T],
    f: (TaskContext, Int, Iterator[T]) => Iterator[U],  // (TaskContext, partition index, iterator)
    preservesPartitioning: Boolean = false)
  extends RDD[U](prev) {

  override val partitioner = if (preservesPartitioning) firstParent[T].partitioner else None

  override def getPartitions: Array[Partition] = firstParent[T].partitions

  override def compute(split: Partition, context: TaskContext): Iterator[U] =
    f(context, split.index, firstParent[T].iterator(split, context))
  // 清空父RDD
  override def clearDependencies() {
    super.clearDependencies()
    prev = null
}
```
先看一下RDD对应的构造方法
```
def this(@transient oneParent: RDD[_]) =
    this(oneParent.context, List(new OneToOneDependency(oneParent)))

```
就这样你会发现它把RDD复制给了deps，HadoopRDD成了我们杀进MapPartitionsRDD的父依赖了，这个OneToOneDependency是一个窄依赖，子RDD直接依赖于父RDD，继续看firstParent。
```
 protected[spark] def firstParent[U: ClassTag]: RDD[U] = {
    dependencies.head.rdd.asInstanceOf[RDD[U]]
  }
```
由此我们可以得出两个结论：

1、getPartitions直接沿用了父RDD的分片信息
2、compute函数是在父RDD遍历每一行数据时套一个匿名函数f进行处理
好吧，现在我们可以理解compute函数真正是在干嘛的了

它的两个显著作用：

1、在没有依赖的条件下，根据分片的信息生成遍历数据的Iterable接口
2、在有前置依赖的条件下，在父RDD的Iterable接口上给遍历每个元素的时候再套上一个方法

我们看看点击进入map(f)的方法进去看一下
```
def map[B](f: A => B): Iterator[B] = new AbstractIterator[B] {
    def hasNext = self.hasNext
    def next() = f(self.next())
  }
```
map方法将数据集的每一个数据按照f函数执行后返回数据

我们接着看RDD的flatMap方法，你会发现它和map函数几乎没什么区别，但是flatMap和map的效果还是差别挺大的。

比如((1,2),(3,4)), 如果是调用了flatMap函数，我们访问到的就是(1,2,3,4)4个元素；如果是map的话，我们访问到的就是(1,2),(3,4)两个元素。

有兴趣的可以去看看FlatMappedRDD和FilteredRDD

2.3 reduceByKey
下面我们看一下reduceByKey的实现。
reduceByKey隐藏的比较深，并没有在RDD中，而是在因式转换为PairRDDFunctions才可以使用，所以我们去PairRDDFunctions找一下

```
  def reduceByKey(func: (V, V) => V): RDD[(K, V)] = self.withScope {
    reduceByKey(defaultPartitioner(self), func)
  }
  
 def defaultPartitioner(rdd: RDD[_], others: RDD[_]*): Partitioner = {
   val bySize = (Seq(rdd) ++ others).sortBy(_.partitions.length).reverse
   for (r <- bySize if r.partitioner.isDefined && r.partitioner.get.numPartitions > 0) {
     return r.partitioner.get
   }
   if (rdd.context.conf.contains("spark.default.parallelism")) {
     new HashPartitioner(rdd.context.defaultParallelism)
   } else {
     new HashPartitioner(bySize.head.partitions.length)
   }
 }
 
 def reduceByKey(partitioner: Partitioner, func: (V, V) => V): RDD[(K, V)] = self.withScope {
    combineByKeyWithClassTag[V]((v: V) => v, func, func, partitioner)
  }
```
我们可以看到reduceByKeyreduceByKeyWithClassTag方法，有心去可以看一下
 ```
 def combineByKeyWithClassTag[C](
      createCombiner: V => C,
      mergeValue: (C, V) => C,
      mergeCombiners: (C, C) => C,
      partitioner: Partitioner,
      mapSideCombine: Boolean = true,
      serializer: Serializer = null)(implicit ct: ClassTag[C]): RDD[(K, C)] = self.withScope {
    require(mergeCombiners != null, "mergeCombiners must be defined") // required as of Spark 0.9.0
    if (keyClass.isArray) {
      if (mapSideCombine) {
        throw new SparkException("Cannot use map-side combining with array keys.")
      }
      if (partitioner.isInstanceOf[HashPartitioner]) {
        throw new SparkException("Default partitioner cannot partition array keys.")
      }
    }
    val aggregator = new Aggregator[K, V, C](
      self.context.clean(createCombiner),  //设置句聚合函数
      self.context.clean(mergeValue),   //valueMrege函数
      self.context.clean(mergeCombiners)) // 最终结果的整合函数
    if (self.partitioner == Some(partitioner)) {
    //不存在自定义分区
      self.mapPartitions(iter => {
        val context = TaskContext.get()
        new InterruptibleIterator(context, aggregator.combineValuesByKey(iter, context))
      }, preservesPartitioning = true)
    } else {
    //不存在自定义分区
      new ShuffledRDD[K, V, C](self, partitioner)
        .setSerializer(serializer)
        .setAggregator(aggregator)
        .setMapSideCombine(mapSideCombine)
    }
  }
  
  .......
  
  override def getDependencies: Seq[Dependency[_]] = {
    val serializer = userSpecifiedSerializer.getOrElse {
      val serializerManager = SparkEnv.get.serializerManager
      if (mapSideCombine) {
        serializerManager.getSerializer(implicitly[ClassTag[K]], implicitly[ClassTag[C]])
      } else {
        serializerManager.getSerializer(implicitly[ClassTag[K]], implicitly[ClassTag[V]])
      }
    }
    //
    List(new ShuffleDependency(prev, part, serializer, keyOrdering, aggregator, mapSideCombine))
  }
```

reduce流程可以总结为
1、将分区包装秤HashPartitioner分区
2、如果没有自定义分区则，直接执行combineCombinersByKey
3、  如果有自定义分区，则对shuffle自行combineCombinersByKey

下面我们先看MapPartitionsRDD，我把和别的RDD有别的两行给拿出来了，很明显的区别，f方法是套在iterator的外边，这样才能对iterator的所有数据做一个合并。

 ```
 override val partitioner = if (preservesPartitioning) firstParent[T].partitioner else None
  override def compute(split: Partition, context: TaskContext) =
    f(context, split.index, firstParent[T].iterator(split, context))
}
```

接下来我们看Aggregator的combineValuesByKey的方法吧。

def combineValuesByKey(iter: Iterator[_ <: Product2[K, V]],
                         context: TaskContext): Iterator[(K, C)] = {
    // 是否使用外部排序，是由参数spark.shuffle.spill，默认是true
    if (!externalSorting) {
      val combiners = new AppendOnlyMap[K,C]
      var kv: Product2[K, V] = null
      val update = (hadValue: Boolean, oldValue: C) => {
        if (hadValue) mergeValue(oldValue, kv._2) else createCombiner(kv._2)
      }
      // 用map来去重，用update方法来更新值，如果没值的时候，返回值，如果有值的时候，通过mergeValue方法来合并
      // mergeValue方法就是我们在reduceByKey里面写的那个匿名函数，在这里就是（_ + _）
      while (iter.hasNext) {
        kv = iter.next()
        combiners.changeValue(kv._1, update)
      }
      combiners.iterator
    } else {  
      // 用了一个外部排序的map来去重，就不停的往里面插入值即可，基本原理和上面的差不多，区别在于需要外部排序   
      val combiners = new ExternalAppendOnlyMap[K, V, C](createCombiner, mergeValue, mergeCombiners)
      while (iter.hasNext) {
        val (k, v) = iter.next()
        combiners.insert(k, v)
      }
      combiners.iterator
}



这个就是一个很典型的按照key来做合并的方法了，我们继续看ShuffledRDD吧。

ShuffledRDD和之前的RDD很明显的特征是

1、它的依赖传了一个Nil（空列表）进去，表示它没有依赖。
2、它的compute计算方式比较特别，这个在之后的文章说，过程比较复杂。
3、它的分片默认是采用HashPartitioner，数量和前面的RDD的分片数量一样，也可以不一样，我们可以在reduceByKey的时候多传一个分片数量即可。

在new完ShuffledRDD之后又来了一遍mapPartitionsWithContext，不过调用的匿名函数变成了combineCombinersByKey。

combineCombinersByKey和combineValuesByKey的逻辑基本相同，只是输入输出的类型有区别。combineCombinersByKey只是做单纯的合并，不会对输入输出的类型进行改变，combineValuesByKey会把iter[K, V]的V值变成iter[K, C]。

case class Aggregator[K, V, C] (
　　createCombiner: V => C,
　　mergeValue: (C, V) => C,
　　mergeCombiners: (C, C) => C)
　　......
}
复制代码



这个方法会根据我们传进去的匿名方法的参数的类型做一个自动转换。
到这里，作业都没有真正执行，只是将RDD各种嵌套，我们通过RDD的id和类型的变化观测到这一点，RDD[1]->RDD[2]->RDD[3]......
