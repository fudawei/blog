title: Redis过期机制介绍
tags: [缓存,Redis]
categories: [缓存,Redis]
date: 2015-09-30 11:38:17
---

# 概述
在实际开发过程中经常会遇到一些有时效性数据，比如限时优惠活动，缓存或者验证码之类的。过了一段时间就需要删除这些数据。在关系型数据库中一般都要增加一个字段记录数据的到期时间，然后周期性地检查过期数据然后删除。Redis本身就对键过期提供了很好的支持。

<!--more-->
# Redis过期机制
在Redis中可以使用**EXPIRE**命令设置一个键的存活时间(ttl: time to live)，过了这段时间，该键就会自动被删除，EXPIRE命令的使用方法如下：

```
EXPIRE key ttl(单位秒)
```
命令返回1表示设置ttl成功，返回0表示键不存在或者设置失败。

举个例子：

```
127.0.0.1:6379> set session 100
OK
127.0.0.1:6379> EXPIRE session 5
(integer) 1
127.0.0.1:6379> get session
"100"
127.0.0.1:6379> get session
"100"
127.0.0.1:6379> get session
(nil)
127.0.0.1:6379>
```
上例可见，先设置session的值为100，然后设置他的ttl为5s，之后连续几次使用get命令获取session，5s之后将获取不到session，因为ttl时间已到，session被删除。

如果想知道一个键还有多长时间被删除，则可以使用**TTL**命令查看，使用方法如下：

```
TTL key
```
返回值是键的剩余时间，单位秒。

比如：

```
127.0.0.1:6379> set session 100
OK
127.0.0.1:6379> EXPIRE session 10
(integer) 1
127.0.0.1:6379> TTL session
(integer) 7
127.0.0.1:6379> TTL session
(integer) 5
127.0.0.1:6379> TTL session
(integer) 2
127.0.0.1:6379> TTL session
(integer) 0
127.0.0.1:6379> TTL session
(integer) -2
127.0.0.1:6379> TTL session
(integer) -2
127.0.0.1:6379>
```
可见，TTL的返回值会随着时间的流逝慢慢减少，10s之后键会被删除，键不存在时TTL会返回-2，**当没有为键设置过期时间时，使用TTL获取键的剩余时间将会返回-1**，比如

```
127.0.0.1:6379> set url http://fudawei.github.io
OK
127.0.0.1:6379> ttl url
(integer) -1
127.0.0.1:6379>
```

如果想取消某个键的过期时间，可以使用**PERSIST**命令，用法如下：

```
PERSIST key
```

清除成功返回1，失败返回0.

例如：

```
127.0.0.1:6379> set title 飞鸟
OK
127.0.0.1:6379> EXPIRE title 100
(integer) 1
127.0.0.1:6379> ttl title
(integer) 97
127.0.0.1:6379> PERSIST title
(integer) 1
127.0.0.1:6379> ttl title
(integer) -1
127.0.0.1:6379>
```
除了PERSIST命令会清除键的过期时间之外，SET,GETSET命令也能清除键的过期时间，但是只对键进行操作的命令（比如INCR,LPUSH等等）不会清除键的过期时间。

**EXPIRE命令的单位是秒，如果想要更精确的过期时间，则可以使用PEXPIRE命令，该命令的单位是毫秒，相应地可以使用PTTL看剩余时间。**

**如果[WATCH](http://fudawei.github.io/2015/09/30/Redis%E4%BA%8B%E5%8A%A1%E4%BB%8B%E7%BB%8D/)命令监控了一个具有过期时间的键，如果监控期间这个键过期被自动删除，WATCH并不认为该键被改变**

# Redis过期机制的用途
有了过期机制就能实现很多跟时间相关的功能了，比如访问频率限制，作为缓存等等，具体细节就不展开了，有疑问的可以留言。

# 声明
本文原创，转载请注明出处，本文链接：[http://fudawei.github.io/2015/09/30/Redis过期机制介绍/](http://fudawei.github.io/2015/09/30/Redis过期机制介绍/)
