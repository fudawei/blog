title: Map接口及子类总结
date: 2016-03-05 22:23:02
categories: [Java,Java基础]
tags: [Java基础,Map]
---

转自 [Hsuxu的专栏](http://blog..hsuxu/article/details/7454172)
### 子接口
Bindings、ConcurrentMap、ConcurrentNavigableMap、MessageContext、LogicMessageContext、NavigableMap、SOAPMessageMap、SortedMap
### 实现类
AbstractMap, Attributes,AuthProvider, ConcurrentHashMap, EnumMap,ConcurrentSkipListMap,HashMap, Hashtable, IdentityHashMap,
LinkedHashMap, PrinterStateReasons,Properties,Provider, RenderingHints, SimpleBindings, TabularDataSupport,TreeMap,UIDefaults,
WeakHashMap
### 方法定义说明
put(K, V) ： 将给定的“键-值”对放入到给定的Map当中
putAll(Map<? extends K, ? extends V) : 将指定的Map中的“键-值”对放入到给定的Map当中
remove(Object key) : 从该集合中移除指定的对象，并返回对应的value
clear() : 清空Map中的所有对象
int size() : 返回此Map中“键-值”对的个数
boolean isEmpty() : 判断此Map中“键-值”对的个数是否为0
boolean containsKey(Object key) : 测试此Map中是否有该key
boolean containsValue(Object value) : 测试此Map中是否包含该value
V get(Object key) : 通过指定的key查询Map中对应的value
Collection<Object value> values() : 取得Map中所有的value
Set<Object key> keySet() : 取得当前Map中key的集合
Set<Entry<K, V>> entrySet() : 取得当前Map中entry的集合
### HashMap
HashMap 实现了Map、CloneMap、Serializable三个接口，并且继承自AbstractMap类。
HashMap 基于hash数组实现，若key的hash值相同则使用链表方式进行保存。Entry是一个结点，它持有下一个元素的引用
```
static int indexFor(int h,int length){
	return h & (length-1);
}
```
这个方法是根据hashCode及当前table的长度得到该元素应该存放的位置，或者在table中的索引。
在HashMap中当数据量很多时，并且已经达到了负载限度时，会重新做一次哈希，也就是说会再散列。调用的方法为resize()
resize（再哈希）的工作量是不是很大啊。再哈希是重新建一个指定容量的数组，然后将每个元素重新计算它要放的位置
Q： 如何提高Hash表的性能 ？
比较重要的是HashMap的遍历方法,KeySet,EntrySet。
#### 总结
1.HashMap采用数组方式存储key，value构成的Entry对象，无容量限制。
2.HashMap基于key hash寻找Entry对象存放到数组的位置，对于Hash冲突采用链表的方式来解决。
3.HashMap在插入元素时可能要扩大数组的容量，扩大容量时对所有的数据要重新计算哈希和存放到新数组中。当元素个数size大于threshold扩容
threshold = (int)(newCapacity* loadFactor);
4.HashMap保证数组的大小为2的指数大小。
5.HashMap非线程安全。

### LinkedHashMap
LinkedHashMap继承自HashMap并且实现了Map接口。和HashMap一样，LinkedHashMap允许key和value均为null。
如果你想在多线程中使用，那么需要使用Collections.synchronizedMap方法进行外部同步。
LinkedHashMap与HashMap的不同之处在于，LinkedHashMap维护着运行于所有条目的双向链接列表，此链接列表可以是插入顺序或者访问顺序。
重新定义了数组中保存的元素Entry，该Entry除了保存当前对象的引用外，还保存了其上一个元素before和下一个元素after的引用，从而在哈希表的基础上
又构成了双向链接列表
LinkedHashMap重写了init()方法，在调用父类的构造方法完成构造后，进一步实现了对其元素Entry的初始化操作（双向链表）
LinkedHashMap适合做LRU缓存。
### TreeMap
如果要控制TreeMap中元素的存储顺序，应使用带Comparator参数的构造器。
put(K,V)
先判断root是否为null，如果为null，则创建一个新的Entry对象，并赋值给root属性。否则，首先判断是否传入了Compatator实现，如果是，则基于
红黑树的方式遍历，直到为树节点null，使用传入的comparator比较Key的大小，如果找到相等的key则更新其值，若没有找到相同的key，则创建一个
新的Entry对象，并将其parent设置为上面所寻找到的元素，并根据和parent key比较的情况设置parent的left和right属性。最后对红黑树进行调整。
### ConcurrentHashMap
ConcurrentHashMap 是线程安全的HashMap实现。支持获取，查找时完全并发和更新时可调整并发的哈希表。获取操作（包括 get）通常不会受阻塞。
并发场景中(多个线程的情况下) ConcurrentHashMap 比HashMap优秀很多。















