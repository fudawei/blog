title: Redis持久化
tags: [缓存,Redis]
categories: [缓存,Redis]
date: 2015-10-13 00:16:02
---

# 概述
Redis的强大性能很大程度上都是因为所有数据都是存储在内存中的，然而当Redis重启后，所有存储在内存中的数据将会丢失，在很多情况下是无法容忍这样的事情的。所以，我们需要将内存中的数据持久化！典型的需要持久化数据的场景如下：

* 将Redis作为数据库使用；
* 将Redis作为缓存服务器使用，但是缓存miss后会对性能造成很大影响，所有缓存同时失效时会造成服务雪崩，无法响应。

<!--more-->
本文介绍Redis所支持的两种数据持久化方式。

# Redis数据持久化
Redis支持两种数据持久化方式：RDB方式和AOF方式。前者会根据配置的规则定时将内存中的数据持久化到硬盘上，后者则是在每次执行写命令之后将命令记录下来。两种持久化方式可以单独使用，但是通常会将两者结合使用。

## RDB方式
RDB方式的持久化是通过快照的方式完成的。当符合某种规则时，会将内存中的数据全量生成一份副本存储到硬盘上，这个过程称作"快照"，Redis会在以下几种情况下对数据进行快照：

* 根据配置规则进行自动快照；
* 用户执行SAVE, BGSAVE命令；
* 执行FLUSHALL命令；
* 执行复制（replication）时。

### 执行快照的场景
#### 根据配置自动快照
Redis允许用户自定义快照条件，当满足条件时自动执行快照，快照规则的配置方式如下：

```
save 900 1
save 300 10
save 60 10000
```
每个快照条件独占一行，他们之间是或（||）关系，只要满足任何一个就进行快照。上面配置save后的第一个参数T是时间，单位是秒，第二个参数M是更改的键的个数，含义是：当时间T内被更改的键的个数大于M时，自动进行快照。比如`save 900 1`的含义是15分钟内(900s)被更改的键的个数大于1时，自动进行快照操作。

#### 执行SAVE或BGSAVE命令
除了让Redis自动进行快照外，当我们需要重启，迁移，备份Redis时，我们也可以手动执行SAVE或BGSAVE命令主动进行快照操作。

* **SAVE命令：**当执行SAVE命令时，Redis同步进行快照操作，期间会阻塞所有来自客户端的请求，所以放数据库数据较多时，应该避免使用该命令；
* **BGSAVE命令：** 从命令名字就能看出来，这个命令与SAVE命令的区别就在于该命令的快照操作是在后台异步进行的，进行快照操作的同时还能处理来自客户端的请求。执行BGSAVE命令后Redis会马上返回OK表示开始进行快照操作，如果想知道快照操作是否已经完成，可以使用LASTSAVE命令返回最近一次成功执行快照的时间，返回结果是一个Unix时间戳。

#### 执行FLUSHALL命令
当执行FLUSHALL命令时，Redis会清除数据库中的所有数据。需要注意的是：**不论清空数据库的过程是否触发 了自动快照的条件，只要自动快照条件不为空，Redis就会执行一次快照操作，当没有定义自动快照条件时，执行FLUSHALL命令不会进行快照操作。**

#### 执行复制
当设置了主从模式时，Redis会在复制初始化是进行自动快照。

### 快照原理
Redis默认会将快照文件存储在Redis当前进程的工作目录的dump.rdb文件中，可以通过配置文件中的dir和dbfilename两个参数分别指定快照文件的存储路径和文件名，例如：

```
dbfilename dump.rdb
dir /opt/soft/redis-3.0.4/cache
```
快照执行的过程如下：

1. Redis使用fork函数复制一份当前进程（父进程）的副本（子进程）；
2. 父进程继续处理来自客户端的请求，子进程开始将内存中的数据写入硬盘中的临时文件；
3. 当子进程写完所有的数据后，用该临时文件替换旧的RDB文件，至此，一次快照操作完成。

需要注意的是：  

>**在执行fork是时候操作系统（类Unix操作系统）会使用写时复制（copy-on-write）策略，即fork函数发生的一刻，父进程和子进程共享同一块内存数据，当父进程需要修改其中的某片数据（如执行写命令）时，操作系统会将该片数据复制一份以保证子进程不受影响，所以RDB文件存储的是执行fork操作那一刻的内存数据。所以RDB方式理论上是会存在丢数据的情况的(fork之后修改的的那些没有写进RDB文件)。**

通过上述的介绍可以知道，快照进行时时不会修改RDB文件的，只有完成的时候才会用临时文件替换老的RDB文件，所以就保证任何时候RDB文件的都是完整的。这使得我们可以通过定时备份RDB文件来实现Redis数据的备份。RDB文件是经过压缩处理的二进制文件，所以占用的空间会小于内存中数据的大小，更有利于传输。

Redis启动时会自动读取RDB快照文件，将数据从硬盘载入到内存，根据数量的不同，这个过程持续的时间也不尽相同，通常来讲，一个记录1000万个字符串类型键，大小为1GB的快照文件载入到内存需要20-30秒的时间。

### 示例
下面演示RDB方式持久化，首先使用配置有如下快照规则：

```
save 900 1
save 300 10
save 60 10000
dbfilename dump.rdb
dir /opt/soft/redis-3.0.4/cache
```
的配置文件`/opt/soft/redis-3.0.4/conf/redis.conf`启动Redis服务：
![](http://7xlune.com1.z0.glb.clouddn.com/images/Redis持久化/start-redis.png)  

然后通过客户端设置一个键值：

```
[qifuguang@Mac~]$ /opt/soft/redis-3.0.4/src/redis-cli -p 6379
127.0.0.1:6379> set test-rdb HelloWorld
OK
127.0.0.1:6379> get test-rdb
"HelloWorld"
127.0.0.1:6379>
```
现在强行kill Redis服务：
![](http://7xlune.com1.z0.glb.clouddn.com/images/Redis持久化/stop-redis.png)  
现在到`/opt/soft/redis-3.0.4/cache`目录看，目录下出现了Redis的快照文件dump.rdb：

```
[qifuguang@Mac/opt/soft/redis-3.0.4/cache]$ ls
dump.rdb
```
现在重新启动Redis：
![](http://7xlune.com1.z0.glb.clouddn.com/images/Redis持久化/start-redis.png)  

然后再用客户端连接，检查之前设置的key是否还存在：

```
[qifuguang@Mac~]$ /opt/soft/redis-3.0.4/src/redis-cli -p 6379
127.0.0.1:6379> get test-rdb
"HelloWorld"
127.0.0.1:6379>
```
可以发现，之前设置的key在Redis重启之后又通过快照文件dump.rdb恢复了。

## AOF方式
在使用Redis存储非临时数据时，一般都需要打开AOF持久化来降低进程终止导致的数据丢失，AOF可以将Redis执行的每一条写命令追加到硬盘文件中，这已过程显然会降低Redis的性能，但是大部分情况下这个影响是可以接受的，另外，使用较快的硬盘能提高AOF的性能。

### 开启AOF
默认情况下，Redis没有开启AOF（append only file）持久化功能，可以通过在配置文件中作如下配置启用：

```
appendonly yes
```
开启之后，Redis每执行一条写命令就会将该命令写入硬盘中的AOF文件。AOF文件保存路径和RDB文件路径是一致的，都是通过dir参数配置，默认文件名是：appendonly.aof，可以通过配置appendonlyfilename参数修改，例如：

```
appendonlyfilename appendonly.aof
```

### AOF持久化的实现
AOF纯文本的形式记录了Redis执行的写命令，例如在开启AOF持久化的情况下执行如下命令：

```
[qifuguang@Mac/opt/soft/redis-3.0.4]$ ./src/redis-cli
127.0.0.1:6379>
127.0.0.1:6379>
127.0.0.1:6379>
127.0.0.1:6379> set aof1 value1
OK
127.0.0.1:6379> set aof2 value2
OK
127.0.0.1:6379>
```
然后查看`/opt/soft/redis-3.0.4/cache/appendonly.aof`文件：

```
[qifuguang@Mac/opt/soft/redis-3.0.4/cache]$ cat appendonly.aof
*2
$6
SELECT
$1
0
*3
$3
set
$4
aof1
$6
value1
*3
$3
set
$4
aof2
$6
value2
```
文件中的内容正是Redis刚才执行的命令的内容，内容的格式就先不展开叙述了。

### AOF文件重写
假设Redis执行了如下命令：

```
[qifuguang@Mac/opt/soft/redis-3.0.4]$ ./src/redis-cli
127.0.0.1:6379>
127.0.0.1:6379>
127.0.0.1:6379>
127.0.0.1:6379> set k v1
OK
127.0.0.1:6379> set k v2
OK
127.0.0.1:6379> set k v3
OK
127.0.0.1:6379>
```
如果这所有的命令都写到AOF文件的话，将是一个比较蠢行为，因为前面两个命令会被第三个命令覆盖，所以AOF文件完全不需要保存前面两个文件，事实上Redis确实就是这么做的。删除AOF文件中无用的命令的过程成为"AOF重写"，AOF重写可以在配置文件中做相应的配置，当满足配置的条件时，自动进行AOF重写操作。配置如下：

```
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
```
第一行的意思是，目前的AOF文件的大小超过上一次重写时的AOF文件的百分之多少时再次进行重写，如果之前没有重写过，则以启动时AOF文件大小为依据。
第二行的意思是，当AOF文件的大小大于64MB时才进行重写，因为如果AOF文件本来就很小时，有几个无效的命令也是无伤大雅的事情。
这两个配置项通常一起使用。

我们还可以手动执行BDREWRITEAOF命令主动让Redis重写AOF文件，执行重写命令之后查看现在的AOF文件：

```
[qifuguang@Mac/opt/soft/redis-3.0.4]$ cat cache/appendonly.aof
*2
$6
SELECT
$1
0
*3
$3
SET
$4
aof2
$6
value2
*3
$3
SET
$1
k
$2
v3
*3
$3
SET
$4
aof1
$6
value1
```
可以看到，文件中并没有再记录`set k v1`这样的无效命令。

### 同步硬盘数据
虽然每次执行更改数据库的内容时，AOF都会记录执行的命令，但是由于操作系统本身的硬盘缓存的缘故，AOF文件的内容并没有真正地写入硬盘，在默认情况下，操作系统会每隔30s将硬盘缓存中的数据同步到硬盘，但是为了防止系统异常退出而导致丢数据的情况发生，我们还可以在Redis的配置文件中配置这个同步的频率：

```
# appendfsync always
appendfsync everysec
# appendfsync no
```
第一行表示每次AOF写入一个命令都会执行同步操作，这是最安全也是最慢的方式；
第二行表示每秒钟进行一次同步操作，一般来说使用这种方式已经足够；
第三行表示不主动进行同步操作，这是最不安全的方式。

# 声明
本文为作者原创，转载请注明出处，本文链接：[http://fudawei.github.io/2015/10/13/Redis持久化](http://fudawei.github.io/2015/10/13/Redis持久化)
