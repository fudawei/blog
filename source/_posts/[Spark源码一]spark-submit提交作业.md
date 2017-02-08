title: "[Spark源码一】spark-submit提交作业过程"
tags: [大数据,Spark]
categories: [大数据,Spark]
date: 2016-09-27 22:42:01
---


使用spark已经有一段时间了，今天开始读spark源码。
首先从spark提交作业开始。下图为spark的架构，以及Spark的APP运行图。它通过一个Driver来和集群通信，集群负责作业的分配。今天我要讲的是如何创建这个Driver Program的过程。


![](/img/spark_architecture.png)
这个是Spark的App运行图，它通过一个Driver来和集群通信，集群负责作业的分配。今天我要讲的是如何创建这个Driver Program的过程。


# 作业提交
作业提交方法以及参数
我们先看一下用Spark Submit提交的方法吧，下面是从官方上面摘抄的内容。

```
 Run on a Spark standalone cluster
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://207.184.161.138:7077 \
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000
```

这个是提交到standalone集群的方式，打开spark-submit这文件，我们会发现它最后是调用了org.apache.spark.deploy.SparkSubmit这个类。


直接打开这个类，找到main入口，发现代码很简单
```
 def main(args: Array[String]): Unit = {
    val appArgs = new SparkSubmitArguments(args)
    if (appArgs.verbose) {
      // scalastyle:off println
      printStream.println(appArgs)
      // scalastyle:on println
    }
    appArgs.action match {
      case SparkSubmitAction.SUBMIT => submit(appArgs)
      case SparkSubmitAction.KILL => kill(appArgs)
      case SparkSubmitAction.REQUEST_STATUS => requestStatus(appArgs)
    }
  }
```
该方法做两件事：
1、这里SparkSubmitArguments类初始化过程将会加载spark默认配置文件的配置信息、运行环境信息，另外会将提交的参数覆盖默认配置（并且校验参数的合法性）
2、通过反射调用class主方法

有兴趣可以看一下SparkSubmitArguments，一下为默认环境配置信息的代码（loadEnvironmentArguments()方法内部）
```
master = Option(master)
      .orElse(sparkProperties.get("spark.master"))
      .orElse(env.get("MASTER"))
      .orNull
    driverExtraClassPath = Option(driverExtraClassPath)
      .orElse(sparkProperties.get("spark.driver.extraClassPath"))
      .orNull
    driverExtraJavaOptions = Option(driverExtraJavaOptions)
      .orElse(sparkProperties.get("spark.driver.extraJavaOptions"))
      .orNull
    driverExtraLibraryPath = Option(driverExtraLibraryPath)
      .orElse(sparkProperties.get("spark.driver.extraLibraryPath"))
      .orNull
    driverMemory = Option(driverMemory)
      .orElse(sparkProperties.get("spark.driver.memory"))
      .orElse(env.get("SPARK_DRIVER_MEMORY"))
      .orNull
    driverCores = Option(driverCores)
      .orElse(sparkProperties.get("spark.driver.cores"))
      .orNull
    executorMemory = Option(executorMemory)
      .orElse(sparkProperties.get("spark.executor.memory"))
      .orElse(env.get("SPARK_EXECUTOR_MEMORY"))
      .orNull
    executorCores = Option(executorCores)
      .orElse(sparkProperties.get("spark.executor.cores"))
      .orElse(env.get("SPARK_EXECUTOR_CORES"))
      .orNull
    totalExecutorCores = Option(totalExecutorCores)
      .orElse(sparkProperties.get("spark.cores.max"))
      .orNull
    name = Option(name).orElse(sparkProperties.get("spark.app.name")).orNull
    jars = Option(jars).orElse(sparkProperties.get("spark.jars")).orNull
    ivyRepoPath = sparkProperties.get("spark.jars.ivy").orNull
    packages = Option(packages).orElse(sparkProperties.get("spark.jars.packages")).orNull
    packagesExclusions = Option(packagesExclusions)
      .orElse(sparkProperties.get("spark.jars.excludes")).orNull
    deployMode = Option(deployMode).orElse(env.get("DEPLOY_MODE")).orNull
    numExecutors = Option(numExecutors)
      .getOrElse(sparkProperties.get("spark.executor.instances").orNull)
    keytab = Option(keytab).orElse(sparkProperties.get("spark.yarn.keytab")).orNull
    principal = Option(principal).orElse(sparkProperties.get("spark.yarn.principal")).orNull
```
......


# 提交流程
Driver程序的部署模式有两种，client和cluster，默认是client。client的话默认就是直接在本地运行了Driver程序了，cluster模式还会兜一圈把作业发到集群上面去运行。(指定部署模式需要用参数--deploy-mode来指定，或者在环境变量当中添加DEPLOY_MODE变量来指定。)


下面讲的是cluster的部署方式，兜一圈的这种情况。

yarn模式的话mainClass是org.apache.spark.deploy.yarn.Client，standalone的mainClass是org.apache.spark.deploy.Client。
这次我们讲org.apache.spark.deploy.Client，yarn的话有时间单独讲，目前超哥还是推荐使用standalone的方式部署spark，具体原因不详，据说是因为资源调度方面的问题。

# Client端

我们首先看一下Client的实现，首先找到这个类。
main函数中主要有一下几行：
```
val rpcEnv = RpcEnv.create("driverClient", Utils.localHostName(), 0, conf, new  SecurityManager(conf))
val masterEndpoints = driverArgs.masters.map(RpcAddress.fromSparkURL).
      map(rpcEnv.setupEndpointRef(_, Master.ENDPOINT_NAME))
rpcEnv.setupEndpoint("client", new ClientEndpoint(rpcEnv, driverArgs, masterEndpoints, conf))
rpcEnv.awaitTermination()
```

    这里看到一个rpcEnv，最后还调用了awaitTermination()方法，好像时启动了什么。另外Client继承了RpcEndpoint（ThreadSafeRpcEndpoint），浏览一下RpcEnv和RpcEndpoint的内容，其实就时用做发消息的，之前听说spark用的actor模式，每个进程之间可以看作是一个个独立的实体，他们之间是毫无关联的。但是，他们可以通过消息来通信。所有的任务都是通过消息通信完成。据说spark使用的是akka框架，但RpcEnv和RpcEndpoint没看到akka的实现，只有netty的实现，有可能spark已经讲akka实现移除了。至于actor模型有兴趣大家可自行百度。

**为了便于阅读源码我们看一下RpcEndpoint中比较重要的几个函数：**
onStart()             //rpcEndpoint启动时执行的操作
onStop()              //rpcEndpoint停止时执行的操作
receive()             //接受并处理RpcEndpointRef.send发送的信息
receiveAndReply()     //接受并处理RpcEndpointRef.ask发送的信息


接下来看一下启动时client做了那些操作

```
 override def onStart(): Unit = {
    driverArgs.cmd match {
      case "launch" =>
        // TODO: We could add an env variable here and intercept it in `sc.addJar` that would
        //       truncate filesystem paths similar to what YARN does. For now, we just require
        //       people call `addJar` assuming the jar is in the same directory.
        val mainClass = "org.apache.spark.deploy.worker.DriverWrapper"

        val classPathConf = "spark.driver.extraClassPath"
        val classPathEntries = sys.props.get(classPathConf).toSeq.flatMap { cp =>
          cp.split(java.io.File.pathSeparator)
        }

        val libraryPathConf = "spark.driver.extraLibraryPath"
        val libraryPathEntries = sys.props.get(libraryPathConf).toSeq.flatMap { cp =>
          cp.split(java.io.File.pathSeparator)
        }

        val extraJavaOptsConf = "spark.driver.extraJavaOptions"
        val extraJavaOpts = sys.props.get(extraJavaOptsConf)
          .map(Utils.splitCommandString).getOrElse(Seq.empty)
        val sparkJavaOpts = Utils.sparkJavaOpts(conf)
        val javaOpts = sparkJavaOpts ++ extraJavaOpts
        val command = new Command(mainClass,
          Seq("{{WORKER_URL}}", "{{USER_JAR}}", driverArgs.mainClass) ++ driverArgs.driverOptions,
          sys.env, classPathEntries, libraryPathEntries, javaOpts)

        val driverDescription = new DriverDescription(
          driverArgs.jarUrl,
          driverArgs.memory,
          driverArgs.cores,
          driverArgs.supervise,
          command)
        ayncSendToMasterAndForwardReply[SubmitDriverResponse](
          RequestSubmitDriver(driverDescription))

      case "kill" =>
        val driverId = driverArgs.driverId
        ayncSendToMasterAndForwardReply[KillDriverResponse](RequestKillDriver(driverId))
    }
  }
```

从上面的代码看得出来，它需要设置master的连接地址，最后提交了一个RequestSubmitDriver的信息。在receive方法里面，就是等待接受回应了，有两个Response分别对应着这里的launch和kill。这里发送的message信息是RequestSubmitDriver，顺便看一下ayncSendToMasterAndForwardReply实现：
```
 private def ayncSendToMasterAndForwardReply[T: ClassTag](message: Any): Unit = {
    for (masterEndpoint <- masterEndpoints) {
      masterEndpoint.ask[T](message).onComplete {
        case Success(v) => self.send(v)
        case Failure(e) =>
          logWarning(s"Error sending messages to master $masterEndpoint", e)
      }(forwardMessageExecutionContext)
    }
  }
```
注意：这里调用的是masterEndpoint.ask.

**小结：**

Client通过实现rpc框架实现了请求、接收请求、传递的消息、注册的地址和端口这些功能。


# Master端

接下来我们继续看Master段的代码

Master类同样继承了RpcEndpoint。Client端发送消息使用的时ask所以我们看一下receiveAndReply函数，找一下对应的消息接受处理：
```
override def receiveAndReply(context: RpcCallContext): PartialFunction[Any, Unit] = {
 case RequestSubmitDriver(description) =>
      if (state != RecoveryState.ALIVE) {
        val msg = s"${Utils.BACKUP_STANDALONE_MASTER_PREFIX}: $state. " +
          "Can only accept driver submissions in ALIVE state."
        context.reply(SubmitDriverResponse(self, false, None, msg))
      } else {
        logInfo("Driver submitted " + description.command.mainClass)
        val driver = createDriver(description)
        persistenceEngine.addDriver(driver)
        waitingDrivers += driver
        drivers.add(driver)
        //调度
        schedule()
        // 告诉client，提交成功了，把driver.id告诉它
        context.reply(SubmitDriverResponse(self, true, Some(driver.id),
          s"Driver successfully submitted as ${driver.id}"))
      }
```
接下来看调度方法
```
  private def schedule(): Unit = {
    if (state != RecoveryState.ALIVE) {
      return
    }
    // 首先调度Driver程序，从workers里面随机抽一些出来
    val shuffledAliveWorkers = Random.shuffle(workers.toSeq.filter(_.state == WorkerState.ALIVE))
    val numWorkersAlive = shuffledAliveWorkers.size
    var curPos = 0
    for (driver <- waitingDrivers.toList) { // iterate over a copy of waitingDrivers
      // We assign workers to each waiting driver in a round-robin fashion. For each driver, we
      // start from the last worker that was assigned a driver, and continue onwards until we have
      // explored all alive workers.
      var launched = false
      var numWorkersVisited = 0
      while (numWorkersVisited < numWorkersAlive && !launched) {
        val worker = shuffledAliveWorkers(curPos)
        numWorkersVisited += 1
        //判断内存和CPU资源是否足够，
        if (worker.memoryFree >= driver.desc.mem && worker.coresFree >= driver.desc.cores) {
          launchDriver(worker, driver)  //向worker发送信息，worker预留内存
          waitingDrivers -= driver
          launched = true
        }
        curPos = (curPos + 1) % numWorkersAlive
      }
    }
    //在worker上启动executor
    startExecutorsOnWorkers()
  }

```
这里仔细看一下worker启动executor的方法

 ```
 private def scheduleExecutorsOnWorkers(
      app: ApplicationInfo,
      usableWorkers: Array[WorkerInfo],
      spreadOutApps: Boolean): Array[Int] = {
    ......
    ......
    ......
    while (freeWorkers.nonEmpty) {
      freeWorkers.foreach { pos =>
        var keepScheduling = true
        while (keepScheduling && canLaunchExecutor(pos)) {
          coresToAssign -= minCoresPerExecutor
          assignedCores(pos) += minCoresPerExecutor

          // If we are launching one executor per worker, then every iteration assigns 1 core
          // to the executor. Otherwise, every iteration assigns cores to a new executor.
          if (oneExecutorPerWorker) {
            assignedExecutors(pos) = 1
          } else {
            assignedExecutors(pos) += 1
          }

          //spreadout 意味着分配executor时会尽可能均匀的分布到所有的worker节点上，否则会想将一个worker的资源分             //配完才会去其他的worker分配executor
          if (spreadOutApps) {
            keepScheduling = false
          }
        }
      }
      freeWorkers = freeWorkers.filter(canLaunchExecutor)
    }
    assignedCores
  }
```
它的调度器是这样的，先调度Driver程序，然后再调度App，调度App的方式是从各个worker的里面和App进行匹配，看需要分配多少个cpu。
那我们接下来看两个方法launchDriver和launchExecutor即可。
```
 private def launchDriver(worker: WorkerInfo, driver: DriverInfo) {
    logInfo("Launching     " + driver.id + " on worker " + worker.id)
    worker.addDriver(driver)
    driver.worker = Some(worker)
    worker.endpoint.send(LaunchDriver(driver.id, driver.desc))
    driver.state = DriverState.RUNNING
  }
```
给worker发送了一个LaunchDriver的消息，下面在看launchExecutor的方法。
```
private def launchExecutor(worker: WorkerInfo, exec: ExecutorDesc): Unit = {
    logInfo("Launching executor " + exec.fullId + " on worker " + worker.id)
    worker.addExecutor(exec)
    worker.endpoint.send(LaunchExecutor(masterUrl,
      exec.application.id, exec.id, exec.application.desc, exec.cores, exec.memory))
    exec.application.driver.send(
      ExecutorAdded(exec.id, worker.id, worker.hostPort, exec.cores, exec.memory))
  }
```

  它要做的事情多一点，除了给worker发送LaunchExecutor指令外，还需要给driver发送ExecutorAdded的消息，说你的任务已经有人干了。

在继续Worker讲之前，我们先看看它是怎么注册进来的，每个Worker启动之后，会自动去请求Master去注册自己，具体我们可以看receive的方法里面的RegisterWorker这一段，它需要上报自己的内存、Cpu、地址、端口等信息，注册成功之后返回RegisteredWorker信息给它，说已经注册成功了


# Worker执行

同样的，我们到Worker里面在receive方法找LaunchDriver和LaunchExecutor就可以找到我们要的东西。

```
case LaunchDriver(driverId, driverDesc) =>
      logInfo(s"Asked to launch driver $driverId")
      val driver = new DriverRunner(
        conf,
        driverId,
        workDir,
        sparkHome,
        driverDesc.copy(command = Worker.maybeUpdateSSLSettings(driverDesc.command, conf)),
        self,
        workerUri,
        securityMgr)
      drivers(driverId) = driver
      driver.start()

      coresUsed += driverDesc.cores
      memoryUsed += driverDesc.mem

```
这里运行LaunchDriver时，只是预分配了内存和CPU资源，接下来看一下start方法吧，start方法里面，其实是new Thread().start()，run方法里面是通过传过来的DriverDescription构造的一个命令，丢给ProcessBuilder去执行命令，结束之后调用。

worker ！DriverStateChanged通知worker，worker再通过master ! DriverStateChanged通知master，释放掉worker的cpu和内存。

接下来看一下看一下LaunchExecutor

```
 case LaunchExecutor(masterUrl, appId, execId, appDesc, cores_, memory_) =>
      if (masterUrl != activeMasterUrl) {
        logWarning("Invalid Master (" + masterUrl + ") attempted to launch executor.")
      } else {
        try {
          logInfo("Asked to launch executor %s/%d for %s".format(appId, execId, appDesc.name))

          // Create the executor's working directory
          val executorDir = new File(workDir, appId + "/" + execId)
          if (!executorDir.mkdirs()) {
            throw new IOException("Failed to create directory " + executorDir)
          }

          // Create local dirs for the executor. These are passed to the executor via the
          // SPARK_EXECUTOR_DIRS environment variable, and deleted by the Worker when the
          // application finishes.
          val appLocalDirs = appDirectories.getOrElse(appId,
            Utils.getOrCreateLocalRootDirs(conf).map { dir =>
              val appDir = Utils.createDirectory(dir, namePrefix = "executor")
              Utils.chmod700(appDir)
              appDir.getAbsolutePath()
            }.toSeq)
          appDirectories(appId) = appLocalDirs
          val manager = new ExecutorRunner(
            appId,
            execId,
            appDesc.copy(command = Worker.maybeUpdateSSLSettings(appDesc.command, conf)),
            cores_,
            memory_,
            self,
            workerId,
            host,
            webUi.boundPort,
            publicAddress,
            sparkHome,
            executorDir,
            workerUri,
            conf,
            appLocalDirs, ExecutorState.RUNNING)
          executors(appId + "/" + execId) = manager
          manager.start()
          coresUsed += cores_
          memoryUsed += memory_
          sendToMaster(ExecutorStateChanged(appId, execId, manager.state, None, None))
        } catch {
          case e: Exception =>
            logError(s"Failed to launch executor $appId/$execId for ${appDesc.name}.", e)
            if (executors.contains(appId + "/" + execId)) {
              executors(appId + "/" + execId).kill()
              executors -= appId + "/" + execId
            }
            sendToMaster(ExecutorStateChanged(appId, execId, ExecutorState.FAILED,
              Some(e.toString), None))
        }
      }
```

﻿同理，LaunchExecutor执行完毕了，通过worker ! ExecutorStateChanged通知worker，然后worker通过master ! ExecutorStateChanged通知master，释放掉worker的cpu和内存。

下面我们再梳理一下这个过程，只包括Driver注册，Driver运行之后的过程在之后的文章再说，比较复杂。

1、Client通过获得Url地址获得RpcEndPointRef（master的actor引用）,然后通过RpcEndPointRef给Master发送注册Driver请求（RequestSubmitDriver）
2、Master接收到请求之后就开始调度了，从workers列表里面找出可以用的Worker
3、通过Worker的actor引用RpcEndPointRef给可用的Worker发送启动Driver请求（LaunchDriver）
4、调度完毕之后，给Client回复注册成功消息(SubmitDriverResponse)
5、Worker接收到LaunchDriver请求之后，通过传过来的DriverDescription的信息构造出命令来，通过ProcessBuilder执行
6、ProcessBuilder执行完命令之后，通过DriverStateChanged通过Worker
7、Worker最后把DriverStateChanged汇报给Master

