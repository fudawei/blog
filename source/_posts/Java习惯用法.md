title: Java习惯用法
date: 2013-02-08 22:46:59
categories: [Java,Java基础]
tags: [Java基础]
---

## java习惯用法

### 实现equals()

```
class Person {
  String name;
  int birthYear;
  byte[] raw;
  public boolean equals(Object obj) {

    if (!obj instanceof Person)
      return false;
    Person other = (Person)obj;
    return name.equals(other.name)
        && birthYear == other.birthYear
        && Arrays.equals(raw, other.raw);
  }
  public int hashCode() { ... }
}
```
参数必须是Object类型，不能是外围类。

foo.equals(null) 必须返回false，不能抛NullPointerException。（注意，null instanceof 任意类 总是返回false，
因此上面的代码可以运行。）

基本类型域（比如，int）的比较使用 == ，基本类型数组域的比较使用Arrays.equals()。

覆盖equals()时，记得要相应地覆盖 hashCode()，与 equals() 保持一致。

### 实现hashCode()

```
class Person {
  String a;
  Object b;
  byte c;
  int[] d;

  public int hashCode() {
    return a.hashCode() + b.hashCode() + c + Arrays.hashCode(d);
  }

  public boolean equals(Object o) { ... }
}
```
当x和y两个对象具有x.equals(y) == true ，你必须要确保x.hashCode() == y.hashCode()。
根据逆反命题，如果x.hashCode() != y.hashCode()，那么x.equals(y) == false 必定成立。
你不需要保证，当x.equals(y) == false时，x.hashCode() != y.hashCode()。但是，如果你可以尽可能地使它成立的话，这会提高哈希表的性能。


### 实现compareTo()

```
class Person implements Comparable<Person> {
  String firstName;
  String lastName;
  int birthdate;

  // Compare by firstName, break ties by lastName, finally break ties by birthdate
  public int compareTo(Person other) {
    if (firstName.compareTo(other.firstName) != 0)
      return firstName.compareTo(other.firstName);
    else if (lastName.compareTo(other.lastName) != 0)
      return lastName.compareTo(other.lastName);
    else if (birthdate < other.birthdate)
      return -1;
    else if (birthdate > other.birthdate)
      return 1;
    else
      return 0;
  }
}
```

### 实现clone()

```
class Values implements Cloneable {
  String abc;
  double foo;
  int[] bars;
  Date hired;

  public Values clone() {
    try {
      Values result = (Values)super.clone();
      result.bars = result.bars.clone();
      result.hired = result.hired.clone();
      return result;
    } catch (CloneNotSupportedException e) {  // Impossible
      throw new AssertionError(e);
    }
  }
}
```
使用 super.clone() 让Object类负责创建新的对象。
基本类型域都已经被正确地复制了。同样，我们不需要去克隆String和BigInteger等不可变类型。
手动对所有的非基本类型域（对象和数组）进行深度复制（deep copy）。
实现了Cloneable的类，clone()方法永远不要抛CloneNotSupportedException。因此，
需要捕获这个异常并忽略它，或者使用不受检异常（unchecked exception）包装它。

### 使用StringBuilder或StringBuffer

```
// join(["a", "b", "c"]) -> "a and b and c"
String join(List<String> strs) {
  StringBuilder sb = new StringBuilder();
  boolean first = true;
  for (String s : strs) {
    if (first) 
    	first = false;
    else 
    	sb.append(" and ");
    sb.append(s);
  }
  return sb.toString();
}
```
不要像这样使用重复的字符串连接：s += item ，因为它的时间效率是O(n^2)。
使用StringBuilder或者StringBuffer时，可以使用append()方法添加文本和使用toString()方法去获取连接起来的整个文本。
优先使用StringBuilder，因为它更快。StringBuffer的所有方法都是同步的，而你通常不需要同步的方法。

```
Random rand = new Random();
System.out.println(rand.nextInt(6)+1);
```

### 使用Iterator.remove()

```
void filter(List<String> list) {
  for (Iterator<String> iter = list.iterator(); iter.hasNext(); ) {
    String item = iter.next();
    if (...)
      iter.remove();
  }
}
```

### 字符串反转(逆序)
```
public static String reverse(String s){
		return new StringBuilder(s).reverse().toString();
	}
```

### 启动线程

1)继承Thread类

```
class MyThread extends Thread{
	public void run(){   ...   }
}
new MyThread.start();
2) 实现Runnable接口
class MyRunnable implements Runnable{
	public void run(){   ...   }
}
new Thread(new MyRunnable()).start()
```

不要直接调用run()方法。总是调用Thread.start()方法，这个方法会创建一条新的线程并使新建的线程调用run()。

如果try之前的语句运行失败并且抛出异常，那么finally语句块就不会执行
如果try语句块里面的语句抛出异常，那么程序的运行就会跳到finally语句块里执行尽可能多的语句，然后跳出这个方法（

### 从输入流里读取字节数据

```
InputStream in = (...);
try {
  while (true) {
    int b = in.read();
    if (b == -1)
      break;
    (... process b ...)
  }
} finally {
  in.close();
}
```
read()方法要么返回下一次从流里读取的字节数（0到255，包括0和255），要么在达到流的末端时返回-1。

### 从输入流里读取块数据

```
InputStream in = (...);
try {
  byte[] buf = new byte[100];
  while (true) {
    int n = in.read(buf);
    if (n == -1)
      break;
    (... process buf with offset=0 and length=n ...)
  }
} finally {
  in.close();
}
```
要记住的是，read()方法不一定会填满整个buf，所以你必须在处理逻辑中考虑返回的长度。

### 从文件里读取文本

```
BufferedReader in = new BufferedReader(
    new InputStreamReader(new FileInputStream(...), "UTF-8"));
try {
  while (true) {
    String line = in.readLine();
    if (line == null)
      break;
    (... process line ...)
  }
} finally {
  in.close();
}
```
BufferedReader对象的创建显得很冗长。这是因为Java把字节和字符当成两个不同的概念来看待（这与C语言不同）。
你可以使用任何类型的InputStream来代替FileInputStream，比如socket。
当达到流的末端时，BufferedReader.readLine()会返回null。
要一次读取一个字符，使用Reader.read()方法。
你可以使用其他的字符编码而不使用UTF-8，但最好不要这样做。

### 向文件里写文本

```
PrintWriter out = new PrintWriter(
    new OutputStreamWriter(new FileOutputStream(...), "UTF-8"));
try {
  out.print("Hello ");
  out.print(42);
  out.println(" world!");
} finally {
  out.close();
}
```
Printwriter对象的创建显得很冗长。这是因为Java把字节和字符当成两个不同的概念来看待（这与C语言不同）。
就像System.out，你可以使用print()和println()打印多种类型的值。
你可以使用其他的字符编码而不使用UTF-8，但最好不要这样做。

### 预防性检测（Defensive checking）数值

预防性检测对象
预防性检测数组索引
预防性检测数组区间

### 填充数组元素
```
byte[] a =new byte[10];
		Arrays.fill(a,(byte)123);
		for (byte b : a) {
			System.out.println(b);
		}
```

### 把4个字节包装（packing）成一个int

```
int packBigEndian(byte[] b) {
  return (b[0] & 0xFF) << 24
       | (b[1] & 0xFF) << 16
       | (b[2] & 0xFF) <<  8
       | (b[3] & 0xFF) <<  0;
}

int packLittleEndian(byte[] b) {
  return (b[0] & 0xFF) <<  0
       | (b[1] & 0xFF) <<  8
       | (b[2] & 0xFF) << 16
       | (b[3] & 0xFF) << 24;
}
```

### 把int分解（Unpacking）成4个字节

```
byte[] unpackBigEndian(int x) {
  return new byte[] {
    (byte)(x >>> 24),
    (byte)(x >>> 16),
    (byte)(x >>>  8),
    (byte)(x >>>  0)
  };
}

byte[] unpackLittleEndian(int x) {
  return new byte[] {
    (byte)(x >>>  0),
    (byte)(x >>>  8),
    (byte)(x >>> 16),
    (byte)(x >>> 24)
  };
}
```
总是使用无符号右移操作符（>>>）对位进行包装（packing），不要使用算术右移操作符（>>）。

eg
```
public class RightDef{
  int num1 = num2+2;
  static int num2 = 0;
}
```
static 修饰的变量属于类，类变量会随着类初始化得到初始化，因此num2的初始化时机总是处于num1的初始化时机之前
 
使用 static 修饰的变量是类变量，没有使用 static 修饰的是实例变量
在同一个JVM中，每个类只对应一个Class对象，但每个类可以创建多个Java对象
同一个JVM内的类变量只需一块内存空间，但是该类每创建一次实例，就需要为实例变量分配内存空间
每个类初始化完成之后，系统都会为该类创建一个对应的Class实例，程序可以通过反射来获取某个类对应的Class实例。
eg: 要获取person类的Class实例。通过 Person.class 或者 Class.forName("Person");

通过实例来访问某个类变量的时候，底层依然会转换为通过类访问类变量。

### 实例变量的初始化时机：
1）定义实例变量时指定初始值
2）非静态初始化块中对实例变量指定初始值
3）构造器中对实例变量指定初始值
1和2先于3执行，1,2的顺序与他们在源程序中的排列顺序相同
eg:

public Cat(String name,int age){ ... }
{weight=2.0}
double weight = 2.3

每次执行之后weight都是 2.3，因为非静态代码块在前面，先执行

### 类变量的初始化时机：
1）定义类变量时指定初始值
2）静态初始化块中对类变量指定初始值
这两种方式的执行顺序与他们在源程序中的排列顺序相同

final 可修饰变量，被final修饰的变量被赋值后不能重新赋值
final 可修饰方法，被final修饰的方法不能被重写
final 可修饰类  ，被final修饰的类不能派生子类

### Java Eclipse无法查看源代码

```
1.点 “window“-> “Preferences”-> “Java” -> “Installed JRES”
2.此时"Installed JRES"右边是列表窗格，列出了系统中的JRE 环境，选择你的JRE，然后点边上的“Edit...“
3.选中rt.jar文件的这一项：“C:\Java\jdk1.5.0_04\jre\lib\rt.jar” 点 左边的“+”号展开它（JDK实际安装路径以你的为准）
4.展开后，可以看到“Source Attachment:(none)”，点这一项，点右边的按钮“Source Attachment...“，选择你的JDK目录下的 “src.zip”文件
5.一路点“ok”结束。
```

sublime text3
多处选择相同的词：Ctrl+D，回退选择Ctrl+U默认设置
逐词移动：Ctrl+左右键默认设置
显示类和方法提纲：Ctrl+R默认设置，可以很容易知道一个类中都有哪些方法。
显示n个窗口：alt+shift+1，或者2,3...显示n个窗口
格式化代码：alt+shift+f自己设置的，选择代码后按此快捷键可以格式化代码。修改 reindent
折叠代码：ctrl+shift+[自己设置的，可以折叠方法里面的代码  修改fold_by_level

（1）：“在Java里面参数传递都是按值传递”这句话的意思是：按值传递是传递的值的拷贝，按引用传递其实传递的是引用的地址值，所以统称按值传递。
（2）：在Java里面只有基本类型和按照下面这种定义方式的String是按值传递，其它的都是按引用传递。就是直接使用双引号定义字符串方式：String str = “Java私塾”;


