title: Mysql学习笔记
date: 2016-05-12 15:34:19
categories: [数据库]
tags: Mysql
---
1. Linux平台安装Mysql失败是因为/etc/my.cnf 的设置是系统的错误路径，可以将$MySQL_HOME/support_files/目录下面的配置文件复制到/etc/my.cnf
    ```
    cp ./support_files/my_medium.cnf  /etc/my.cnf
    ```
2. myslq忘记登录密码
```
  mysqladmin -u root -p password "newpwd"
```
3. mysql丢失密码
 * windows平台
```
net stop mysql
mysqld --skip-grant-tables
打开另一个命令行窗口
mysql -u root
update mysql.user set password=password('newpwd') where user='root'
		and host='localhost'
加载权限表
flush privileges;
```
 * linux平台
```
mysqld_safe --skip-grant-tables user=mysql
mysql -u root
update mysql.user set password=password('newpwd') where user='root'
		and host='localhost'
加载权限表
flush privileges;
```
4.InnoDB 和 MyISAM区别
InnoDB 支持事务安全，行锁；空间使用比较高，内存使用高，批量插入速度低
MyISAM不支持事务安全，表锁；空间使用比较低，内存使用低，批量插入速度高

 * 使用mysqldump备份数据库中的某个表
```
mysqldump -uroot -p chuan test > C:/aa.sql
备份数据库chuan中的test数据表
```
 * 使用mysqldump备份多个数据库中的表
```
mysqldump -uroot -p --databases chuan mysql > C:/aa.sql
备份数据库chuan 和数据库mysql
```
使用``` --all-databases可以备份系统中所有的数据库```
* 还原数据库
```
mysql -uroot -p [dbname] < file.sql
指明数据库名称和sql文件位置
或者
use dbname
source file.sql
```

常用
SHOW ENGINES
SHOW VARIABLES LIKE 'have%'
ALTER TABLE account ENGINE=INNODB
DESC  account

USE mysql
SELECT HOST,USER,PASSWORD FROM USER

SELECT MD5('root')

### 数据导入导出
```
SELECT * FROM test INTO OUTFILE "C:/dd.txt"
```
> 注意： 在windows上默认换行符号为"\r\n",而命令默认换行符为"\n",改为
```
SELECT * FROM test INTO OUTFILE "C:/dc.txt"  LINES TERMINATED BY '\r\n'
```

 * 使用select命令生成文本文件
```
SELECT * FROM test INTO OUTFILE "C:/test.txt"
FIELDS
TERMINATED BY ','     -- 设置字段之间的分割符
ENCLOSED BY '\"'      -- 设置字段的包围符号
ESCAPED BY '\''       -- 设置如何写入或读取特殊字符，默认为“\”
LINES TERMINATED BY '\r\n'   -- 设置每行结尾的字符，默认为"\n"
```
 * 使用mysqldump命令同时生成sql文件和文本文件
```
mysqldump -T C:/soft chuan test -uroot -p
--fields-terminated-by=,
--fields-optionally-enclosed-by=\"
--fields-escaped-by=?
--lines-terminated-by=\r\n
```

输出 ==>
```
"1","one"
"2","two"
"3","three"
```

 * 使用load命令导入文本文件
```
LOAD DATA INFILE 'C:/soft/test.txt' INTO TABLE chuan.test
FIELDS
TERMINATED BY ','
ENCLOSED BY '\"'
ESCAPED BY '\''
LINES TERMINATED BY '\r\n'
```

MySQL 的高级特性
1. 查询缓存
SET SESSION QUERY_CACHE_TYPE=  ON;   ##开启缓存功能
SET SESSION QUERY_CACHE_TYPE = OFF
SELECT @@QUERY_CACHE_TYPE AS result  ## 查看是否开启缓存功能

SHOW VARIABLES LIKE 'have_query_cache'   ## 查看缓存大小
SELECT @@global.query_cache_size     ## 为0 表示缓存内存大小为0，查询缓存功能不起作用，默认为0

SET @@global.query_cache_size = 1000000  ## 将缓存大小设为1MB
COMMIT;

SELECT @@global.query_cache_limit;   ## 查看缓存的上限

SHOW VARIABLES LIKE '%query_cache%'   ## 查看缓存的相关参数情况
各变量如下：
have_query_cache    YES    设置是否支持查询缓存区
query_cache_limit    1000000   可以缓存的最大结果集
query_cache_min_res_unit    4096   用来设置分配内存块的最小体积，单位 字节
query_cache_size      0    设置查询缓存使用的总内存字节数，必须是1024字节的倍数
query_cache_type     ON    设置是否启用查询缓存。OFF 不进行缓存；ON 表示出了SQL_NO_CACHE的查询以外，缓存所有结果；DEMAND 仅缓存SQL_CACHE
query_cache_wlock_invalidate     OFF  设置是否允许在其他连接处于lock状态时，使用缓存结果，默认OFF

SHOW STATUS LIKE 'Qcache_hits'  查看缓存命中次数
增加一条记录，跟该表相关的查询缓存会被清空，然后重新查询，命中次数不发生变化，说明本次查询没有直接从缓存中取到数据

可以修改 /etc/my.cnf 配置文件
[mysqld]
query_cache_size = 1000000
query_cache_limit = 2000000

show  variables like 'Qcache%'
Qcache_queries_in_cache   在缓存中已注册的查询数目
Qcache_inserts       被加入到缓存中的查询数目
Qcache_hits      缓存采样数的数目
Qcache_lowmem_pruns     因为缺少内存而被从缓存中删除的查询数目
Qcache_not_cached      没有被缓存的查询数目
Qcache_free_memory     查询缓存的空闲内存总数
Qcache_free_blocks     查询缓存的空闲内存块总数
Qcache_total_blocks   查询缓存中的块的总数目
如果空闲内存块总是总内存块的一半左右，表示存在严重的内部碎片，通常使用flush query cache命令整理碎片，然后 采用reset query cache清理查询缓存
如果碎片很少，但是缓存命中率低，说明设置的缓存内存空间小，服务器频繁删除旧的查询缓存，腾出空间，保证新的查询缓存，参数Qcache_lowmem_prunes增加，如果此值增长过快，可能 1.如果存在大量空闲块，则是因为碎片的存在引起的   2. 空闲内存较少，可以适当增加缓存大小。

分区表
SHOW VARIABLES LIKE '%partition%'  查看是否支持分区
1. range分区
CREATE TABLE emp(
	empNo VARCHAR(20) NOT NULL,
	empName VARCHAR(20),
	deptNo INT,
	birthdate DATE,
	salary INT
)
PARTITION BY RANGE(salary)
(
	PARTITION p1 VALUES LESS THAN(1000),
	PARTITION p2 VALUES LESS THAN(2000),
	PARTITION p3 VALUES LESS THAN(3000)
)
INSERT INTO emp VALUES(1000,'kobe',12,'1888-08-08',1500);
INSERT INTO emp VALUES(1000,'kobe',12,'1888-08-08',3500);
第二条插入失败，因为分区找不到符合条件的表让其插入 。
改为如下：
CREATE TABLE emp(
	empNo VARCHAR(20) NOT NULL,
	empName VARCHAR(20),
	deptNo INT,
	birthdate DATE,
	salary INT
)
PARTITION BY RANGE(salary)
(
	PARTITION p1 VALUES LESS THAN(1000),
	PARTITION p2 VALUES LESS THAN(2000),
	PARTITION p3 VALUES LESS THAN(3000),
	PARTITION p4 VALUES LESS THAN(4000)     //也可以使用表达式   eg: less than maxValue
)
INSERT INTO emp VALUES(1000,'kobe',12,'1888-08-08',1500);
INSERT INTO emp VALUES(1000,'kobe',12,'1888-08-08',3500);
插入成功
range分区常常使用在以下几种情况：
1. 如果要删除某个时间段的数据，只需要删除分区即可。alter table emp drop partion p0 的效率高于 delete from emp where 子句
2. 如果使用包含日期或者时间的列可以考虑使用Range分区
3. 经常行运行直接依赖于分割表的列的查询。比如where year(birth) = 1999 group by empno 此时mysql数据库可以很迅速的确定只有分区P2需要扫描

2. LIST分区
list分区类似range分区，区别在于，list分区中每个分区的定义和选择是基于某列的值从属于一个集合，而range分区是从属于一个连续区间值的集合
PARTITION BY LIST(deptNo)
(
PARTITION p1 VALUES IN (10,20),
PARTITION p2 VALUES IN (30),
PARTITION p3 VALUES IN (40)
)
INSERT INTO emp VALUES(1000,'kobe',10,'1888-08-08',1500);
INSERT INTO emp VALUES(1000,'kobe',30,'1888-08-08',3500);
插入数据的部门编号不在分区值列表中时，那么执行失败
INSERT INTO emp VALUES(1000,'kobe',15,'1888-08-08',3500);

3. HASH分区
用户索要做的就是基于将要被哈希的列值指定一个列值或表达式，以及指定被分区的表将要被分割的分区数量
CREATE TABLE emp(
empNo VARCHAR(20) NOT NULL,
empName VARCHAR(20),
deptNo INT,
birthdate DATE,
salary INT
)
PARTITION BY HASH(YEAR(birthdate)) PARTITIONS  4

4. 线性HASH分区
5. KEY分区
partition by key(birthdate) partitions 4
6. 复合分区
复合分区是分区表中每个分区的再次分割，子分区既可以使用HASH分区，也可以使用KEY分区
CREATE TABLE emp(
	empNo VARCHAR(20) NOT NULL,
	empName VARCHAR(20),
	deptNo INT,
	birthdate DATE,
	salary INT
)
PARTITION BY RANGE(salary)
SUBPARTITION BY HASH(YEAR(birthdate))
SUBPARTITIONS 3
(
	PARTITION p1 VALUES LESS THAN(2000),
	PARTITION p2 VALUES LESS THAN(5000)
)

SQL性能优化
case 1:
CREATE TABLE emp(
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	deptNo INTEGER,
	col3 INTEGER,
	col4 INTEGER
)
INSERT INTO emp VALUES(1,1,2,3);
INSERT INTO emp VALUES(2,3,4,5);
INSERT INTO emp VALUES(3,4,5,6);

EXPLAIN SELECT id FROM emp WHERE deptno=2 AND col3 > 1 ORDER BY col4 DESC
ALTER TABLE emp ADD INDEX index_1(deptno,col3,col4)
// 因为按照BTree索引的原理，先排序deptno,如果遇到相同的deptno就会进行对col3进行排序
// 如果遇到相同的col3就会对 col4排序
DROP INDEX index_1 ON emp
ALTER TABLE emp ADD INDEX index_1(deptno,col4)

case 2: 多表查询优化的例子
CREATE TABLE table1(
	id INTEGER PRIMARY KEY,
	tid INTEGER NOT NULL
);
CREATE TABLE table2(
	id INTEGER PRIMARY KEY 	AUTO_INCREMENT,
	tid INTEGER NOT NULL
);
INSERT INTO table1 VALUES(1,1);
INSERT INTO table1 VALUES(2,2);
INSERT INTO table1 VALUES(3,3);
INSERT INTO table1 VALUES(4,4);

INSERT INTO table2 VALUES(1,5);
INSERT INTO table2 VALUES(2,6);
INSERT INTO table2 VALUES(3,7);
INSERT INTO table2 VALUES(4,8);
优化前：第二张表检索4行数据，且extra没有使用索引
![](http://7xrkr6.com1.z0.glb.clouddn.com/16-5-10/38631395.jpg)
添加索引 alter table table2 add index(tid)
优化后:第二张表检索1行数据，且extra使用索引
![](http://7xrkr6.com1.z0.glb.clouddn.com/16-5-10/69687340.jpg)

利用Profiling分析查询语句
set profiling = 1 开启profiling
show profiles
show profile for query 8;
show profile cpu for query 8;
show profile block io for query 8;

 * 索引
使用like关键词，只有"%"不在第一个位置，索引才会起作用
使用多列索引的查询语句，只有查询语句使用了索引的第一个字段时，索引才会被使用
使用OR关键词前后两个条件中的列都是索引时，查询中才使用索引，否则不使用索引。
 * 优化Insert语句
1. 一次性插入多值
eg: insert into books values(1,'book'),(2,'book2'),(3,'book3')
2. 通常可以锁定表以加速插入数据
lock tables test write; insert ...; unlock tables;
如果不加锁定表，每一次执行insert语句完成后，索引缓冲区都会被写到磁盘上，而加入锁定后索引缓冲区仅被写到磁盘上1次
 * 优化Order By
建立索引，使用索引字段order by
 * 优化group by
使用order by null 的group by语句减少了文件排序的步骤
 * 优化嵌套查询
使用连接查询不需要建立临时表，其速度比子查询要快。
 * 优化数据库结构
1. 将字段很多的表分解成多个表，可以按照重要性和使用频率分开
2. 增加中间表，把需要经常联合查询的数据插入到中间表中。类似于视图
3. 增加冗余字段

彻底删除mysql
yum remove mysql mysql-server mysql-libs compat-mysql51
rm -rf /var/lib/mysql
rm /etc/my.cnf
查看是否还有mysql软件：
rpm -qa|grep mysql
有的话继续删除

MySQL源码安装
1. 首先下载mysql-5.5.24.tar.gz 和 cmake-2.8.4.tar.gz 两个源文件
2. 安装MySQL源文件包是采用cmake安装的，首先安装cmake
3. tar -zxvf cmake-2.8.4.tar.gz , cd cmake-2.8.4
4. ./configure -> make -> make install
5. mkdir -p /usr/local/mysql    mkdir -p /usr/local/mysql/data
6. tar zxvf mysql-5.5.24.tar.gz
7. cmake -DCMAKE_INSTALL_PREFIX=/usr/loca/mysql -DMYSQL_DATADIR=/usr/loca/mysql/data -DDEFAULT_CHARSET=utf8
-DDEFAULT_COLLATION=utf8_general_ci   -DEXTRA_CHARSET=all
8. make -> make install
9. cp ./support_files/my-medium.cnf /etc/my.cnf
10. ./scripts/mysql_install_db --user=mysql
11. vim .bash_profile
PATH=$PATH:$HOME/bin:/usr/local/mysql/bin:/usr/local/mysql/lib
source .bash_profile
12. echo $PATH 检查路径是否生效
13. ./bin/mysqld_safe --user=mysql & 启动mysql服务

安装apache服务器
./configure --prefix=/usr/local/apache
make
make install
然后  cd /usr/local/apache/bin    ./apachectl -t 检查配置文件语法是否正确
vim /etc/profile 添加环境变量   source  profile  使之生效
apachetl start  启动服务

Sysstat软件包集成如下工具
http://sebastien.godard.pagesperso-orange.fr/
iostat 提供CPU和使用率及硬盘吞吐效率的数据
mpstat 提供单个处理器或多个处理器相关数据
sar  负责收集、报告并存储系统活跃的信息
sar1  负责收集并存储每天系统动态信息到一个二进制的文件中
sar2  负责把每天的系统活跃信息写入总结性的报告中
sadc  系统动态数据收集工具，收集的数据被写入一个二进制的文件中
sadf  显示被sar工具通过多种格式收集的数据









