title: '[日志处理]log4j配置详解'
tags: [日志处理]
categories: [日志处理]
date: 2015-08-31 00:14:26
---
# 概述
Log4j有三个主要的组件：Loggers(记录器)，Appenders (输出源)和Layouts(布局)。这里可简单理解为日志类别，日志要输出的地方和日志以何种形式输出。综合使用这三个组件可以轻松地记录信息的类型和级别，并可以在运行时控制日志输出的样式和位置。

<!--more-->
## Logger
Loggers组件被分为五个级别：

* DEBUG
* INFO
* WARN
* ERROR
* FATAL  

各个级别的顺序是这样那个的：
> **DEBUG < INFO < WARN < ERROR < FATAL**

可以简单地理解为级别越大越重要。  
Log4j有一个规则：只输出级别不低于设定级别的日志信息，假设Loggers级别设定为INFO，则INFO、WARN、ERROR和FATAL级别的日志信息都会输出，而级别比INFO低的DEBUG则不会输出。

## Appender
Appender用来规定日志输出的目的地是哪里，可以是控制台，文件，数据库等等。  
常见的Appender有以下几种：

* org.apache.log4j.ConsoleAppender（控制台）
* org.apache.log4j.FileAppender（文件）
* org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
* org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
* org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

在配置文件中是这样配置的：

>log4j.appender.appenderName = className  
log4j.appender.appenderName.Option1 = value1  
…  
log4j.appender.appenderName.OptionN = valueN  

其中appenderName是Appender的名字，可以随意起，只要满足命名规范就行，Option1，Option2，...，OptionN是这个appender的各种属性。

## Layout
Layout用来规定日志是以什么样的格式输出，需要输出哪些信息。Layout提供四种日志输出样式，如根据HTML样式、自由指定样式、包含日志级别与信息的样式和包含日志时间、线程、类别等信息的样式。  
常见的Layout如下：

* org.apache.log4j.HTMLLayout（以HTML表格形式布局）
* org.apache.log4j.PatternLayout（可以灵活地指定布局模式）
* org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串）
* org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等信息）

在配置文件中这样配置的：

> log4j.appender.appenderName.layout =className  
log4j.appender.appenderName.layout.Option1 = value1  
…  
log4j.appender.appenderName.layout.OptionN = valueN  

含义和Appender的配置是一样的，就不另作解释了。

## 配置详解
在实际应用中，要使Log4j在系统中运行须事先设定配置文件。配置文件事实上也就是对Logger、Appender及Layout进行相应设定。 Log4j支持两种配置文件格式，一种是XML格式的文件，一种是properties属性文件。下面以properties属性文件为例介绍。


### 配置Logger
> log4j.rootLogger = [ level ] , appenderName1, appenderName2, …  
log4j.additivity.org.apache=false # 表示Logger不会在父Logger的appender里输出，默认为true。  

**level** ：设定日志记录的最低级别，可设的值有OFF、FATAL、ERROR、WARN、INFO、DEBUG、ALL或者自定义的级别，Log4j建议只使用中间四个级别。通过在这里设定级别，您可以控制应用程序中相应级别的日志信息的开关，比如在这里设定了INFO级别，则应用程序中所有DEBUG级别的日志信息将不会被打印出来。  
**appenderName**：就是指定日志信息要输出到哪里。可以同时指定多个输出目的地，用逗号隔开。
例如：log4j.rootLogger＝INFO,A1,B2,C3

### 配置Appender
> log4j.appender.appenderName = className

**appenderName**: Appender的名字，自定义，在log4j.rootLogger设置中使用；  
**className**：Appender的类的全名（包含包名），常用的Appender的className如下：

* org.apache.log4j.ConsoleAppender（控制台）
* org.apache.log4j.FileAppender（文件）
* org.apache.log4j.DailyRollingFileAppender（每天产生一个日志文件）
* org.apache.log4j.RollingFileAppender（文件大小到达指定尺寸的时候产生一个新的文件）
* org.apache.log4j.WriterAppender（将日志信息以流格式发送到任意指定的地方）

#### ConsoleAppender的选项

* **Threshold**=WARN：指定日志信息的最低输出级别，默认为DEBUG。
* **ImmediateFlush**=true：表示所有消息都会被立即输出，设为false则不输出，默认值是true。
* **Target**=System.err：默认值是System.out。

#### FileAppender选项

* **Threshold**=WARN：指定日志信息的最低输出级别，默认为DEBUG。
* **ImmediateFlush**=true：表示所有消息都会被立即输出，设为false则不输出，默认值是true。
* **Append**=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认值是true。
* **File**=D:/logs/logging.log4j：指定消息输出到logging.log4j文件中

#### DailyRollingFileAppender选项

* **Threshold**=WARN：指定日志信息的最低输出级别，默认为DEBUG。
* **ImmediateFlush**=true：表示所有消息都会被立即输出，设为false则不输出，默认值是true。
* **Append**=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认值是true。
* **File**=D:/logs/logging.log4j：指定当前消息输出到logging.log4j文件中。
* **DatePattern**='.'yyyy-MM：每月滚动一次日志文件，即每月产生一个新的日志文件。当前月的日志文件名为logging.log4j，前一个月的日志文件名为logging.log4j.yyyy-MM。
另外，也可以指定按周、天、时、分等来滚动日志文件，对应的格式如下：
  * '.'yyyy-MM：每月
  * '.'yyyy-ww：每周
  * '.'yyyy-MM-dd：每天
  * '.'yyyy-MM-dd-a：每天两次
  * '.'yyyy-MM-dd-HH：每小时
  * '.'yyyy-MM-dd-HH-mm：每分钟
  
#### RollingFileAppender选项

* **Threshold**=WARN：指定日志信息的最低输出级别，默认为DEBUG。
* **ImmediateFlush**=true：表示所有消息都会被立即输出，设为false则不输出，默认值是true。
* **Append**=false：true表示消息增加到指定文件中，false则将消息覆盖指定的文件内容，默认值是true。
* **File**=D:/logs/logging.log4j：指定消息输出到logging.log4j文件中。
* **MaxFileSize=100KB：后缀可以是**KB, MB 或者GB**。在日志文件到达该大小时，将会自动滚动，即将原来的内容移到logging.log4j.1文件中。
* **MaxBackupIndex**=2：指定可以产生的滚动文件的最大数，例如，设为2则可以产生logging.log4j.1，logging.log4j.2两个滚动文件和一个logging.log4j文件。


### 配置Layout
> log4j.appender.appenderName.layout=className

常见的className如下：

* org.apache.log4j.HTMLLayout（以HTML表格形式布局）
* org.apache.log4j.PatternLayout（可以灵活地指定布局模式）
* org.apache.log4j.SimpleLayout（包含日志信息的级别和信息字符串）
* org.apache.log4j.TTCCLayout（包含日志产生的时间、线程、类别等等信息）

#### HTMLLayout选项

* **LocationInfo**=true：输出java文件名称和行号，默认值是false。
* **Title**=My Logging： 默认值是Log4J Log Messages。

#### PatternLayout选项

* **ConversionPattern**=%m%n：设定以怎样的格式显示消息。

各种格式化说明如下：

1. %p：输出日志信息的优先级，即DEBUG，INFO，WARN，ERROR，FATAL。
2. %d：输出日志时间点的日期或时间，默认格式为ISO8601，也可以在其后指定格式，如：%d{yyyy/MM/dd HH:mm:ss,SSS}。
3. %r：输出自应用程序启动到输出该log信息耗费的毫秒数。
4. %t：输出产生该日志事件的线程名。
5. %l：输出日志事件的发生位置，相当于%c.%M(%F:%L)的组合，包括类全名、方法、文件名以及在代码中的行数。例如：test.TestLog4j.main(TestLog4j.java:10)。
6. %c：输出日志信息所属的类目，通常就是所在类的全名。
7. %M：输出产生日志信息的方法名。
8. %F：输出日志消息产生时所在的文件名称。
9. %L:：输出代码中的行号。
10. %m:：输出代码中指定的具体日志信息。
11. %n：输出一个回车换行符，Windows平台为"\r\n"，Unix平台为"\n"。
12. %x：输出和当前线程相关联的NDC(嵌套诊断环境)，尤其用到像java servlets这样的多客户多线程的应用中。
13. %%：输出一个"%"字符。

另外，还可以在%与格式字符之间加上修饰符来控制其最小长度、最大长度、和文本的对齐方式。如：

* c：指定输出category的名称，最小的长度是20，如果category的名称长度小于20的话，默认的情况下右对齐。
* %-20c："-"号表示左对齐。
* %.30c：指定输出category的名称，最大的长度是30，如果category的名称长度大于30的话，就会将左边多出的字符截掉，但小于30的话也不会补空格。


## log4j的默认配置
log4j配置支持xml和properties两种格式的文件，默认先在程序的classpath目录下检查是否有log4j.xml文件，如果没有再出招log4j.properties文件。  
log4j的包中的LogManager类在加载的时候有个静态代码块是这样写的：


```
static {
    // By default we use a DefaultRepositorySelector which always returns 'h'.
    Hierarchy h = new Hierarchy(new RootLogger((Level) Level.DEBUG));
    repositorySelector = new DefaultRepositorySelector(h);

    /** Search for the properties file log4j.properties in the CLASSPATH.  */
    String override =OptionConverter.getSystemProperty(DEFAULT_INIT_OVERRIDE_KEY,
                               null);

    // if there is no default init override, then get the resource
    // specified by the user or the default config file.
    if(override == null || "false".equalsIgnoreCase(override)) {

      String configurationOptionStr = OptionConverter.getSystemProperty(
                              DEFAULT_CONFIGURATION_KEY, 
                              null);

      String configuratorClassName = OptionConverter.getSystemProperty(
                                                   CONFIGURATOR_CLASS_KEY, 
                           null);

      URL url = null;

      // if the user has not specified the log4j.configuration
      // property, we search first for the file "log4j.xml" and then
      // "log4j.properties"
      if(configurationOptionStr == null) {  
    url = Loader.getResource(DEFAULT_XML_CONFIGURATION_FILE);
    if(url == null) {
      url = Loader.getResource(DEFAULT_CONFIGURATION_FILE);
    }
      } else {
    try {
      url = new URL(configurationOptionStr);
    } catch (MalformedURLException ex) {
      // so, resource is not a URL:
      // attempt to get the resource from the class path
      url = Loader.getResource(configurationOptionStr); 
    }   
      }
      
      // If we have a non-null url, then delegate the rest of the
      // configuration to the OptionConverter.selectAndConfigure
      // method.
      if(url != null) {
    LogLog.debug("Using URL ["+url+"] for automatic log4j configuration.");      
    OptionConverter.selectAndConfigure(url, configuratorClassName, 
                       LogManager.getLoggerRepository());
      } else {
    LogLog.debug("Could not find resource: ["+configurationOptionStr+"].");
      }
    }  
  }
```
