---
title: Java内存区域与内存溢出
date: 2014-07-15 21:22:45
tags: [内存模型]
categories: [Java,内存模型]
---


### Java内存区域###

<center>![](http://o99dg8ap9.bkt.clouddn.com/Java%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E4%B8%8E%E5%86%85%E5%AD%98%E6%BA%A2%E5%87%BA.png)</center>
<!-- more -->

### 程序计数器###

- 当前线程所执行的字节码的行号指示器

- 当前线程私有

- 不会出现OutOfMemoryError情况


### java虚拟机栈###

- 线程私有，生命周期与线程相同

- java方法执行的内存模型，每个方法执行的同时都会创建一个栈帧，存储局部变量表(基本类型、对象引用)、操作数栈、动态链接、方法出口等信息

- 在编译程序代码时，栈帧中需要多大的局部变量表、多深的操作数栈都已经完全确定了，并且写入了方法表的Code属性之中。因此，一个栈帧需要分配多少内存，不会受到程序运行期变量数据的影响，而仅仅取决于具体的虚拟机实现

- StackOverflowError异常：当线程请求的栈深度大于虚拟机所允许的深度

- OutOfMemoryError异常：如果栈的扩展时无法申请到足够的内存


#### 局部变量表####

-   局部变量表是一组变量值存储空间，用于存放方法参数和方法内部定义的局部变量

- 存放的数据的类型是编译期可知的各种基本数据类型、对象引用（reference）和returnAddress类型（它指向了一条字节码指令的地址）

- 局部变量表所需的内存空间在编译期间完成分配，即在Java程序被编译成Class文件时，就确定了所需分配的最大局部变量表的容量

- 当进入一个方法时，这个方法需要在栈中分配多大的局部变量空间是完全确定的，在方法运行期间不会改变局部变量表的大小

#### 操作数栈####

- 操作数栈又称为操作栈 

- 操作数栈的最大深度在编译的时候确定

- Java虚拟机的解释执行引擎称为“基于栈的执行引擎”，其中所指的“栈”就是操作数栈。因此我们也称Java虚拟机是基于栈的，这点不同于Android虚拟机，Android虚拟机是基于寄存器的

- 基于栈的指令集最主要的优点是可移植性强，主要的缺点是执行速度相对会慢些；而由于寄存器由硬件直接提供，所以基于寄存器指令集最主要的优点是执行速度快，主要的缺点是可移植性差

#### 动态连接####

- 每个栈帧都包含一个指向运行时常量池（在方法区中，后面介绍）中该栈帧所属方法的引用，持有这个引用是为了支持方法调用过程中的动态连接。Class文件的常量池中存在有大量的符号引用，字节码中的方法调用指令就以常量池中指向方法的符号引用为参数。这些符号引用，一部分会在类加载阶段或第一次使用的时候转化为直接引用（如final、static域等），称为静态解析，另一部分将在每一次的运行期间转化为直接引用，这部分称为动态连接

#### 方法返回地址####

- 当一个方法被执行后，有两种方式退出该方法：执行引擎遇到了任意一个方法返回的字节码指令或遇到了异常，并且该异常没有在方法体内得到处理。无论采用何种退出方式，在方法退出之后，都需要返回到方法被调用的位置，程序才能继续执行。方法返回时可能需要在栈帧中保存一些信息，用来帮助恢复它的上层方法的执行状态。一般来说，方法正常退出时，调用者的PC计数器的值就可以作为返回地址，栈帧中很可能保存了这个计数器值，而方法异常退出时，返回地址是要通过异常处理器来确定的，栈帧中一般不会保存这部分信息


- 方法退出的过程实际上等同于把当前栈帧出站，因此退出时可能执行的操作有：恢复上层方法的局部变量表和操作数栈，如果有返回值，则把它压入调用者栈帧的操作数栈中，调整PC计数器的值以指向方法调用指令后面的一条指令

### 本地方法栈###

- 与虚拟机栈相似，主要为虚拟机使用到的Native方法服务，在HotSpot虚拟机中直接把本地方法栈与虚拟机栈二合一

### Java堆(Java Heap)###

- Java Heap是Java虚拟机所管理的内存中最大的一块，它是所有线程共享的一块内存区域

- 几乎所有的对象实例和数组都在这类分配内存 

- Java Heap是垃圾收集器管理的主要区域，因此很多时候也被称为“GC堆” 

- Java堆只要求在逻辑上是连续的

- 在虚拟机启动时创建

- OutOfMemoryError异常：当在堆中没有内存完成实例分配，且堆也无法再扩展时


### 方法区###

- 线程间共享

- 用于存储已被虚拟机加载的类信息、常量、静态变量、即时编译器编译后的代码等数据

- OutOfMemoryError异常：当方法区无法满足内存的分配需求时


### 运行时常量池###

- 方法区的一部分

- 用于存放编译期生成的各种字面量与符号引用

- OutOfMemoryError异常：当常量池无法再申请到内存时


### 直接内存###

- NIO可以使用Native函数库直接分配堆外内存，堆中的DirectByteBuffer对象作为这块内存的引用进行操作

- 大小不受Java堆大小的限制，受本机(服务器)内存限制

- OutOfMemoryError异常：系统内存不足时


### HotSpot虚拟机###


#### 对象的创建####

虚拟机遇到一条new指令时，首先将去检查这个对象的参数是否在常量池中定位到一个类的符号引用，并且检查这个符号引用代表的类是否已被加载、解析和初始化过。如果没有，必须先执行类的加载过程。
在类加载检查通过后，虚拟机将为新生对象分配内存。对象所需内存大小再类加载完成后便可确定。内存分配可以采用“指针碰撞”与“空闲列表”的方式


#### 对象的访问定位####

java程序需要通过栈上的reference数据来操作堆上的具体对象。访问方式有使用句柄和直接指针两种。

- 句柄访问 java堆中将会划分出一块内存来作为句柄池，reference中存储的就是对象的句柄地址，而句柄中包含了对象实例数据与类型数据各自的具体地址信息

![](http://o99dg8ap9.bkt.clouddn.com/Java%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E4%B8%8E%E5%86%85%E5%AD%98%E6%BA%A2%E5%87%BAvern%E9%80%9A%E8%BF%87%E5%8F%A5%E6%9F%84%E8%AE%BF%E9%97%AE%E5%AF%B9%E8%B1%A1.jpg)

- 直接指针访问 java堆对象的布局中必须考虑如何放置访问类型数据的相关信息，reference中存储的就是对象地址

![](http://o99dg8ap9.bkt.clouddn.com/Java%E5%86%85%E5%AD%98%E5%8C%BA%E5%9F%9F%E4%B8%8E%E5%86%85%E5%AD%98%E6%BA%A2%E5%87%BAvern%E9%80%9A%E8%BF%87%E7%9B%B4%E6%8E%A5%E6%8C%87%E9%92%88%E8%AE%BF%E9%97%AE%E5%AF%B9%E8%B1%A1.jpg)


#### 两种访问方式的比较####

- 使用句柄访问最大的好处是reference中存储的是稳定的句柄地址，在对象被移动（GC时移动对象是很普遍的行为）时只会改变句柄中的实例数据指针，而reference本身不需要修改

- 使用直接指针访问方式的最大好处是速度更快，它节省了一次指针定位的时间开销，由于对象访问在Java中非常频繁，因此这类开销积少成多后也是一项非常可观的执行成本

- HotSpot虚拟机采用指针访问方式进行对象访问，从整个软件开发范围看，各种语言和框架使用句柄来访问的情况也非常常见



### 内存溢出测试方法###

| 内存区域 | 内存溢出的测试方法|
| ---------|:------------------|
| Java堆| 无限循环地new对象出来，在List中保存引用，以不被垃圾收集器回收。另外，该区域也有可能发生内存泄露（Memory Leak），出现问题时，要注意区别|
| 方法区 | 生成大量的动态类，或无线循环调用String的intern()方法产生不同的String对象实例，并在List中保存其引用，以不被垃圾收集器回收。后者测试常量池，前者测试方法区的非常量池部分
| 虚拟机栈和本地方法栈| 单线程：递归调用一个简单的方法（如不断累积的方法）会抛出StackOverError <br><br>多线程：无限循环地创建线程，并为每个线程无限循环地增加内存，会抛出OutOfMemoryError


-  这里有一点要重点说明，在多线程情况下，给每个线程的栈分配的内存越大，反而越容易产生内存溢出异常


### OutOfMemoryError异常实例###

- 内存泄露，对象已经死了，无法通过垃圾收集器进行自动回收，通过找出泄露的代码位置和原因，才好确定解决方案

- 内存溢出，内存中的对象都还必须存活着，这说明Java堆分配空间不足，检查堆设置大小（-Xmx与-Xms），检查代码是否存在对象生命周期太长、持有状态时间过长的情况

#### Java堆溢出####

- Java堆用于存储对象实例，我们只要不断创建对象，并且保证GC Roots到对象之间有可达路径来避免GC清除这些对象，就会在对象数量到达最大堆的容量限制后产生内存溢出异常

- VM Args: -Xms10m -Xmx10m
- -XX:+HeapDumpOnOutOfMemoryError

- XX:+HeapDumpOnOutOfMemoryError这个参数可以让虚拟机在出现内存溢出异常时Dump出当前的内存堆转储快照以便事后进行分析。

```java
import java.util.ArrayList; 
import java.util.List; 
/**
 * VM Args: -Xms10m -Xmx10m -XX:+HeapDumpOnOutOfMemoryError
 */ 
public class HeapOOM { 
    static class OOMObject{ 
        private String name; 
        public OOMObject(String name) { 
            this.name = name; 
        } 
    } 
    public static void main(String[] args) { 
        List<OOMObject> list = new ArrayList<OOMObject>(); 
        long i = 1; 
        while(true) { 
            list.add(new OOMObject("IpConfig..." + i++)); 
        } 
    } 
}
```

- 抛出的异常：

> Dumping heap to java_pid27828.hprof ...
Heap dump file created [14123367 bytes in 0.187 secs]
Exception in thread "main" java.lang.OutOfMemoryError: Java heap space
at java.lang.AbstractStringBuilder.&lt;init&gt;(AbstractStringBuilder.java:45)
at java.lang.StringBuilder.&lt;init&gt;(StringBuilder.java:92)
at com.baoxian.HeapOOM.main(HeapOOM.java:22)

注：出现Java堆内存溢出时，异常堆栈信息java.lang.OutOfMemoryError后面会紧跟着JavaHeapSpace。

要解决这个异常，一般手段是首先通过内存映像分析工具比如Eclipse Memory Analyzer对dump出来的堆转储快照进行分析，重点是确认内存中对象是否是必要的，也就是要弄清楚到底是出现了内存泄露Memory Leak还是内存溢出Memory Overflow。

如果是内存泄露，可进一步通过工具查看泄露对象到GC Roots的引用链。于是就能找到泄露对象时通过怎样的路径与GC Roots相关联并导致垃圾收集器无法自动回收它们。掌握了泄露对象的类型信息，以及GC Roots引用链的信息，就可以比较准确的定位出泄露代码的位置了。

如果不存在泄露，那么就该修改-Xms和-Xms堆参数看能否加大点。

#### 虚拟机栈和本地方法栈溢出####

- -Xoss参数设置本地方法栈大小，对于HotSpot没用。栈容量只由-Xss参数设定

```java
/**
 * VM Args: -Xss128k
 * @author Administrator
 *
 */ 
public class JavaVMStackSOF { 
    private int stackLength = 1; 
    public void stackLeak() { 
        stackLength++; 
        stackLeak(); 
    } 
    public static void main(String[] args) throws Throwable{ 
        JavaVMStackSOF oom = new JavaVMStackSOF(); 
        try { 
            oom.stackLeak(); 
        } catch (Throwable e) { 
            System.out.println("stack length: " + oom.stackLength); 
            throw e; 
        } 
    } 
}
```

- 抛出异常：

> stack length: 1007
Exception in thread "main" java.lang.StackOverflowError
at com.baoxian.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:11)
at com.baoxian.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:12)
at com.baoxian.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:12)
at com.baoxian.JavaVMStackSOF.stackLeak(JavaVMStackSOF.java:12)

#### 运行时常量池溢出####

- 运行时常量池分配在方法区内，可以通过-XX:PermSize和-XX:MaxPermSize限制方法区大小，从而间接限制其中常量池的容量。

```java
import java.util.ArrayList; 
import java.util.List; 
/**
 * VM Args: -XX:PermSize=10M -XX:MaxPermSize=10M
 */ 
public class RuntimeConstantPoolOOM { 
    public static void main(String[] args) { 
        // 使用List保持着常量池引用，避免Full GC回收常量池行为 
        List<String> list = new ArrayList<String>;(); 
        // 10MB的PermSize在integer范围内足够产生OOM了 
        int i = 0; 
        while (true) { 
            list.add(String.valueOf(i++).intern()); 
        } 
    } 
}
```

- 异常：

> Exception in thread "main" java.lang.OutOfMemoryError: PermGen space
at java.lang.String.intern(Native Method)
at com.baoxian.RuntimeConstantPoolOOM.main(RuntimeConstantPoolOOM.java:18)

- 运行时常量池溢出，在java.lang.OutOfMemoryError后面紧跟着是PermGen space

#### 方法区溢出####

- 方法区用于存放Class的相关信息，如类名、访问修饰符、常量池、字段描述符、方法描述等。对于这个区域的测试，基本的思路是运行时产生大量的类去填满方法区，直到溢出。比如动态代理会生成动态类

- 使用CGLib技术直接操作字节码运行，生成大量的动态类。当前很多主流框架如Spring和Hibernate对类进行增强都会使用CGLib这类字节码技术，增强的类越多，就需要越大的方法区来保证动态生成的Class可以加载入内存

- 异常：

> Exception in thread "main" java.lang.OutOfMemoryError: PermGen space at java.lang.String.intern(Native Method)

- 同样，跟常量池一样，都是PermGen space字符串出现

- 方法区溢出也是一种常见的内存溢出异常，一个类如果要被垃圾收集器回收，判定条件是非常苛刻的。在经常动态生成大量Class的应用中，需要特别注意类的回收状况。这类场景除了上面提到的程序使用GCLib字节码技术外，常见的还有：大量JSP或动态产生的JSP文件的应用（JSP第一次运行时需要编译为Java类）、基于OSGi应用等

#### 本机直接内存溢出####

- DirectMemory容量可以通过-XX:MaxDirectMemorySize指定，如果不指定，则默认与Java堆的最大值-Xmx指定一样。
```java
/**
 * VM Args: -Xmx20M -XX:MaxDirectMemorySize=10M
 */ 
public class DirectMemoryOOM { 
    private static final int _1MB = 1024 * 1024; 
    public static void main(String[] args) { 
        Field unsafeField = Unsafe.class.getDeclaredFields()[0]; 
        unsafeField.setAccessible(true); 
        Unsafe unsafe = (Unsafe) unsafeField.get(null); 
        while(true) { 
            unsafe.allocateMemory(_1MB); 
        } 
    } 
}
```

- 在OutOfMemoryError后面不会有任何东西了，这就是DirectMemory内存溢出了

### Java中获取JVM内存使用情况###
```java
import java.text.DecimalFormat;
 
public class Test{
 
/**
* 显示JVM总内存，JVM最大内存和总空闲内存
*/
public void displayAvailableMemory() {
 
DecimalFormat df = new DecimalFormat(“0.00″) ;
 
//显示JVM总内存
long totalMem = Runtime.getRuntime().totalMemory();
 
System.out.println(df.format(totalMem 1000000F) + ” MB”);
 
//显示JVM尝试使用的最大内存
long maxMem = Runtime.getRuntime().maxMemory();
System.out.println(df.format(maxMem 1000000F) + ” MB”);
 
//空闲内存
long freeMem = Runtime.getRuntime().freeMemory();
System.out.println(df.format(freeMem 1000000F) + ” MB”);
 
}
 
/**
* Starts the program
* @param args the command line arguments
*/
public static void main(String[] args) {
new Main().displayAvailableMemory();
}
}
```
