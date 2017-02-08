title: Java面试题
date: 2014-09-15 22:19:53
categories: [面试]
tags: [面试]
---

## java

### Java基础

1. String类为什么是final的。
效率和安全，性能
2. HashMap的源码，实现原理，底层结构。

3. 说说你知道的几个Java集合类：list、set、queue、map实现类咯。。。
List: ArrayList  LinkedList  Vector  Stack
Set : TreeSet  HashSet
Queur: BlockingQueue   Deque
Map : HashMap  Hashtable
4. 描述一下ArrayList和LinkedList各自实现和区别
ArrayList 是一个数组队列，相当于动态数组。它由数组实现，随机访问效率高，随机插入、随机删除效率低。
LinkedList 是一个双向链表。它也可以被当作堆栈、队列或双端队列进行操作。LinkedList随机访问效率低，但随机插入、随机删除效率低。
5. Java中的队列都有哪些，有什么区别。

6. 反射中，Class.forName和classloader的区别
Class.forName(className)装载的class已经被初始化，而ClassLoader.loadClass(className)装载的class还没有被link。
一般情况下，这两个方法效果一样，都能装载Class。但如果程序依赖于Class是否被初始化，就必须用Class.forName(name)了。
7. Java7、Java8的新特性(baidu问的,好BT)
lambda 流式编程  函数式接口
8. Java数组和链表两种结构的操作效率，在哪些情况下(从开头开始，从结尾开始，从中间开始)，哪些操作(插入，查找，删除)的效率高
9. Java内存泄露的问题调查定位：jmap，jstack的使用等等

10. string、stringbuilder、stringbuffer区别
StringBuilder > StringBuffer > String  速度
StringBuffer 线程安全的
11. hashtable和hashmap的区别
线程安全 && null值两方面
13 .异常的结构，运行时异常和非运行时异常，各举个例子
1)非受检的：NullPointerException,ClassCastException,ArrayIndexsOutOfBoundsException,ArithmeticException(算术异常，除0溢出)
2)受检：Exception,FileNotFoundException,IOException,SQLException.
14. String a= "abc" String b = "abc" String c = new String("abc") String d = "ab" + "c" .他们之间用 == 比较的结果
15. String 类的常用方法
String.toCharArray()  String.getBytes()  String.length()   String.indexOf(String str)   String.subString()
String.split()    toUpperCase()   replace()
16. Java 的引用类型有哪几种
17. 抽象类和接口的区别

18. java的基础类型和字节大小。
char  16bit  |   short   16bit  |   byte    8bit | int  32bit   |   long   64bit  |  floag   32bit  |  double  64bit
19. Hashtable,HashMap,ConcurrentHashMap 底层实现原理与线程安全问题
20. 自己实现一个Map。
21. Hash冲突怎么办？哪些解决散列冲突的方法？

22. HashMap冲突很厉害，最差性能，你会怎么解决?从O（n）提升到log（n）咯，用二叉排序树的思路说了一通
23. rehash
24. hashCode() 与 equals() 生成算法、方法怎么重写

### Java IO

1. 讲讲IO里面的常见类，字节流、字符流、接口、实现类、方法阻塞。
2. 讲讲NIO。
Channels and Buffers（通道和缓冲区）：标准的IO基于字节流和字符流进行操作的，而NIO是基于通道（Channel）和缓冲区（Buffer）进行操作，数据总是从通道读取到缓冲区中，或者从缓冲区写入到通道中
3. String 编码UTF-8 和GBK的区别?
GBK占用两个字节；UTF8对于英文占用一个字节，对于中文占用两个字节
4. 什么时候使用字节流、什么时候使用字符流?
字节流在操作时本身不会用到缓冲区；而字符流在操作时用到了缓冲区，通过缓冲区再操作文件
所有的文件在硬盘或在传输时都是以字节的方式进行的，包括图片等都是按字节的方式存储的，而字符是只有在内存中才会形成，所以在开发中，字节流使用较为广泛。
程序中的输入输出都是以流的形式保存的，流中保存的实际上全都是字节文件。
如果要java程序实现一个拷贝功能，应该选用字节流进行操作（可能拷贝的是图片），并且采用边读边写的方式（节省内存）
5. 递归读取文件夹下的文件，代码怎么实现

### Java Web

1. session和cookie的区别和联系，session的生命周期，多个服务部署时session管理。

2. servlet的一些相关问题
3. webservice相关问题
4. jdbc连接，forname方式的步骤，怎么声明使用一个事务。举例并具体代码
5. 无框架下配置web.xml的主要配置内容
6. jsp和servlet的区别

### JVM

1. Java的内存模型以及GC算法
2. jvm性能调优都做了什么
3. 介绍JVM中7个区域，然后把每个区域可能造成内存的溢出的情况说明
4. 介绍GC 和GC Root不正常引用。
5. 自己从classload 加载方式，加载机制说开去，从程序运行时数据区，讲到内存分配，讲到String常量池，讲到JVM垃圾回收机制，算法，hotspot。反正就是各种扩展
6. jvm 如何分配直接内存， new 对象如何不分配在堆而是栈上，常量池解析
7. 数组多大放在 JVM 老年代（不只是设置 PretenureSizeThreshold ，问通常多大，没做过一问便知）
8. 老年代中数组的访问方式
9. GC 算法，永久代对象如何 GC ， GC 有环怎么处理
10. 谁会被 GC ，什么时候 GC
11. 如果想不被 GC 怎么办
12. 如果想在 GC 中生存 1 次怎么办

### 开源框架

1. hibernate和ibatis的区别
2. 讲讲mybatis的连接池。
3. spring框架中需要引用哪些jar包，以及这些jar包的用途
4. springMVC的原理
5. springMVC注解的意思
6. spring中beanFactory和ApplicationContext的联系和区别
7. spring注入的几种方式（循环注入）
8. spring如何实现事物管理的
9. springIOC
10. spring AOP的原理
11. hibernate中的1级和2级缓存的使用方式以及区别原理（Lazy-Load的理解）
12. Hibernate的原理体系架构，五大核心接口，Hibernate对象的三种状态转换，事务管理。
六、多线程
1. Java创建线程之后，直接调用start()方法和run()的区别
2. 常用的线程池模式以及不同线程池的使用场景
3. newFixedThreadPool此种线程池如果线程数达到最大值后会怎么办，底层原理。
4. 多线程之间通信的同步问题，synchronized锁的是对象，衍伸出和synchronized相关很多的具体问题，例如同一个类不同方法都有synchronized锁，一个对象是否可以同时访问。或者一个类的static构造方法加上synchronized之后的锁的影响。
5. 了解可重入锁的含义，以及ReentrantLock 和synchronized的区别
6. 同步的数据结构，例如concurrentHashMap的源码理解以及内部实现原理，为什么他是同步的且效率高
7. atomicinteger和volatile等线程安全操作的关键字的理解和使用
8. 线程间通信，wait和notify
9. 定时线程的使用
10. 场景：在一个主线程中，要求有大量(很多很多)子线程执行完之后，主线程才执行完成。多种方式，考虑效率。
11. 进程和线程的区别
12. 什么叫线程安全？举例说明
13. 线程的几种状态
14. 并发、同步的接口或方法
15. HashMap 是否线程安全，为何不安全。 ConcurrentHashMap，线程安全，为何安全。底层实现是怎么样的。
16. J.U.C下的常见类的使用。 ThreadPool的深入考察； BlockingQueue的使用。（take，poll的区别，put，offer的区别）；原子类的实现。
17. 简单介绍下多线程的情况，从建立一个线程开始。然后怎么控制同步过程，多线程常用的方法和结构
18. volatile的理解
19. 实现多线程有几种方式，多线程同步怎么做，说说几个线程里常用的方法

### 网络通信

1. http是无状态通信，http的请求方式有哪些，可以自己定义新的请求方式么。
2. socket通信，以及长连接，分包，连接异常断开的处理。
3. socket通信模型的使用，AIO和NIO。
4. socket框架netty的使用，以及NIO的实现原理，为什么是异步非阻塞。
5. 同步和异步，阻塞和非阻塞。
异步的概念和同步相对。当一个异步过程调用发出后，调用者不会立刻得到结果。实际处理这个调用的部件是在调用发出后，通过状态、通知来通知
调用者，或通过回调函数处理这个调用。
阻塞调用是指调用结果返回之前，当前线程会被挂起。函数只有在得到结果之后才会返回。
非阻塞和阻塞的概念相对应，指在不能立刻得到结果之前，该函数不会阻塞当前线程，而会立刻返回。
有同步阻塞、异步阻塞、同步非阻塞、异步非阻塞
6. OSI七层模型，包括TCP,IP的一些基本知识
7. http中，get post的区别
8. 说说http,tcp,udp之间关系和区别。
9. 说说浏览器访问www.taobao.com，经历了怎样的过程。
本地缓存   DNS缓存  迭代查询和递归查询
10. HTTP协议、  HTTPS协议，SSL协议及完整交互过程；
11. tcp的拥塞，快回传，ip的报文丢弃
12. https处理的一个过程，对称加密和非对称加密
13. head各个特点和区别

### 数据库MySql

1. MySql的存 储引擎的不同
2. 单个索引、联合索引、主键索引
3. Mysql怎么分表，以及分表后如果想按条件分页查询怎么办(如果不是按分表字段来查询的话，几乎效率低下，无解)
4. 分表之后想让一个id多个表是自增的，效率实现
5. MySql的主从实时备份同步的配置，以及原理(从库读主库的binlog)，读写分离
6. 写SQL语句。。。
7. 索引的数据结构，B+树

8. 事务的四个特性，以及各自的特点（原子、隔离）等等，项目怎么解决这些问题
9. 数据库的锁：行锁，表锁；乐观锁，悲观锁

10. 数据库事务的几种粒度；
事务四个特性 ： 原子性  一致性  隔离性   持久性

11. 关系型和非关系型数据库区别
> * 非关系型数据库的优势：
1. 性能
NOSQL是基于键值对的，可以想象成表中的主键和值的对应关系，而且不需要经过SQL层的解析，所以性能非常高。
2. 可扩展性
同样也是因为基于键值对，数据之间没有耦合性，所以非常容易水平扩展。
> * 关系型数据库的优势：
1. 复杂查询
可以用SQL语句方便的在一个表以及多个表之间做非常复杂的数据查询。
2. 事务支持
使得对于安全性能很高的数据访问要求得以实现。
### 设计模式

1. 单例模式：饱汉、饿汉。以及饿汉中的延迟加载,双重检查
2. 工厂模式、装饰者模式、观察者模式。
3. 工厂方法模式的优点（低耦合、高内聚，开放封闭原则）

### 算法

1. 使用随机算法产生一个数，要求把1-1000W之间这些数全部生成。（考察高效率，解决产生冲突的问题）
2. 两个有序数组的合并排序
3. 一个数组的倒序
4. 计算一个正整数的正平方根
5. 说白了就是常见的那些查找、排序算法以及各自的时间复杂度
6. 二叉树的遍历算法
7. DFS,BFS算法
9. 比较重要的数据结构，如链表，队列，栈的基本理解及大致实现。
10. 排序算法与时空复杂度（快排为什么不稳定，为什么你的项目还在用）
11. 逆波兰计算器
12. Hoffman 编码
13. 查找树与红黑树

### 并发与性能调优

1. 有个每秒钟5k个请求，查询手机号所属地的笔试题(记得不完整，没列出)，如何设计算法?请求再多，比如5w，如何设计整个系统?
2. 高并发情况下，我们系统是如何支撑大量的请求的
3. 集群如何同步会话状态
4. 负载均衡的原理
5 .如果有一个特别大的访问量，到数据库上，怎么做优化（DB设计，DBIO，SQL优化，Java优化）
6. 如果出现大面积并发，在不增加服务器的基础上，如何解决服务器响应不及时问题“。
7. 假如你的项目出现性能瓶颈了，你觉得可能会是哪些方面，怎么解决问题。
8. 如何查找 造成 性能瓶颈出现的位置，是哪个位置照成性能瓶颈。
9. 你的项目中使用过缓存机制吗？有没用用户非本地缓存

### 其他

1.常用的linux下的命令



排序：
在待排序的文件中，若存在多个关键字相同的记录，经过排序后，这些具有相同关键字的记录之间的相对次序保持不变，该排序
方法是稳定的；若具有相同关键字的记录之间的相对次序发生变化，则称这种排序方法是不稳定的。
排序时不涉及数据的内外存交换，称之为内部排序；反之，排序过程要进行数据的内外存交换，称之为外部排序。

冒泡排序

```
public static void bublbleSort(int[] source) {
		for(int i = source.length-1;i > 0;i --) {
			for(int j = 0; j < i; j ++) {
				if(source[j] > source[j+1]) {
					swap(source,j,j+1);
				}

			}
		}
```
选择排序
```
public static void selectSort(int[] source) {
		for(int i = 0;i<source.length;i++) {
			for(int j = i+1;j<source.length;j++) {
				if(source[i] > source[j]) {
					swap(source, j, i);
				}
			}
		}
	}
```
插入排序
```
public static void insertSort(int[] source) {
		for(int i = 0;i<source.length;i++) {
			for(int j =i;(j>0 && source[j] < source[j-1]);j--) {
					swap(source, j, j-1);
			}
		}
	}
```
快速排序




### 利用StringBuilder 重写toString()方法
```
public String toString() {
        StringBuilder sb = new StringBuilder("[");
        Field[] fields = getClass().getDeclaredFields();
        for (Field field : fields) {
            try {
                field.setAccessible(true);
                sb.append(field.getName()).append(":").append(field.get(this)).append(",");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // 去掉多于的逗号
        if(sb.length() > 1){
            sb.deleteCharAt(sb.length()-1);
        }
        sb.append("]");
        return sb.toString();
    }
```
### 字节和位的转化
```
    /**
     * Byte转Bit
     */
    public static String byteToBit(byte b) {
        return "" + (byte) ((b >> 7) & 0x1) + (byte) ((b >> 6) & 0x1)
                + (byte) ((b >> 5) & 0x1) + (byte) ((b >> 4) & 0x1)
                + (byte) ((b >> 3) & 0x1) + (byte) ((b >> 2) & 0x1)
                + (byte) ((b >> 1) & 0x1) + (byte) ((b >> 0) & 0x1);
    }

    /**
     * Bit转Byte
     */
    public static byte BitToByte(String byteStr) {
        int re, len;
        if (null == byteStr) {
            return 0;
        }
        len = byteStr.length();
        if (len != 4 && len != 8) {
            return 0;
        }
        if (len == 8) {// 8 bit处理
            if (byteStr.charAt(0) == '0') {// 正数
                re = Integer.parseInt(byteStr, 2);
            } else {// 负数
                re = Integer.parseInt(byteStr, 2) - 256;
            }
        } else {// 4 bit处理
            re = Integer.parseInt(byteStr, 2);
        }
        return (byte) re;
    }
```
### ReentrantLock
ReadWriteLock 中若Reader优先的话会无限期地延迟 writer，而 writer 优先会减少可能的并发。
### 垃圾收集算法：
可达性分析： 将一些列gc roots 对象作为起始点，当一个对象到gc roots 没有任何引用链相连时，则不可用
一、标记-清除算法
    缺点：效率低，会产生空间碎片
二、复制算法
    一块Eden，两块survivor清理时将一块Eden和一块survivor上存活的对象复制到剩下的那块survivor上，之后清理掉前两者。
三、标记-整理算法
    标记后，将所有存活的对象向一段移动，剩下的清理。
四、分代收集算法
    商业虚拟机均用此，根据对象存活周期的不同分为新生代和老年代，新生代用复制算法，老年代用标记清除算法和标记整理算法。
### wait()、sleep()、notify()、notifyAll()区别
wait():使一个线程处于等待状态，并且释放锁。
sleep():使一个正在运行的线程处于睡眠状态，是一个静态方法，调用此方法要捕捉InterruptedException异常。此方法不会释放锁。
notify():唤醒一个处于等待状态的线程，注意的是在调用此方法的时候，并不能确切的唤醒某一个等待状态的线程，而是由JVM确定唤醒哪个线程(一般是最先开始等待的线程)，而且不是按优先级。
notityAll():唤醒所有处入等待状态的线程，注意并不是给所有唤醒线程一个对象的锁，而是让它们竞争。

JDK1.5中提供了多线程升级的解决方案：将同步synchonized替换成了显式的Lock操作，将Object中的wait、notify、notifyAll替换成了Condition对象。
### Lock的方法摘要：
void lock()  获取锁。
Condition newCondition() 返回绑定到此 Lock 实例的新 Condition 实例。
void unlock() 释放锁。
Condition方法摘要：
void await() 造成当前线程在接到信号或被中断之前一直处于等待状态。
void signal() 唤醒一个等待线程。
void signalAll() 唤醒所有等待线程。
### 守护线程(后台线程)
setDaemon(boolean on):将该线程标记为守护线程或者用户线程。当正在运行的线程都是守护线程时，java虚拟机jvm退出；所以该方法必须在启动线程前调用；
### 进程线程管程区别
进程 ： 一个程序在一个数据集合上的一次运行过程，是资源分配的最小单位，进程无法突破进程边界存取其他进程内的存储空间
线程 ： 线程是进程中的一个实体，是被系统独立调度和执行的最小单位，同一进程所产生的线程共享同一内存空间。
管程： 管程是定义了一个数据结构和在该数据结构上的能为并发进程锁执行的一组操作，这组操作能同步进程和改变管程上的数据
进程间通信 信号量、消息队列、共享内存

### 死锁
产生死锁的条件：　互斥、请求与保持、不剥夺条件、循环等待条件
解除与预防：
1.采用资源静态分配策略，破坏"部分分配"条件
2.允许进程剥夺使用其他进程占有的资源，破坏不可剥夺条件
3.采用资源有序分配法，破坏环路条件

### 静态链接库和动态链接库
都是共享代码的方式，如果采用静态链接库，lib中的指令都全部被直接包含在最终生成的exe文件中了。但是若使用dll，该dll不被包含在最终exe文件中，exe文件执行时可以动态的引用和卸载这个与exe独立的dll文件。

### 聚集索引和非聚集索引
1.聚集索引的顺序就是数据的物理存储顺序，非聚集索引的索引顺序与物理顺序无关。
2.一个表只能包含一个聚集索引，可以有多个非聚集索引
3.聚集索引对于那些经常要搜索范围值的列有效。使用聚集索引找到包含第一个值的行后，便可以确保包含后续索引值的行在物理相邻
4.非索引存储中的项目按索引键值的顺序存储，而表中信息按另一种顺序存储。

### 类加载机制
1、寻找jre目录，寻找jvm.dll，并初始化JVM；
2、产生一个Bootstrap Loader（启动类加载器）；
3、Bootstrap Loader自动加载Extended Loader（标准扩展类加载器），并将其父Loader设为Bootstrap Loader。
4、Bootstrap Loader自动加载AppClass Loader（系统类加载器），并将其父Loader设为Extended Loader。
5、最后由AppClass Loader加载HelloWorld类。
### 类加载器的特点
1、运行一个程序时，总是由AppClass Loader（系统类加载器）开始加载指定的类。
2、在加载类时，每个类加载器会将加载任务上交给其父，如果其父找不到，再由自己去加载。
3、Bootstrap Loader（启动类加载器）是最顶级的类加载器了，其父加载器为null.

### Java 虚拟机
1.在启动一个java程序的同时会诞生一个虚拟机实例，当该程序退出时，虚拟机实例也随之消亡。如果在同一计算机同时运行三个java程序，会得到三个java虚拟机实例。每个java程序都运行在自己的java虚拟机实例中。
2.java栈是由许多栈帧组成的，一个栈帧包含一个java方法调用的状态。当线程调用一个java方法时，虚拟机压入一个新的栈帧到该线程的java栈中；当该方法返回时，这个栈帧被从java栈中弹出并抛弃。
3.对于一个正在运行java方法的线程而言，它的PC寄存器总是指向下一条将被执行的指令。

### 什么是ThreadLocal类,怎么使用它？
一个线程局部变量(ThreadLocal variables)为每个线程方便地提供了一个单独的变量。
ThreadLocal 实例通常作为静态的私有的(private static)字段出现在一个类中，这个类用来关联一个线程。当多个线程访问 ThreadLocal 实例时，每个线程维护 ThreadLocal 提供的独立的变量副本。
> 常用的使用可在 DAO 模式中见到，当 DAO 类作为一个单例类时，数据库链接(connection)被每一个线程独立的维护，互不影响。(基于线程的单例)

### 单例模式
1.为避免其他程序创建该类对象，将构造函数私有化
2.为了其他程序访问到该类对象，须在本类中创建一个该类私有对象
3.为了方便其他程序访问该类对象，可对外提供一个公共访问方式
比如API中的Runtime类就是单例设计模式。
### final关键字
(1)最终的意思，可以用于修饰类，方法，变量。
(2)final修饰的类不能被继承。final修饰的方法不能被重写。final修饰的变量是一个常量。只能被赋值一次。
  内部类只能访问被final修饰的局部变量。

### 模板设计模式：
在定义功能时，功能的一部分是确定的，有一部分是不确定的，而且确定的部分在使用不确定的部分，
可将不确定的部分暴露出去，由该类的子类去完成。
如：求一段程序的运行时间例子。

### Mess
不重写Bean的hashCode()方法是否会对性能带来影响？
如果一个计算hash的方法写得不好，直接的影响是，当向HashMap中添加元素的时候会更频繁地造成冲突
对于一个不可修改的类，它的每个对象是不是都必须声明成final的？
不尽然，可以将成员声明为private，不为它提供setter方法，同时不会通过任何方法泄漏出对此成员的引用高就可以不被别的类修改。注意：把对象声明为final仅仅保证了它不会被重新赋值，你仍然可以通过此引用过来修改引用对象的属性。
### 什么是不可修改对象(Immutable Object)？你能否写一个例子？
不可修改对象是那些一旦被创建就不能修改的对象。例如Java中的String类就是不可修改的。大多数这样的类通常都是final类型的，因为这样可以避免自己被继承继而被覆盖方法，你同样要保证你的类不要通过任何方法暴露成员，当你通过类函数返回一个可修改对象的时候，返回一个类成功的副本，防止客户代码通过此引用修改了成员对象的属性。

### 双亲委派模型的工作过程为：
1、前 ClassLoader 首先从自己已经加载的类中查询是否此类已经加载，如果已经加载则直接返回原来已经加载的类。
每个类加载器都有自己的加载缓存，当一个类被加载了以后就会放入缓存，等下次加载的时候就可以直接返回了。
2、当前 classLoader 的缓存中没有找到被加载的类的时候，委托父类加载器去加载，父类加载器采用同样的策略，首先查看自己的缓存，然后委托父类的父类去加载，一直到 bootstrap ClassLoader.
3、当所有的父类加载器都没有加载的时候，再由当前的类加载器加载，并将其放入它自己的缓存中，以便下次有加载请求的时候直接返回。
classloader 有两种装载class的方式
1、隐式：运行过程中，碰到new方式生成对象时，隐式调用classLoader到JVM
2、显式：通过class.forname()动态加载
### JVM 运行时数据区 (JVM Runtime Area)
6个区域：
1、PC程序计数器：一块较小的内存空间，可以看做是当前线程所执行的字节码的行号指示器, NAMELY存储每个线程下一步将执行的JVM指令，如该方法为native的，则PC寄存器中不存储任何信息。Java 的多线程机制离不开程序计数器，每个线程都有一个自己的PC，以便完成不同线程上下文环境的切换。
2、java虚拟机栈：与 PC 一样，java 虚拟机栈也是线程私有的。每一个 JVM 线程都有自己的 java 虚拟机栈，这个栈与线程同时创建，它的生命周期与线程相同。虚拟机栈描述的是Java 方法执行的内存模型：每个方法被执行的时候都会同时创建一个栈帧（Stack Frame）用于存储局部变量表、操作数栈、动态链接、方法出口等信息。每一个方法被调用直至执行完成的过程就对应着一个栈
帧在虚拟机栈中从入栈到出栈的过程。
3、本地方法栈：与虚拟机栈的作用相似，虚拟机栈为虚拟机执行执行java方法服务，而本地方法栈则为虚拟机使用到的本地方法服务。
4、Java堆：被所有线程共享的一块存储区域，在虚拟机启动时创建，它是JVM用来存储对象实例以及数组值的区域，可以认为Java中所有通过new创建的对象的内存都在此分配。
Java堆在JVM启动的时候就被创建，堆中储存了各种对象，这些对象被自动管理内存系统（Automatic Storage Management System，也即是常说的 “Garbage Collector（垃圾回收器）”）所管理。这些对象无需、也无法显示地被销毁。
JVM将Heap分为两块：新生代New Generation和旧生代Old Generation
Note:
堆在JVM是所有线程共享的，因此在其上进行对象内存的分配均需要进行加锁，这也是new开销比较大的原因。
5、方法区
方法区和堆区域一样，是各个线程共享的内存区域，它用于存储每一个类的结构信息，例如运行时常量池，成员变量和方法数据，构造函数和普通函数的字节码内容，还包括一些在类、实例、接口初始化时用到的特殊方法。当开发人员在程序中通过Class对象中的getName、isInstance等方法获取信息时，这些数据都来自方法区。
方法区也是全局共享的，在虚拟机启动时候创建。在一定条件下它也会被GC。这块区域对应Permanent Generation 持久代。 XX：PermSize指定大小。
6、运行时常量池其空间从方法区中分配，存放的为类中固定的常量信息、方法和域的引用信息。

### 获得给定数字n的第i位
```
// 从右往左数第i位
public static int getBit(int num,int i){
        int result = num & (i-1<<1);
        return result > 0? 1:0;
    }
```
### 重写equals方法
1.使用==符号检查“参数是否为这个对象的引用”。如果是，则返回true。这只不过是一种性能优化，如果比较操作有可能很昂贵，就值得这么做。
2.使用instanceof操作符检查“参数是否为正确的类型”。如果不是，则返回false。一般来说，所谓“正确的类型”是指equals方法所在的那个类。
3.把参数转换成正确的类型。因为转换之前进行过instanceof测试，所以确保会成功。
4.对于该类中的每个“关键”域，检查参数中的域是否与该对象中对应的域相匹配。如果这些测试全部成功，则返回true;否则返回false。
5.当编写完成了equals方法之后，检查“对称性”、“传递性”、“一致性”。
### 重写hashCode方法意义？

 - 在每个覆盖了equals方法的类中，也必须覆盖hashCode方法。如果不这样做的话，就会违反hashCode的通用约定，从而导致该类无法结合所有基于散列的集合一起正常运作，这样的集合包括HashMap、HashSet和Hashtable。
 - 在应用程序的执行期间，只要对象的equals方法的比较操作所用到的信息没有被修改，那么对这同一个对象调用多次，hashCode方法都必须始终如一地返回同一个整数。在同一个应用程序的多次执行过程中，每次执行所返回的整数可以不一致。
 - 如果两个对象根据equals()方法比较是相等的，那么调用这两个对象中任意一个对象的hashCode方法都必须产生同样的整数结果。
 - 如果两个对象根据equals()方法比较是不相等的，那么调用这两个对象中任意一个对象的hashCode方法，则不一定要产生相同的整数结果。但是程序员应该知道，给不相等的对象产生截然不同的整数结果，有可能提高散列表的性能。

###hashCode()和equals()方法有何重要性？
HashMap使用Key对象的hashCode()和equals()方法去决定key-value对的索引。当我们试着从HashMap中获取值的时候，这些方法也会被用到。如果这些方法没有被正确地实现，在这种情况下，两个不同Key也许会产生相同的hashCode()和equals()输出，HashMap将会认为它们是相同的，然后覆盖它们，而非把它们存储到不同的地方。
同样的，所有不允许存储重复数据的集合类都使用hashCode()和equals()去查找重复，所以正确实现它们非常重要。equals()和hashCode()的实现应该遵循以下规则：
（1）如果o1.equals(o2)，那么o1.hashCode() == o2.hashCode()总是为true的。
（2）如果o1.hashCode() == o2.hashCode()，并不意味着o1.equals(o2)会为true。
### transient变量有什么特点?
答案：transient变量不会进行序列化。例如一个实现Serializable接口的类在序列化到ObjectStream的时候，transient类型的变量不会被写入流中，同时，反序列化回来的时候，对应变量的值为null。
### String和StringTokenizer的区别是什么？
答案：StringTokenizer是一个用来分割字符串的工具类。
```
StringTokenizer st = new StringTokenizer(”Hello World”);
// 根据delim分割字符串，false表示delim不参与输出
StringTokenizer st = new StringTokenizer("www.baidu.com", ".a", false);
while (st.hasMoreTokens()) {
    System.out.println(st.nextToken());
}
输出：
Hello
World
```
### HashMap和HashTable有何不同？
1.HashMap允许key和value为null，而HashTable不允许。
2.HashTable是同步的，而HashMap不是。所以HashMap适合单线程环境，HashTable适合多线程环境。
3.假如你想要遍历顺序，你很容易从HashMap转向LinkedHashMap，但是HashTable不是这样的，它的顺序是不可预知的。
4.HashMap提供对key的Set进行遍历，因此它是fail-fast的，但HashTable提供对key的Enumeration进行遍历，它不支持fail-fast。
5.HashTable被认为是个遗留的类，如果你寻求在迭代的时候修改Map，你应该使用CocurrentHashMap。
### fail-fast && fail-safe
Iterator的安全失败是基于对底层集合做拷贝，因此，它不受源集合上修改的影响。java.util包下面的所有的集合类都是快速失败的，而java.util.concurrent包下面的所有的类都是安全失败的。快速失败的迭代器会抛出ConcurrentModificationException异常，而安全失败的迭代器永远不会抛出这样的异常。

我们知道java.util.HashMap不是线程安全的，因此如果在使用迭代器的过程中有其他线程修改了map，那么将抛出ConcurrentModificationException，这就是所谓fail-fast策略。
   这一策略在源码中的实现是通过modCount域，modCount顾名思义就是修改次数，对HashMap内容的修改都将增加这个值，那么在迭代器初始化过程中会将这个值赋给迭代器的expectedModCount。
```
HashIterator() {
    expectedModCount = modCount;
    if (size > 0) { // advance to first entry
    Entry[] t = table;
    while (index < t.length && (next = t[index++]) == null)
        ;
    }
}
```
   在迭代过程中，判断modCount跟expectedModCount是否相等，如果不相等就表示已经有其他线程修改了Map：
   注意到modCount声明为volatile，保证线程之间修改的可见性。
### 保证集合不被修改
在作为参数传递之前，我们可以使用Collections.unmodifiableCollection(Collection c)方法创建一个只读集合，这将确保改变集合的任何操作都会抛出UnsupportedOperationException。
### final关键字
 - final修饰变量：
final修饰的变量只能被赋值一次，可以是在声明的时候进行初始化，也可以是在初始化函数中进行初始化，基本数据类型在赋值后它的值无法改变，如果是一个对象的引用则不能再指向其它对象，但是这个对象的值是可以改变的。比如一个指向StringBuilder的对象A，A不能再被赋值，但是这个StringBuilder对象的值是可以改变的。
 - final修饰的方法：
final修饰的方法不能被子类重写，Java编程思想中是这样说的：
使用final方法的原因有两个。第一个原因是把方法锁定，以防任何继承类修改它的含义；
 - final修饰的类：
final修饰的类不能被继承，也就是说它所有的实现都不能被改变，方法不能被重写。常用于设计一些不想让使用者改变的类。

### 单例适用场景
 - 控制资源的使用，通过线程同步来控制资源的并发访问
 - 控制实例的产生，以达到节约资源的目的
 - 控制数据共享，在不建立直接关联的条件下，让多个不相关的进程或线程之间实现通信

### 堆内存三部分（新生代、老年代、永久代）
1.新生代，新生区是类的诞生、成长、消亡的区域，一个类在这里产生、应用，最后被垃圾回收器收集，结束生命。新生区又分为两部分：伊甸区和幸存者区，
所有的类都是在伊甸区被创建的，幸存区有两个：0区（Survivor 0）和1区(Survivor 1)。当伊甸区的空间用完，程序又需要创建对象，JVM的垃圾回收器将
对伊甸区进行垃圾回收，将伊甸区中的不再被其他对象所引用的对象进行销毁。然后将伊甸区中的剩余对象移动到幸存0区，若幸存0区也满了，再对该区进行
垃圾回收，然后移动到1区，如果1区也满了，就移动到老年区。
2.老年代，用于保存从新生区筛选出来的java对象，一般池对象都在这个区域活跃。
3.永久代 永久存储区是一个常驻内存区域，用于存放JDK自身所携带的Class Interface 的元数据，也就是说，它存储的是运行环境必须的类信息，被装载进此区域的数据是不会被回收器回收的，关闭JVM才会释放此区域所占用的内存。
![java垃圾回收之新生代老年代永久代][1]
### 内存泄漏
由于疏忽或错误造成程序未能释放已经不再使用的内存，失去了对该段内存的控制，造成内存浪费。
### 垃圾收集算法
1.标记-清除算法
首先标记出所有需要回收的对象，在标完成后统一回收掉所有被标记的对象。缺点：效率不高，且标记清除之后会产生大量不连续的内存碎片，空间碎片太多可能会导致运行过程中需要分配大对象的时候无法找到足够的连续内存而不得不提前触发另一次垃圾收集动作
2.复制算法
将可用内存按容量划分为大小相等的两块，每次只使用其中一块。当这一块内存用完了，就将还存活着的对象复制到另外一块上面，然后再把已经使用过的内存空间一次清理掉，内存使用率不高，现在商业虚拟机比如HotSpot都采用8:1的比例（Eden:Survivor）
3.标记-整理算法
把存活对象往内存的一端移动，然后直接回收边界以外的内存，提高了内存利用率，适合在收集对象存活时间较长的老年代。
4.分代收集算法
根据对象的存活时间把内存分为新生代和老年代，根据各代对象的存活特点，每个代采用不同的垃圾回收算法，新生代采用标记-复制算法，老年代采用标记-整理算法。




