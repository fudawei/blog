title: sybase学习小记
date: 2015-09-15 22:19:53
categories: [数据库]
tags: [sybase,sql]
---

## Sybase_sql

### 语法特点
1.没有“ ”，字符串使用‘ ’包含
2.没有逻辑相等，赋值和逻辑相等都是=
3.类型不再是最严格的。任何数据都可以包含在‘ ’以内
4.没有bool值的概念，但是在视图中可以输入true/false
5.它也有关系运算符：> < >= <= = <> != ,它返回一个bool值
6.它也有逻辑运算符： ！(not) &&(and) ||(or)
7.它不区别大小写
8.数据库完整性（Database Integrity）是指数据库中数据在逻辑上的一致性、正确性、有效性和相容性。

### 事务的四个特点ACID
A:原子性：事务必须是原子工作单元；对于其数据修改，要么全都执行，要么全都不执行。它是一个整体，不能再拆分
C：一致性：事务在完成时，必须使所有的数据都保持一致状态
I:隔离性：事务中隔离，每一个事务是单独的请求将单独的处理，与其它事务没有关系，互不影响
D：持久性：如果事务一旦提交，就对数据的修改永久保留

### 存储过程功能
存储过程为标准SQL增加了如下功能：
条件执行、循环控制结构、命名变量、命名过程、语句块（调用存储过程让DBMS执行一系列SQL语句）

### 存储过程优点
1）封装  只需要了解过程调用的输入输出就可以安全的使用数据库，防止用户跳过完整性检查
2）改善性能  调用存储过程时，DBMS可快速的执行存储过程中的语句，可直接转到语句的执行，无需分析，确认，优化和生成执行计划，这些步骤在预编译已经完成
3）减少网络流量，降低网络负载
4）标准组件化编程，极大的提高了程序的可移植性
5）安全性 系统管理员可向单独的用户授予对数据库对象的最小访问权限

### 数据库索引

### 索引优点/缺点
#### 优点
1.创建系统唯一性索引，可以保证每一行数据的唯一性
2.提高数据检索速度
3.加快表与表之间的连接，特别是具有主键外键关系的表之间
4.在针对order by 和 group by子句进行数据检索时，可以减少分组和排序的时间
5.查询优化器提高系统性能
#### 缺点
1.创建索引和维护索引要耗费时间
2.索引需要占用物理空间
3.当对表中的数据进行增加、删除和修改的时候，索引也要动态的维护

###索引的类型
> * 聚集索引：数据表的物理顺序与索引顺序相同
> * 非聚集索引：数据表的物理顺序与索引顺序不同

### 存储过程 VS 函数
1.存储过程需要使用execute单独执行，而函数可以随处调用
2.用户自定义函数不能修改表中的数据，但是存储过程可以

### 存储过程的执行过程
1.语法分析阶段，保证语法的正确性
2.解析阶段，检查该存储过程引用的对象名称是否存在
3.分析存储过程和生成存储过程执行计划的过程
4.执行阶段，执行主流在高速缓冲存储区的过程执行计划
> * 注意,当存储过程引用的基础表发生结构变化时，该存储过程的执行计划将会自动优化。但是如果在表中添加了索引或者更改了索引列中
的数据之后，该执行计划不会自动优化，这时候应该重新编译存储过程，更新原有的执行计划。

### 连接字符串
SELECT CONCAT(Cname,Tnum) FROM course WHERE Cnum=03
#### left 截取指定字符串的指定个数字符
SELECT LEFT(Cname,5) FROM course WHERE Cnum=01
SELECT RIGHT(Cname,5) FROM course WHERE Cnum=01
#### charIndex()
SELECT LOCATE('ne',cname) FROM course WHERE cnum=01
SELECT SUBSTRING(Cname,1,3) FROM course
### delete 和 truncate
delete from Teacher where Age<20
--特点:
--1.删除是一条一条进行删除的
--2.每一条记录的删除都需要将操作写入到日志文件中
--3.标识列不会从种子值重新计算,以从上次最后一条标识列值往下计算
--4.这种删除可以触发delete触发器

--truncate table 表名 --没有条件，它是一次性删除所有数据
--特点：
--1.一次性删除所有数据，没有条件，那么日志文件只以最小化的数据写入
--2.它可以使用标识列从种子值重新计算
--3.它不能触发delete触发器
truncate table teacher

update Teacher set Salary=Salary+500 where ClassId=4 and Age>20
--sign:正数==1  负数 ==-1  0=0
select SIGN(-100)

mysql不存在top关键词，使用limit
SELECT * FROM course WHERE cnum=(SELECT  cnum FROM sc ORDER BY cnum DESC LIMIT 0,1)
--使用top分页
select top 5 * from Student where StudentNo not in(select top 5 studentno from Student)

视图就是一张虚拟表，可以像使用子查询做为结果集一样使用视图
触发器:执行一个可以改变表数据的操作（增加删除和修改），会自动触发另外一系列（类似于存储过程中的模块）的操作。

SQL语法顺序是：
SELECT[DISTINCT]
FROM
WHERE
GROUP BY
HAVING
UNION
ORDER BY
执行顺序为：
FROM
WHERE
GROUP BY
HAVING
SELECT
DISTINCT
UNION
ORDER BY
The first thing that happens is loading data from the disk into memory, in order to operate on such data.
WITH a AS (
  SELECT first_name, last_name, current_date - date_of_birth age
  FROM author
)
SELECT *
FROM a
WHERE age > 10000

### 注意

SELECT 语句有很多特殊的规则，至少你应该熟悉以下几条
你仅能够使用那些能通过表引用而得来的字段
如果你有 GROUP BY 语句，你只能够使用 GROUP BY 语句后面的字段或者聚合函数
当你的语句中没有 GROUP BY 的时候，可以使用开窗函数代替聚合函数
当你的语句中没有 GROUP BY 的时候，你不能同时使用聚合函数和其它函数
有一些方法可以将普通函数封装在聚合函数中
存储过程要返回IQ系统错误信息 SQLCODE || ERRORMSG(*) ：(两者都为EXCEPTION后第一条SQL语句才有效果)
IQ中若采用 FULL JOIN 连接则不能使用 WHERE 条件，否则FULL JOIN将失效，要筛选条件则用子查询先过滤记录后再FULL JOIN；


### sybase常用SQL

FROM后的子查询，要定义别名才可使用
IQ中若采用 FULL JOIN 连接则不能使用 WHERE 条件，否则FULL JOIN将失效，要筛选条件则用子查询先过滤记录后再FULL JOIN
根据SELECT 语句建立[临时]表的方法（ORACLE的CREATE TABLE）为 SELECT ..[*] INTO ['#']table_name FROM ..
其中如果在table_name加前缀'#'，则为会话级临时表，否则为实体表；
存储过程隐式游标语法：
FOR A AS B CURSOR FOR SELECT ... FROM ...
DO....
END FOR;
需要注意的时，这边的A 和 B 在 过程语句中都不能引用，所以为避免过程语句其他字段名与FOR SELECT 语句的字段名称重复，
FOR SELECT 语句的字段最好都定义别名区分
因Sybase为列存储模式，在执行上INSERT语句会比UPDATE语句慢，尤其表数据越多INSERT效率就越慢；所以在ETL时建议多用UPDATE而不是INSERT
空字符串''在Sybase中也是个字符而不是null值，这点要注意
默认值和规则：Transact-SQL 提供维护实体完整性（确保为要求值得的每一列都提供值）和域完整性（确保列中的每个值都属于该列的合法值集合）的关键字

### 转换函数

CONVERT(datetype,exp[,format-style])
CAST(exp AS data-type)

### 日期函数

DAY(date_exp):返回日期天值，DAYS(date_exp,int):返回日期date_exp加int后的日期；MONTH与MONTHS、YEAR与YEARS同理；
DATE(exp):将表达式转换为日期，并删除任何小时、分钟或秒；兼容性：IQ
DATEPART(date-part,date-exp): 返回日期分量的对应值(整数)
GETDATE():返回系统时间
DATENAME(datepart,date_expr):以字符串形式返回date_expr指定部分的值,转换成合适的名字
DATEDIFF(datepart,date_expr1,date_expr2):返回date_expr2-date_expr1,通过指定的datepart度量
DATEADD（date-part,num-exp,date-exp）:返回按指定date-part分量加num-exp值后生成的date-exp值；

### 数学函数

CEIL(num-exp)：返回大于或等于指定表达式的最小整数；兼容性：IQ&ASE
FLOOR(numeric_expr):返回小于或等于指定值的最大整数
ABS(num-exp):返回数值表达式的绝对值；兼容性：IQ&ASE
TRUNCNUM(1231.1251,2)：截取数值；不四舍五入
ROUND(numeric_expr,int_expr)：把数值表达式圆整到int_expr指定的精度
RAND([int_expr])：返回0-1之间的随机浮点数，可指定基值
SIGN(int_expr)：返回正+1，零0或负-1
SQRT(float_expr)：返回指定值的平方根
PI()：返回常数3.1415926
POWER(numeric_expr,power)：返回numeric_expr的值给power的幂
EXP(float_expr)：给出指定值的指数值

### 常用DDL语句

1.删除列
ALTER TABLE table_name DELETE column_name
2.增加列
ALTER TABLE table_name ADD (column_name DATA_TYPE [NOT] NULL)
3.修改列的空与非空
ALTER TABLE table_name MODIFY column_name [NOT] NULL
4.修改列名
ALTER TABLE table_name RENAME old_column_name TO new_column_name
5.快速建立临时表
SELECT * INTO [#]table_name FROM .....
6、修改表名ALTER TABLE old_table_name RENAME new_table_name
7.增加主键约束
ALTER TABLE tb_name ADD CONSTRAINT pk_name PRIMARY KEY(col_name,..)
8.删除主键约束
ALTER TABLE tb_name DROP CONSTRAINT pk_name
9.建立自增长字段，与Oracle的SEQUENCE类似
CREATE TABLE TMP_001 (RES_ID INTEGER IDENTITY NOT NULL)
10.添加表注释
COMMENT ON TABLE table_name IS '....'
11.创建索引
CREATE INDEX index_name ON table_name(column_name)

### SQL优化

常见瓶颈：
绝大多数瓶颈在于I/O子系统
若CPU很高，90%以上是因为索引不当
发生swap时，可能因为内存分配太小或过大
iowait太高时，想办法从索引角度入手优化，以及提高I/O设备性能，增加内存，减少排序，减少SELECT一次性读取数据量。
常见优化策略：
瞬间并发很高，采用thread pool
频繁order by\group by，索引入手
适当调整内存，不要太大或太小。一般ibp设置为50% ~ 70%为宜
iowait高，加内存，提高iops，减少数据读写。

SQL优化
多用简单SQL
少用子查询和复杂查询
少用复杂join，注意join驱动表是否最优
where不使用函数，避免无法使用索引
注意类型隐式转换
事务快速提交，但不要频繁反复提交

### 查看执行计划
查看语句的执行计划
set showplan on
set noexec on
go
select .......
go
set showplan off
set noexec off
go

查看存储过程执行计划：
set showplan on
go

exec sp_name
go
set showplan off
go

dbcc traceon(3604)是把dbcc的结果输出到屏幕上。
dbcc sqltext(spid)是看指定的sybase进程的操作语句。
查看其查询计划，可以用sp_showplan spid,null,null,null

### sybase系统函数
sp_iqtablesize 'T1_table'  查看表的大小空间
select tablewidth('ConditionStyle')   查看表的行宽
sp_iqcolumn  'ConditionData'  查看表中每一列的信息
select * from sp_table_size_statics();   此存储过程会输出所有用户表的大小
### bat启动
dbisql -c "uid=netmax;pwd=SOPinUETZ" -host 10.89.160.6 -port 3000 -oneerror continue   -> bat启动

###sql基础用法
drop table if exists tableA;
