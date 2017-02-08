title: CocurrentHashMap源码理解
date: 2014-04-06 09:44:17
categories: [Java,并发库]
tags: [Java,并发库,数据结构]
---
### CurrentHashMap 笔记###
 1. ConcurrentHashMap可以做到读取数据不加锁，并且其内部的结构可以让其在进行写操作的时候能够将锁的粒度保持地尽量地小，不用对整个ConcurrentHashMap加锁。
![CurrentHashMap][1]
 2. ConcurrentHashMap定位一个元素的过程需要进行两次Hash操作，第一次Hash定位到Segment，第二次Hash定位到元素所在的链表的头部，因此，这一种结构的带来的副作用是Hash的过程要比普通的HashMap要长，但是带来的好处是写操作的时候可以只对元素所在的Segment进行加锁即可，不会影响到其他的Segment，这样，在最理想的情况下，ConcurrentHashMap可以最高同时支持Segment数量大小的写操作（刚好这些写操作都非常平均地分布在所有的Segment上），所以，通过这一种结构，ConcurrentHashMap的并发能力可以大大的提高。
 3. Segment的数据结构
```
static final class Segment<K,V> extends ReentrantLock implements Serializable {
    transient volatile int count;
    transient int modCount;
    transient int threshold;
    transient volatile HashEntry<K,V>[] table;
    final float loadFactor;
}
```
segment成员变量意义
count：Segment中元素的数量
modCount：对table的大小造成影响的操作的数量（比如put或者remove操作）
threshold：阈值，Segment里面元素的数量超过这个值依旧就会对Segment进行扩容
table：链表数组，数组中的每一个元素代表了一个链表的头部
loadFactor：负载因子，用于确定threshold

**HashEntry**
Segment中的元素是以HashEntry的形式存放在链表数组中的
```
static final class HashEntry<K,V> {
    final K key;
    final int hash;
    volatile V value;
    final HashEntry<K,V> next;
}
```
除了value以外，其他的几个变量都是final的，这样做是为了防止链表结构被破坏，出现ConcurrentModification的情况。
> 注意： 初始化中的concurrentLevel，代表ConcurrentHashMap内部的Segment的数量，ConcurrentLevel一经指定，不可改变，后续如果ConcurrentHashMap的元素数量增加导致ConrruentHashMap需要扩容，ConcurrentHashMap不会增加Segment的数量，而只会增加Segment中链表数组的容量大小，这样的好处是扩容过程不需要对整个ConcurrentHashMap做rehash，而只需要对Segment里面的元素做一次rehash就可以了。
> 之所以进行再散列，目的是减少三列冲突，使元素能够均匀的分别在不同的Segment上，从而提高容器的存取效率。
**ConcurrentHashMap的get操作**
get操作不加锁因为get方法里将要使用的共享变量都定义成volatile类型。











  [1]: http://7xrkr6.com1.z0.glb.clouddn.com/nuEZ0.png
