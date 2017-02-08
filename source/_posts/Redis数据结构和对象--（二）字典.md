title: Redis数据结构和对象-(二)字典
tags: [缓存,Redis]
categories: [缓存,Redis]
date: 2016-09-22 18:32:02
---


## 简介
  字典，简单说就是存储key-value键值数据，与Java的HashMap 实现类似，Redis中的字典不要求有序，因此为了降低编码的难度 使用哈希表作为字典的底层实现。Redis的字典是使用一个桶bucket，通过对key进行hash得到的索引值index，然后将key-value的数 据存在桶的index位置，Redis处理hash碰撞的方式是链表，两个不同的key hash得到相同的索引值，那么就使用链表解决冲突。使用链表自然当存储的数据巨大的时候，字典不免会退化成多个链表，效率大大降低，Redis采用 rehash的方式对桶进行扩容来解决这种退化。
## 1、结构
 ![](/img/dict.png)

```
/*
 * 字典
 * 每个字典使用两个哈希表，用于实现渐进式 rehash
 */
typedef struct dict {

    dictType *type;  // 特定于类型的处理函数
    void *privdata;   // 类型处理函数的私有数据
    dictht ht[2];   // 哈希表（2个）
    int rehashidx;   // 记录 rehash 进度的标志，值为-1 表示 rehash 未进行
    int iterators;  // 当前正在运作的安全迭代器数量

} dict;

typedef struct dictType {
    unsigned int (*hashFunction)(const void *key); //hash函数指针
    void *(*keyDup)(void *privdata, const void *key); //键复制函数指针
    void *(*valDup)(void *privdata, const void *obj); //值复制函数指针
    int (*keyCompare)(void *privdata, const void *key1, const void *key2); //键比较函数指针
    void (*keyDestructor)(void *privdata, void *key); //键构造函数指针
    void (*valDestructor)(void *privdata, void *obj); //值构造函数指针
} dictType;

```


## 2.哈希表
  字典所使用的哈希表实现由 dict.h/dictht 类型定义：
```
/*
 * 哈希表
 */
typedef struct dictht {
    dictEntry **table;       // 哈希表节点指针数组（俗称桶，bucket）
    unsigned long size;      // 指针数组的大小
    unsigned long sizemask;  // 指针数组的长度掩码，用于计算索引值
    unsigned long used;      // 哈希表现有的节点数量
} dictht
```

table 属性是一个数组， 数组的每个元素都是一个指向 dictEntry 结构的指针。
每个 dictEntry 都保存着一个键值对， 以及一个指向另一个 dictEntry 结构的指针：

```
/*
 * 哈希表节点
 */
typedef struct dictEntry {
   void *key;      // 键
   union {
       void *val;
       uint64_t u64;
       int64_t s64;
   } v; // 值
  struct dictEntry *next; // 链往后继节点
} dictEntry;
```
next 属性指向另一个 dictEntry 结构， 多个 dictEntry 可以通过 next 指针串连成链表， 从这里可以看出， dictht 使用链地址法来处理键碰撞： 当多个不同的键拥有相同的哈希值时，哈希表用一个链表将这些键连接起来。


## 3.哈希算法


使用字典设置的哈希函数，计算键 key的哈希值
hash = dict -> type -> hashFunction(key);
使用哈希表的sizemask 属性和哈希值，计算出索引值
根据情况不同，ht[x] 可以是 ht[0] 或者ht[1]
index = hash & dict->ht[x].sizemask;

Redis使用的hash算法有以下两种：
1. MurmurHash2 32 bit 算法：这种算法的分布率和速度都非常好，具体信息请参考 MurmurHash 的主页：http://code.google.com/p/smhasher/ 。
2. 基于djb算法实现的一个大小写无关散列算法：
3. 具体信息请参考
http://www.cse.yorku.ca/~oz/hash.html 。


## 4.解决键冲突
多个建被分配到同一个索引上面时，我们称这些键发生了冲突（collision）。
redis哈希表使用 链地址法来解决键冲突，每个哈希表节点都有一个next指指，多个哈希表节点 构成一个单向链表


字典添加元素
根据字典当前的状态，将一个key-value元素添加到字典中可能会引起一系列复制的操作：
如果字典未初始化（即字典的0号哈希表ht[0]的table为空），那么需要调用dictExpand函数对它初始化；
如果插入的元素key已经存在，那么添加元素失败；
如果插入元素时，引起碰撞，需要使用链表来处理碰撞；
如果插入元素时，引起程序满足Rehash的条件时，先调用dictExpand函数扩展哈希表的size，然后准备渐进式Rehash操作。
字典添加元素的流程图：

![](/img/dict_flow.png)

## 字典Rehash解析
Rehash的触发机制：当每次添加新元素时，都会对工作哈希 表ht[0]进行检查，如果used（哈希表中元素的数目）与size（桶的大小）比率ratio满足以下任一条件，将激活字典的Rehash机 制：ratio=used / size， ratio >= 1并且dict_can_resize 为真；ratio 大 于 变 量 dict_force_resize_ratio 。

## 负载因子

负载因子 = 哈希表已保存节点数量/哈希表大小
load_factor = ht[0].used/ht[0].size
Rehash执行过程：
创建一个比ht[0].used至少两倍的ht[1].table；将原ht[0].table中所有元素迁移到ht[1].table；清空原来ht[0]，将ht[1]替换成ht[0]
    扩展操作 那么ht[1]的大小为 第一个大于等于ht[0].used*2的 2的n次方幂  (负载因子 大于等于1  大于等于5)
    收缩操作 那么ht[1]的大小为 第一个大于等于ht[0].used的 2的n次方幂  （负载因子 小于0.1时 触发）


## 为什么是2的n次方？
即底层数组的长度总是为2的n次方。
当length总是 2 的n次方时，h& (length-1)运算等价于对length取模，也就是h%length，但是&比%具有更高的效率

渐进式Rehash主要由两个函数来进行：
_dictRehashStep:当对字典进行添加、查找、删除、随机获取元素都会执行一次，其每次在开始Rehash后，将ht[0].table的第一个不为空的索引上的所有节点全部迁移到ht[1].table;
dictRehashMilliseconds:由Redis服务器常规任务程序(serverCron)执行，以毫秒为单位，在一定时间内，以每次执行100步rehash操作。


## 渐进式rehash

   Rehash的触发机制：当每次添加新元素时，都会对工作哈希表ht[0]进行检查，如果used（哈希表中元素的数目）与size（桶的大小）比率ratio满足以下任一条件，将激活字典的Rehash机制：ratio=used / size， ratio >= 1并且dict_can_resize 为真；ratio 大 于 变 量 dict_force_resize_ratio 。

Rehash执行过程：
----
创建一个比ht[0].used至少两倍的ht[1].table；将原ht[0].table中所有元素迁移到ht[1].table；清空原来ht[0]，将ht[1]替换成ht[0]
渐进式Rehash主要由两个函数来进行：
- - -

dictRehashMilliseconds:由Redis服务器常规任务程序(serverCron)执行，以毫秒为单位，在一定时间内，以每次执行100步rehash操作。
