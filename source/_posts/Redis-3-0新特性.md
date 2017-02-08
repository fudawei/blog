title: Redis 3.0新特性
tags: [缓存,Redis]
categories: [缓存,Redis]
date: 2015-09-28 12:42:55
---
# Redis 3.0改进
Redis 3.0.0 正式版终于到来了，与 RC6 版本比较，该版本改进包括：

* 修复了无磁盘的复制问题 (Oran Agra)
* 在角色变化后对 BLPOP 复制进行测试 (Salvatore Sanfilippo)
* prepareClientToWrite() 错误处理方法的改进 (Salvatore Sanfilippo)
* 移除 dict.c 中不再使用的函数(Salvatore Sanfilippo)
<!--more-->

# Redis 3.0新特性
Redis 3.0 版本与 2.8 版本比较，主要新特性包括如下几个方面：

* Redis Cluster —— 一个分布式的 Redis 实现
* 全新的 "embedded string" 对象编码结果，更少的缓存丢失，在特定的工作负载下速度的大幅提升
* AOF child -> parent 最终数据传输最小化延迟，通过在 AOF 重写过程中的  "last write" 
* 大幅提升 LRU 近似算法用于键的擦除
* WAIT 命令堵塞等待写操作传输到指定数量的从节点
* MIGRATE 连接缓存，大幅提升键移植的速度
* MIGARTE 新的参数 COPY 和 REPLACE
* CLIENT PAUSE 命令：在指定时间内停止处理客户端请求
* BITCOUNT 性能提升
* CONFIG SET 接受不同单位的内存值，例如 "CONFIG SET maxmemory 1gb".
* Redis 日志格式小调整用于反应实例的角色 (master/slave) 
* INCR 性能提升

下载地址：[http://download.redis.io/releases/redis-3.0.0.tar.gz](http://download.redis.io/releases/redis-3.0.0.tar.gz)

# 参考
1. [http://www.oschina.net/news/61115/redis-3-0-final](http://www.oschina.net/news/61115/redis-3-0-final)
