title: 'slf4j的优势与使用原理'
tags: [日志处理]
categories: [日志处理]
date: 2015-08-26 22:39:41
---
# 概述
slf4j的全称是Simple Loging Facade For Java，即它仅仅是一个为Java程序提供日志输出的统一接口，并不是一个具体的日志实现方案，就比如JDBC一样，只是一种规则而已。所以单独的slf4j是不能工作的，必须搭配其他具体的日志实现方案，比如apache的**org.apache.log4j.Logger**，jdk自带的**java.util.logging.Logger**等等。
<!--more-->

# slf4j的优势
知道什么是slf4j之后我们应该明白为什么要使用slf4j，为什么不适用具体的日志实现方案。笔者理解，slf4j主要有以下几点优势：
## 与客户端解耦  
想象一下下面的场景：

> 有一个别人写的很棒的类库，里面使用的是jdk自带的java.util.logging.Logger这个日志系统，现在你有一个程序需要用到这个类库，并且你自己的程序现在是使用apache的org.apache.log4j.Logger这个日志系统。那么问题来了，如果你的程序导入了这个类库，那么是不是必须两种日志系统都要支持，那么你是不是需要多配置一些东西，多维护一些东西？耗费了太多维护成本，你想死的心都有了吧？

有问题就要有解决方案，不错，解决方案就是：**使用slf4j**。

slf4j只是一种接口，它本身并不关心你底层使用的是什么日志实现方案，所以它支持各种日志实现方案。简单的说，只要我们在类库中使用slf4j打日志，那么底层使用什么日志实现方案是使用者决定的，怎么决定？依靠配置文件和jar库。

## 省内存
如果大家之前使用过log4j，那么一定基本都是这样用的：

```
package com.winwill.test;

import org.apache.log4j.Logger;

/**
 * @author qifuguang
 * @date 15/8/26 21:54
 */
public class TestLog4j {
    private static final Logger LOGGER = Logger.getLogger(TestLog4j.class);

    public static void main(String[] args) {
        String message = "Hello World.";
        LOGGER.info("This is a test message: " + message);
    }
}
```
注意到log4j的info函数有两种使用方式：

```
public void info(Object message)
public void info(Object message, Throwable t)
```
第一个参数是要输出的信息，假设要输出的是一个字符串，并且字符串中包含变量，则message参数就必须使用字符串相加操作，就比如上面测试代码的14行一样。姑且不说字符串相加是一个比较消耗性能的操作，字符串是一个不可变对象，一旦创建就不能被修改，创建的字符串会保存在String池中，占用内存。更糟糕的是如果配置文件中配置的日志级别是ERROR的话，这行info日志根本不会输出，则相加得到的字符串对象是一个非必须对象，白白浪费了内存空间。有人会说了，那我可以这样写啊：

```
package com.winwill.test;

import org.apache.log4j.Logger;

/**
 * @author qifuguang
 * @date 15/8/26 21:54
 */
public class TestLog4j {
    private static final Logger LOGGER = Logger.getLogger(TestLog4j.class);

    public static void main(String[] args) {
        String message = "Hello World.";
        if (LOGGER.isInfoEnabled()) {
            LOGGER.info("This is a test message: " + message);
        }
    }
}
```
这样不就解决了白白浪费内存的问题了吗？没错，这是一个变通方案，但是这样的代码太繁琐，不直观！

再来看看slf4j的打日志的方式：

```
package com.winwill.test;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author qifuguang
 * @date 15/8/26 21:54
 */
public class TestLog4j {
    private static final Logger LOGGER = LoggerFactory.getLogger(TestLog4j.class);

    public static void main(String[] args) {
        String message = "Hello World.";
        LOGGER.info("This is a test message: {}", message);
    }
}
```
看到没有，打日志的时候使用了{}占位符，这样就不会有字符串拼接操作，减少了无用String对象的数量，节省了内存。并且，记住，在生产最终日志信息的字符串之前，这个方法会检查一个特定的日志级别是不是打开了，这不仅降低了内存消耗而且预先降低了CPU去处理字符串连接命令的时间。这里是使用SLF4J日志方法的代码，来自于slf4j-log4j12-1.6.1.jar中的Log4j的适配器类Log4jLoggerAdapter。

```
public void debug(String format, Object arg1, Object arg2) {
    if (logger.isDebugEnabled()) {
        FormattingTuple ft = MessageFormatter.format(format, arg1, arg2);
        logger.log(FQCN, Level.DEBUG, ft.getMessage(), ft.getThrowable());
    }
}
```

# slf4j的使用与绑定原理
前面介绍了slf4j的优势，本节介绍怎么使用slf4j以及其中的原理，前文说到了，单独的slf4j是不能工作的，必须带上其他具体的日志实现方案。就以apache的log4j作为具体日志实现方案为例，如果在工程中要使用slf4j作为接口，并且要用log4j作为具体实现方案，那么我们需要做的事情如下：（下面的xxx表示具体版本号）

* 将slf4j-api-xxx.jar加入工程classpath中；
* 将slf4j-log4jxx-xxx.jar加入工程classpath中；
* 将log4j-xxx.jar加入工程classpath中；
* 将log4j.properties（log4j.xml）文件加入工程classpath中。

介绍一下工作原理：

首先，slf4j-api作为slf4j的接口类，使用在程序代码中，这个包提供了一个Logger类和LoggerFactory类，Logger类用来打日志，LoggerFactory类用来获取Logger；slf4j-log4j是连接slf4j和log4j的桥梁，怎么连接的呢？我们看看slf4j的LoggerFactory类的getLogger函数的源码：

```
  /**
   * Return a logger named corresponding to the class passed as parameter, using
   * the statically bound {@link ILoggerFactory} instance.
   *
   * @param clazz the returned logger will be named after clazz
   * @return logger
   */
  public static Logger getLogger(Class clazz) {
    return getLogger(clazz.getName());
  }
  /**
   * Return a logger named according to the name parameter using the statically
   * bound {@link ILoggerFactory} instance.
   *
   * @param name The name of the logger.
   * @return logger
   */
  public static Logger getLogger(String name) {
    ILoggerFactory iLoggerFactory = getILoggerFactory();
    return iLoggerFactory.getLogger(name);
  }
  
    public static ILoggerFactory getILoggerFactory() {
    if (INITIALIZATION_STATE == UNINITIALIZED) {
      INITIALIZATION_STATE = ONGOING_INITIALIZATION;
      performInitialization();
    }
    switch (INITIALIZATION_STATE) {
      case SUCCESSFUL_INITIALIZATION:
        return StaticLoggerBinder.getSingleton().getLoggerFactory();
      case NOP_FALLBACK_INITIALIZATION:
        return NOP_FALLBACK_FACTORY;
      case FAILED_INITIALIZATION:
        throw new IllegalStateException(UNSUCCESSFUL_INIT_MSG);
      case ONGOING_INITIALIZATION:
        // support re-entrant behavior.
        // See also http://bugzilla.slf4j.org/show_bug.cgi?id=106
        return TEMP_FACTORY;
    }
    throw new IllegalStateException("Unreachable code");
  }
```
追踪到最后，发现LoggerFactory.getLogger()首先获取一个ILoggerFactory接口，然后使用该接口获取具体的Logger。获取ILoggerFactory的时候用到了一个StaticLoggerBinder类，仔细研究我们会发现StaticLoggerBinder这个类并不是slf4j-api这个包中的类，而是slf4j-log4j包中的类，这个类就是一个中间类，它用来将抽象的slf4j变成具体的log4j，也就是说具体要使用什么样的日志实现方案，就得靠这个StaticLoggerBinder类。再看看slf4j-log4j包种的这个StaticLoggerBinder类创建ILoggerFactory长什么样子：

```
  private final ILoggerFactory loggerFactory;

  private StaticLoggerBinder() {
    loggerFactory = new Log4jLoggerFactory();
    try {
      Level level = Level.TRACE;
    } catch (NoSuchFieldError nsfe) {
      Util
          .report("This version of SLF4J requires log4j version 1.2.12 or later. See also http://www.slf4j.org/codes.html#log4j_version");
    }
  }

  public ILoggerFactory getLoggerFactory() {
    return loggerFactory;
  }
```
可以看到slf4j-log4j中的StaticLoggerBinder类创建的ILoggerFactory其实是一个**org.slf4j.impl.Log4jLoggerFactory**，这个类的getLogger函数是这样的：

```
  public Logger getLogger(String name) {
    Logger slf4jLogger = loggerMap.get(name);
    if (slf4jLogger != null) {
      return slf4jLogger;
    } else {
      org.apache.log4j.Logger log4jLogger;
      if(name.equalsIgnoreCase(Logger.ROOT_LOGGER_NAME))
        log4jLogger = LogManager.getRootLogger();
      else
        log4jLogger = LogManager.getLogger(name);

      Logger newInstance = new Log4jLoggerAdapter(log4jLogger);
      Logger oldInstance = loggerMap.putIfAbsent(name, newInstance);
      return oldInstance == null ? newInstance : oldInstance;
    }
  }
```
就在其中创建了真正的**org.apache.log4j.Logger**，也就是我们需要的具体的日志实现方案的Logger类。就这样，整个绑定过程就完成了，没晕吧？log4j.properties(log4j.xml)的具体配置下一篇文章会详细介绍。

 
