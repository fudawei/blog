title: 面试题
tags: [面试]
categories: [面试]
date: 2014-03-02 22:15:53
---


判断一块内存空间是否符合垃圾收集器标准是：
1. 给对象赋予了控制null，以后再也没掉用过
2. 给对象赋予了新值，即重新分配了内存空间
### Object 基类方法包含
clone()  创建并返回对象的一个副本
equals()  notify()  notifyAll()   wait()  toString()
finalize()   当垃圾回收器确定不存在对该对象的更多引用时，由对象的垃圾回收器调用此方法
hashCode()   返回该对象的哈希值

### 不通过构造函数能创建对象吗？
1.用new语句创建
2.运用反射，调用java.lang.Class 或者  java.lang.reflect.ConStruct 类的newInstance()实例方法
3.调用对象的clone() 方法
4.运用反序列手段，调用java.io.ObjectInputStream 对象的readObject() 方法



### 有哪几种存储结构？
1.随机存取。可以任意存取任意一个元素
2.顺序存取。只能从前到后逐个访问，比如链表结构
3.索引存取。索引存取是为某个关键字建立索引表，从所有的表中得到地址，在直接访问
4.散列存取。建立散列表，根据key计算出存储位置，相当于一种索引


百度或淘宝搜索时，出现搜索建议，采用什么数据结构实现？
字典树，是一种噶洗漱的变种，一种用于快速检索的多叉树结构。用于统计和排序大量的字符串，经常被搜索引擎用于文本词频
统计。核心思想是空间换时间。利用该字符串的公共前缀来降低查询时间的开销以达到提高效率的目的。



String s = "a"+"b"+"c"+"d"+"e"  产生了一个对象，因为赋值符号右边的字母都是常量，对于常量，编译时就直接存储他们
的字面值，而不是他们的引用。在编译时就把他们连接的结果提取出来变成了"abcde"
new String("jinder") 实际创建了2个对象，一个是"jinder"通过""双引号创建的，另一个是通过new创建的，只不过他们创建
的时期不同，一个是编译期，一个是运行期。
运行期调用String类型的intern()方法可以向StringPool中动态添加对象

简述 synchronized 和 java.util.concurrent.locks.Lock 的异同？
Lock 能完成synchronized所实现的所有功能。主要不同点是，Lock 有比synchronized更精确的线程语义和更好的性能。synchronized
会自动释放锁，而Lock一定要求程序员手工释放，并且必须在finally从句中释放。

只要当前JVM实例尚存在任何一个非守护线程没有结束，守护线程就全部工作;只有当最后一个非守护线程结束时，守护线程随着JVM一同
结束任务。守护线程最典型的应用就是GC。

### 存储过程和函数的区别是什么？
存储过程是用户定义的一系列SQL语句的集合，设计特定表或其他对象的任务，用户可以调用存储过程，而函数通常是数据库已经定义的
方法，它接受参数并返回某种类型的值，而且不涉及特定用户表。
游标作用是什么？怎样判断游标到了最后？
游标用来定位结果集中的行，通过判断@@FETCH_STATUS，可以判断游标是否到了最后，通常此变量不等于0表示出错或者到了最后。
行级触发器在所影响的每一行触发一次。
### 数据库查询优化
执行数据库查询时，如果要查询的数据有很多，假设1000万，用什么办法可以提高查询效率？在数据库方面或java代码方面优化 ？
1.在数据库方面
建立索引   分区（MySQL，比如按时间分区）   尽量使用固定长度的字段    限制字段长度
2.在数据库 I/O 方面
增加缓冲区    如果涉及表的级联，不同的表存储在不同的磁盘上，以增加IO速度
3.在SQL方面
优化sql语句，减少比较次数     限制返回的条目数（MySQL 里面用limit）
4.在java方面
对于反复查询使用的查询，使用PreparedStatement 减少查询次数

unique 约束能够约束一列保证该列值唯一，但允许有空值
### NAT技术
NAT 技术（网络地址转换）是一种将一个IP地址域映射到另一个IP地址域的技术，从而为终端主机提供透明路由。NAT 包括静态网络地址
转换、动态网络地址转换、端口映射等。NAT 常用语私有地址域与工友地址的转换，解决IP地址匮乏的问题、在防火墙上实现了NAT以后
可以隐藏受保护网络的内部拓扑结构，在一定程度上提高网络的安全性。
### IP 地址分配
A 类地址 １-127      0
B 类地址 128 - 191   10
C 类地址 192-223     110
FTP 是有连接的服务，必须基于TCP协议

### TCP 的三次握手
第一次握手：建立连接时，客户端发送SYN包到服务器，并进入SYN_SEND状态，等待服务器确认。
第二次握手：服务器收到SYN包，必须确认客户的SYN（ack=j+1），同时自己也发送一个SYN包（SYN=k），即SYN+ACK包，此时服务器
进入SYN_RECV状态。
第三次握手：客户端收到服务器的SYN+ACK包，向服务器发送确认宝ACK（ack=k+1）,此包发送完毕，客户端和服务器进入ESTABLISHED
状态，完成三次握手。
完成三次握手后，客户端和服务器开始传送数据。
未连接队列：在三次握手协议中，服务器维护一个未连接队列，该队列未每个客户端的SYN包开设一个条目，该条目表明服务器已收到SYN
包，并向客户发出确认，正在等待客户的确认包。这些条目所标识的连接在服务器处于SYN_RECV状态，当服务器收到客户端的确认包，
删除该条目，服务器进入ESTABLISHED状态。

### ping命令基于什么协议？
ICMP Internet 控制消息协议是TCP/IP 协议族的一个自协议，用于在IP主机、路由器之间传递控制消息，控制消息是指网路通不通，
主机是否可达，路由是否可用等网络本身的消息。ping命令向指定的IP地址发送一定长度的数据包，按照约定，若指定的IP存在的话，
会返回同样大小的数据包，若在特定的时间没有返回，超时，则认为IP不存在。

子网掩码是用来判断任意两台计算机的IP地址是否属于同一子网络的根据。两台计算机各自的IP地址域子网掩码进行AND运算之后，
如果得出的结果是相同的额，则说明两台计算机是处于同一个子网络的，可以进行直接的通信。

### 什么是迭代器(Iterator)？
Iterator 接口提供了很多对集合元素进行迭代的方法。每一个集合类都包含了可以返回迭代器实例的迭代方法。迭代器可以在迭代的
过程中删除底层集合的元素,但是不可以直接调用集合的remove(Object Obj)删除，可以通过迭代器的remove()方法删除。
如何确保N个线程可以访问N个资源同时又不导致死锁？
指定获取锁的顺序，并强制线程按照指定的顺序获取锁。
### 在监视器(Monitor)内部，是如何做线程同步的？
监视器和锁在Java虚拟机中是一块使用的。监视器监视一块同步代码块，确保一次只有一个线程执行同步代码块。每一个监视器都和一个
对象引用相关联。线程在获取锁之前不允许执行同步代码。
### 同步方法和同步代码块的区别？
同步方法默认用this或者当前类class对象作为锁；
同步代码块可以选择以什么来加锁，比同步方法要更细颗粒度，我们可以选择只同步会发生同步问题的部分代码而不是整个方法；

应用程序可以使用Executor框架来创建线程池 (创建线程的方式还有 继承Thread类，实现Runnable接口 )
### 重载和重写
重载发生在同一个类里面，多个方法名相同但是形参列表不同的情况，返回类型可以相同也可以不同。
重写发生在父类子类里面，子类重新定义了父类方法，方法重写（覆盖）必须有相同的方法名、形参列表和返回类型。
### 接口和抽象类的区别是什么？
Java 提供和支持创建抽象类和接口。它们的实现有共同点，不同点在于：
接口中所有的方法隐含的都是抽象的。而抽象类则可以同时包含抽象和非抽象的方法。
类可以实现很多个接口，但是只能继承一个抽象类
类可以不实现抽象类和接口声明的所有方法，当然，在这种情况下，类也必须得声明成是抽象的。
抽象类可以在不提供接口方法实现的情况下实现接口。
Java 接口中声明的变量默认都是final的。抽象类可以包含非final的变量。
Java 接口中的成员函数默认是public的。抽象类的成员函数可以是private，protected或者是public。
接口是绝对抽象的，不可以被实例化。抽象类也不可以被实例化，但是，如果它包含main方法的话是可以被调用的。
也可以参考JDK8中抽象类和接口的区别

### HashMap和Hashtable区别？
HashMap和Hashtable都实现了Map接口，因此很多特性非常相似。但是，他们有以下不同点：
HashMap允许键和值是null，而Hashtable不允许键或者值是null。
Hashtable是同步的，而HashMap不是。因此，HashMap更适合于单线程环境，而Hashtable适合于多线程环境。

### Java中的HashMap的工作原理？
Java中的HashMap是以键值对(key-value)的形式存储元素的。HashMap需要一个hash函数，它使用hashCode()和equals()方法来向集合
/从集合添加和检索元素。当调用put()方法的时候，HashMap会计算key的hash值，然后把键值对存储在集合中合适的索引上。如果key
已经存在了，value会被更新成新值;若计算出来的索引位置相同，形成Entry链。

快速失败(fail-fast)和安全失败(fail-safe)的区别是什么？
Iterator的安全失败是基于对底层集合做拷贝，因此，它不受源集合上修改的影响。java.util包下面的所有的集合类都是快速失败的，
而java.util.concurrent包下面的所有的类都是安全失败的。快速失败的迭代器会抛出ConcurrentModificationException异常，而安全
失败的迭代器永远不会抛出这样的异常。

### ArrayList和LinkedList区别？
ArrayList和LinkedList都实现了List接口，他们有以下的不同点：
ArrayList是基于索引的数据接口，它的底层是数组。它可以以O(1)时间复杂度对元素进行随机访问。与此对应，LinkedList是以元素列表的形式存储它的数据，每一个元素都和它的前一个和后一个元素链接在一起，在这种情况下，查找某个元素的时间复杂度是O(n)。
相对于ArrayList，LinkedList的插入，添加，删除操作速度更快，因为当元素被添加到集合任意位置的时候，不需要像数组那样重新计算大小或者是更新索引。
LinkedList比ArrayList更占内存，因为LinkedList为每一个节点存储了两个引用，一个指向前一个元素，一个指向下一个元素。

### Array和ArrayList区别？
Array可以包含基本类型和对象类型，ArrayList只能包含对象类型。
Array大小是固定的，ArrayList的大小是动态变化的。
ArrayList提供了更多的方法和特性，比如：addAll()，removeAll()，iterator()等等。

### Iterator和ListIterator的区别？
Iterator可用来遍历Set和List集合，但是ListIterator只能用来遍历List。
Iterator对集合只能是前向遍历，ListIterator既可以前向也可以后向。
ListIterator实现了Iterator接口，并包含其他的功能，比如：增加元素，替换元素，获取前一个和后一个元素的索引

### Comparable和Comparator接口
Java提供了只包含一个compareTo()方法的Comparable接口。这个方法可以个给两个对象排序。
Java提供了包含compare()和equals()两个方法的Comparator接口。compare()方法用来给两个输入参数排序。

### Java优先级队列(Priority Queue)？
PriorityQueue是一个基于优先级堆的无界队列，它的元素是按照自然顺序(natural order)排序的。在创建的时候，我们可以给它提供
一个负责给元素排序的比较器。PriorityQueue不允许null值，因为他们没有自然顺序，或者说他们没有任何的相关联的比较器。最后，
riorityQueue不是线程安全的，入队和出队的时间复杂度是O(log(n))。

什么时候使用CallableStatement？用来准备CallableStatement的方法是什么？
CallableStatement用来执行存储过程。存储过程是由数据库存储和提供的。存储过程可以接受输入参数，也可以有返回结果。非常鼓励
用存储过程，因为它提供了安全性和模块化。准备一个CallableStatement的方法是：CallableStament.prepareCall();

PreparedStatement比Statement有什么优势？
PreparedStatements是预编译的，因此，性能会更好。同时，不同的查询参数值，PreparedStatement可以重用。

### URL编码和URL解码？
URL编码是负责把URL里面的空格和其他的特殊字符替换成对应的十六进制表示，反之就是解码。

### doGet()方法和doPost()方法区别？
doGet: GET 方法会把键值对追加在请求的URL后面。因为URL对字符数目有限制， 限制了用在客户端请求的参数值的数目。并且请求中
的参数值是可见的 ，不够安全。
doPOST：POST方法通过把请求参数值放在请求体中来克服GET方法的限制，因此，可以发送的参数的数目是没有限制的。
最后，通过POST请求传递的敏感信息对外部客户端是不可见的。

### 解释下Servlet的生命周期。
对每一个客户端的请求，Servlet引擎 载入Servlet，调用它的init()方法，完成Servlet的初始化。然后，Servlet 对象通过为每一个
请求单独调用service()方法来处理所有随后来自客户端的请求，最后，调用Servlet的destroy()方法把Servlet卸载掉。

### 什么是Servlet？
Servlet 是用来处理客户端请求并产生动态网页内容的Java类。Servlet 主要是用来处理或者是存储HTML表单提交的数据，产生动态内容

### 什么是反射？
Java 程序可以加载一个运行时才得知名称的 class，获悉其完整构造（但不包括methods定义），并生成其对象实体、
或对其fields设值、或唤起其methods。

### 匿名内部类的变量必须final修饰？
首先内部类的生命周期是成员级别的，而局部变量的生命周期是在方法体之类，当mRun方法执行，new
的线程运行，新线程里面会睡一秒。主线程会继续执行，mRun执行完毕，name属性生命周期结束，Java就是为了杜绝这种错误，严格要求
内部类中方位局部变量，必须使用final关键字修饰。局部变量被final修饰之后，此时会在内存中保有一份局部变得的复制品，当内部类
访问的时候其实访问的是这个复制品。

### 小知识
```
	@Test
	public void test() {
		Integer a = new Integer(1000) ; int b = 1000;
		Integer c = new Integer(10); Integer d = new Integer(10);
		System.out.println(a == b);    //true   自动拆箱为int
		System.out.println(c == d);    //false
	}
	//Integer.java valueOf 方法中把-128-127 缓存了下来。官方解释是小的数字使用的频率比较高， 为了优化性能，把这之间的数缓存了下来
	@Test
	public void testInteger(){
		Integer a = 1000,b=1000;
		Integer c = 100,d=100;
		System.out.println(a==b);   //false  new出来的
		System.out.println(c==d);   //true   缓存中的
	}
```
[reference] http://www.imooc.com/article/2964
### 调用三种方式
模块之间都存在一定的调用关系，从调用方式上看，可以分为三类同步调用、异步调用和回调。同步调用是一种阻塞式调用，异步调用是一种
类似消息或事件的机制解决了同步阻塞的问题，回调是一种双向的调用模式，也就是说，被调用的接口被调用时也会调用对方的接口，例如A
要调用B,B在执行完又要调用A。
public interface FileNameFilter{
	boolean accept(File dir,String name);
}
### 标记接口
如果实现接口的类是抽象类，那么就没必要实现该接口的方法。
一个接口能继承另一个接口，这和类之间的继承比较相似。也就是说实现某一个接口之后，可能要实现的方法不是直接接口定义的方法，
可能是该接口继承于另外一个接口的方法。
没有任何方法的接口被称为标记接口。标记接口主要用于以下两种目的：
1.建立一个公共的父接口
2.向一个类添加数据类型
### SQL三范式
SQL语言支持关系数据库的三级模式结构，其中，视图对应外模式，基本表对应模式，存储文件对应内模式。
通过分解，可以将一个低一级别的关系模式转换成若干个高一级范式的关系模式，这种过程叫做规范化。
eg: FIRST(Sno,Sname,Status,City,Pno,Qty)
依赖关系： F={ Sno-> Sname,Sno->Status,Status->City,(Sno,Pno)->Qty}
* 1NF(第一范式)
定义：若关系模式R的每一个分量是不可再分的数据项，则关系模式R属于第一范式
FIRST属于第一范式，但1NF存在4个问题：
冗余度大，每个Sno,Sname,Status,City 要与其供应的零件的种类一样多
引起修改操作的不一致性
插入异常，若某个供应者某些信息没有提供(比如没有Pno)则不能进行插入操作
* 2NF(第二范式)
定义：若关系模式R属于1NF,且每一个非主属性完全依赖于码，则关系模式R属于2NF
也就是说，当1NF消除了非主属性对码的部分函数依赖，则成为2NF
将FIRST分解为 FIRST1(Sno,Sname,Status,City) 和 FIRST2(Sno,Pno,Qty) 分解后，FIRST1 的 非主属性 Sname,Status,City 完全依赖
于码 Sno,FIRST2的非主属性 Qty 完全依赖于码 Sno,Pno,所以属于2NF
* 3NF(第三范式)
若关系模式中不存在这样的码X，属性组Y以及非主属性Z，使得X->Y,Y-Z成立，则关系模式R属于3NF
即当2NF消除了非主属性对码的传递函数依赖，则成为3NF
分解为 FIRST1(Sno,Sname,Status)  FIRST2(Status,City)   FIRST3(Sno,Pno,Qty)
3NF的模式肯定是2NF,产生冗余和异常的两个重要原因是部分依赖和传递依赖，因为3NF模式中不存在非主属性对码的部分函数依赖和
传递函数依赖，所以具有较高的性能，通常变换为3NF或更高级别的凡是，这种变化过程成为“关系模式的规范化处理”
### Webservice
W  ebService是一种跨编程语言和跨操作系统平台的远程调用技术。
远程调用，就是一台计算机a上的一个程序可以调用到另外一台计算机b上的一个对象的方法，譬如，银联提供给商场的pos刷卡系统，
商场的POS机转账调用的转账方法的代码其实是跑在银行服务器上。再比如，amazon，天气预报系统，淘宝网，校内网，百度等把自己的
系统服务以webservice服务的形式暴露出来，让第三方网站和程序可以调用这些服务功能，这样扩展了自己系统的市场占有率，就是
所谓的SOA应用。
   WebService是建立可互操作的分布式应用程序的新平台，是一个平台，是一套标准。它定义了应用程序如何在Web上实现互操作性
Web service平台必须提供一种标准来描述Web service，让客户可以得到足够的信息来调用这个Web service
XML+XSD,SOAP和WSDL就是构成WebService平台的三大技术。
WebService采用HTTP协议传输数据，采用XML格式封装数据（即XML中说明调用远程服务对象的哪个方法，传递的参数是什么，以及服务
对象的返回结果是什么）。XML是WebService平台中表示数据的格式。
SOAP协议 = HTTP协议 + XML数据格式
WSDL(Web Services Description Language)就是这样一个基于XML的语言，用于描述Web Service及其函数、参数和返回值。
它是WebService客户端和服务器端都能理解的标准格式。
### Java String.split()用法
String.split("\\.") //用 . 分割字符串
acount=?and uu =? or n=?”,把三个都分隔出来可以用String.split("and|or"); //分割多个

需要在程序中存储许多字符串常量，所以就想到了枚举
### 获取用户IP
public static String getIpAddr(HttpServletRequest request) {
        String ip = request.getHeader("x-forwarded-for");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }












