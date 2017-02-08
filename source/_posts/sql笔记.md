title: Sql笔记
date: 2012-09-05 20:39:59
categories: [数据库]
tags: [sql,优化]
keywords: sql,优化
---

## sql学习

### sql学习

#### 查询每个月倒数第2天入职的员工的信息

```
SELECT last_name,hire_date 
FROM employees 
WHERE hire_date = LAST_DAY(hire_date) -1 
```

#### 查询隔行数据

```select row_number() over(order by sno) n wher n % 2 =1```

#### 将空值转换为有效值 

```select sno,bookname,author,isnull(book,'无') as book from tb_space```

#### 第N行数据

```
select * from (select top n from tb_space )aa
where not exist (select * from (select top n-1 from tb_space)bb 
where aa.sno = bb.sno )
```

#### 字符函数

right(xh,len(xh)-1) 从右边开始取指定个数的字符
left(xh,len(xh)-1) 从左边开始去指定个数的字符
substring(expresion,start,length) 子串
select * from tb_space order by 2,3 按照第2列，第3列排序
```
case...when
select(
case job
when '会计' then salary*1.5;
when '秘书' then salary*2.0;
end as new_salary
) order by new_salary
```

#### 对重复的内容不作统计

select count(distinct duty) as duty
不包括最大最小值计算平均值
```
select avg(salary)
from tb_space where salary not in (
	(select min(salary) as minSalary from tb_treatment)
	union 
	(selct max(salary) as maxSalary from tb_treatment)
)
```

### 语法特点：
1.没有“ ”，字符串使用‘ ’包含
2.没有逻辑相等，赋值和逻辑相等都是=
3.类型不再是最严格的。任何数据都可以包含在‘ ’以内
4.没有bool值的概念，但是在视图中可以输入true/false
5.它也有关系运算符：> < >= <= = <> != ,它返回一个bool值
6.它也有逻辑运算符： ！(not) &&(and) ||(or)
7.它不区别大小写
数据库完整性（Database Integrity）是指数据库中数据在逻辑上的一致性、正确性、有效性和相容性。

### 事务的四个特点ACID:

A:原子性：事务必须是原子工作单元；对于其数据修改，要么全都执行，要么全都不执行。它是一个整体，不能再拆分
C：一致性：事务在完成时，必须使所有的数据都保持一致状态。。某种程度的一致
I:隔离性：事务中隔离，每一个事务是单独的请求将单独的处理，与其它事务没有关系，互不影响
D：持久性：如果事务一旦提交，就对数据的修改永久保留

### 功能

存储过程为标准SQL增加了如下功能：
条件执行、循环控制结构、命名变量、命名过程、语句块（调用存储过程让DBMS执行一系列SQL语句）

### 存储过程的优点

1）封装  只需要了解过程调用的输入输出就可以安全的使用数据库，防止用户跳过完整性检查
2）改善性能  调用存储过程时，DBMS可快速的执行存储过程中的语句，可直接转到语句的执行，无需分析，确认，优化和生成执行计划，这些步骤实现已经完成
3）减少网络流量 
4）减少工作量 编译存储过程之后，许多用户和应用程序都可执行相同的语句序列，而不必重新输入和重新向DBMS提交，当执行需要许多SQL语句或是复杂逻辑的语句时，执行已经调试并测试通过的SQL语句批处理，减少了引入程序错误的风险
5）安全性 系统管理员可向单独的用户授予对数据库对象的最小访问权限

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
```
WITH a AS (
  SELECT first_name, last_name, current_date - date_of_birth age
  FROM author
)
SELECT *
FROM a
WHERE age > 10000
```

### 注意

SELECT 语句有很多特殊的规则，至少你应该熟悉以下几条
你仅能够使用那些能通过表引用而得来的字段
如果你有 GROUP BY 语句，你只能够使用 GROUP BY 语句后面的字段或者聚合函数
当你的语句中没有 GROUP BY 的时候，可以使用开窗函数代替聚合函数
当你的语句中没有 GROUP BY 的时候，你不能同时使用聚合函数和其它函数
有一些方法可以将普通函数封装在聚合函数中

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

### 转换函数：

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
```
ALTER TABLE table_name DELETE column_name
```
2.增加列
```
ALTER TABLE table_name ADD (column_name DATA_TYPE [NOT] NULL)
```
3.修改列的空与非空
```
ALTER TABLE table_name MODIFY column_name [NOT] NULL
```
4.修改列名
```
ALTER TABLE table_name RENAME old_column_name TO new_column_name
```
5.快速建立临时表
```
SELECT * INTO [#]table_name FROM .....
```
6、修改表名
```
ALTER TABLE old_table_name RENAME new_table_name
```
7.增加主键约束
```
ALTER TABLE tb_name ADD CONSTRAINT pk_name PRIMARY KEY(col_name,..)
```
8.删除主键约束
```
ALTER TABLE tb_name DROP CONSTRAINT pk_name
```
9.建立自增长字段，与Oracle的SEQUENCE类似
```
CREATE TABLE TMP_001 (RES_ID INTEGER IDENTITY NOT NULL)
```
10.添加表注释
```
COMMENT ON TABLE table_name IS '....'
```
11.创建索引
```
CREATE INDEX index_name ON table_name(column_name)
```

### mysql笔记

USE test
CREATE TABLE users(id int(4) primary key,name varchar(15),password varchar(15))
ALTER TABLE users ADD email VARCHAR(20) ,MODIFY NAME VARCHAR(15)usersusers
重命名 RENAME TABLE USERS TO USER
DROP TABLE USERS

select[distinct][concat(col 1,":",col 2) as col] selection_list
from 表名
group by grouping_columns
order by sorting_columns
having secondary_constraint
limit count 

#### 等同连接
SELECT tb_mrbook.id,tb_mrbook.bookname,author,price 
FROM tb_mrbook,tb_bookinfo 
WHERE tb_mrbook.bookname = tb_bookinfo.bookname 
AND tb_bookinfo.bookname="mysql"

SELECT * FROM tb_bookinfo WHERE bookname LIKE '%m%'

SELECT * FROM tb_mrbook ORDER BY id DESC LIMIT 3
#### 聚合函数（NULL值被忽略）
SELECT COUNT(*) FROM tb_bookinfo 
select sum(price) from tb_bookinfo where price <30.0
select AVG(price) from tb_bookinfo
select MAX(price) from tb_bookinfo

#### 左外连接
SELECT section,tb_login.user,books FROM tb_login LEFT JOIN tb_books ON tb_login.user=tb_books.user
右外连接
RIGHT JOIN
内连接

#### 子查询：
IN 关键字
SELECT * FROM tb_login WHERE USER IN(SELECT USER FROM tb_books)   对应 NOT IN
带比较运算符的子运算符
SELECT id,books,ROW FROM tb_books WHERE ROW>=(SELECT ROW FROM tb_row WHERE id=1)
ANY
select books,row from tb_books where row<ANY(select row from tb_row)
ALL
select books,row from tb_book where row>=ALL(select row from tb_row)

合并查询结果 UNION 合并查询结果并去除重复结果，UNION ALL 不会去除重复
SELECT USER FROM tb_login
UNION 
SELECT USER FROM tb_books

SELECT * FROM tb_login tt WHERE tt.id=1  起别名
SELECT  section AS sss,NAME AS nnn FROM tb_login  为字段取别名

#### 使用正则表达式查询
 SELECT * FROM tb_books WHERE USER REGEXP '[m|l]'
SELECT * FROM tb_books WHERE USER REGEXP 'a*c'   ===> Aric  Eric  Jack  Lucy  abc12   *表示出现0,1，多次
SELECT * FROM tb_books WHERE USER REGEXP 'a*c'   ===> Jack    + 表示出现1次，多次

#### MYSQL函数
1)数学函数 
2)字符串函数 
3)日期和时间函数  
4)条件判断函数 
5)系统信息函数  
6)加密函数 
7)格式化函数和锁函数

#### MySQL索引
当用户通过索引查询数据库中的数据时，不需要遍历所有数据库中的所有数据，大幅度提
高了查询效率
一次编写多次调用--MySQL存储过程
名称不区分大小写

### web安全

所谓SQL注入，就是通过把SQL命令插入到Web表单提交或输入域名或页面请求的查询字符串
最终达到欺骗服务器执行恶意的SQL命令。
将（恶意）的SQL命令注入到后台数据库引擎执行，
它可以通过在Web表单中输入（恶意）SQL语句得到一个存在安全漏洞的网站上的数据库
主要原因是 程序没有细致的过滤用户输入的数据，使得非法数据侵入系统

SQL注入分为平台层注入和代码层注入，前者由于不安全的数据库配置所致，后者由于程序员对输入为进行细致的过滤，执行了非法的数据查询
在某些表单中，用户输入的内容直接用来构造动态sql命令，或者作为存储过程的输入参数，这些表单特别容易受到sql注入的攻击

#### 防止sql注入：
对用户的输入进行校验，可以通过正则表达式，或限制长度，对单引号和双-进行转换等
不使用动态拼装sql，可以使用参数化的sql或者直接使用存储过程进行数据查询存取
不要使用管理员的权限数据库连接，为每个应用使用单独的权限有限的数据库连接
不要把机密信息比如密码明文存放，加密或者hash掉密码和敏感信息
异常信息给出尽可能少的提示，最好使用自定义的错误信息对原始错误信息进行包装
使用专业检测sql注入漏洞的工具平台扫描检测

强制产生错误 使用特殊字符来进行sql注入
通过正则表达校验用户输入
通过参数化存储过程进行数据查询存取
参数化SQL语句 数值以参数化的形式提供
XMLHttpRequest能够产生异步后台请求
同源策略，它是由Netscape提出的一个著名的安全策略。
现在所有支持JavaScript 的浏览器都会使用这个策略。
所谓同源是指，域名，协议，端口相同。
当一个浏览器的两个tab页中分别打开来 百度和谷歌的页面当浏览器的百度tab页执行一个脚本的时候会检查这个脚本是属于哪个页面的，即检查是否同源，只有和百度同源的脚本才会被执行。

同源策略防止javascript读取不相关的域中的内容，当它并没有限制javascript创建指向其他域的元素的能力，能够从src或href属性自动获取
内容的任何元素都有利于黑客攻击。

专业核弹头翻新,改装,潜艇抛光,喷漆.回收二手航母,大修核反应堆,拆洗导弹发动机、清洗航母油槽、航天飞机保养换三滤.高空作业擦洗卫星表面除尘.星球设计，全球海洋保养及维护，南极冰川修复,地球形状改造及时空改变颠倒业务，并批发歼10，F22 F35 B2轰炸机，各类氢/核弹头。量大从优！有正规发票

## sql学习

### 基本sql

#### 查询每个月倒数第2天入职的员工的信息

```
SELECT last_name,hire_date 
FROM employees 
WHERE hire_date = LAST_DAY(hire_date) -1 
```

#### 查询隔行数据

```select row_number() over(order by sno) n wher n % 2 =1```

#### 将空值转换为有效值 

```select sno,bookname,author,isnull(book,'无') as book from tb_space```

#### 第N行数据

```
select * from (select top n from tb_space )aa
where not exist (select * from (select top n-1 from tb_space)bb 
where aa.sno = bb.sno )
```

#### 字符函数

right(xh,len(xh)-1) 从右边开始取指定个数的字符
left(xh,len(xh)-1) 从左边开始去指定个数的字符
substring(expresion,start,length) 子串
select * from tb_space order by 2,3 按照第2列，第3列排序
```
case...when
select(
case job
when '会计' then salary*1.5;
when '秘书' then salary*2.0;
end as new_salary
) order by new_salary
```

#### 对重复的内容不作统计

select count(distinct duty) as duty
不包括最大最小值计算平均值
```
select avg(salary)
from tb_space where salary not in (
    (select min(salary) as minSalary from tb_treatment)
    union 
    (selct max(salary) as maxSalary from tb_treatment)
)
```

### 多列子查询

#### 成对比较的多列子查询

```
SELECT NAME,salary ,department 
FROM employee 
WHERE (salary,department) IN (
     SELECT MAX(salary),department
     FROM employee
     GROUP BY department
)
```

```
SELECT NAME,salary ,department 
FROM employee 
WHERE salary IN (
     SELECT MAX(salary)
     FROM employee
     GROUP BY department
) AND department IN (
SELECT DISTINCT department 
    FROM employee
)
```

接口是 实体把自己提供给外界的一种抽象化说明，用以由内部操作分离出外部沟通方法，使其能被修改内部而不影响外界其他
实体与其交互的方式
#### 二叉树
则对于任意的序号为i的结点有：(1)如i=1，则序号为i的结点是根结点，无双亲结点，如i>1，则序号为i的结点的双亲结点序号
为i/2;（2）如2*i>n,则序号为i的结点无左孩子，如2*i<=n,则序号为i的结点的左孩子结点序号为2*i；(3)如2*i+1>n，则序号为
i的结点无右孩子，如2*i+1<=n,则序号为i的结点的右孩子结点序号为2*i+1;
二叉树含有n个节点，则二叉链表含有2n个指针域，分支数比节点数少1 ，所以 2n-(n-1) = n+1 个空的链域

spring IOC控制反转，控制权交出去，使用容器创建并维护对象
AOP面向切面编程  
DI(dependency injection) 依赖注入  --》 设值注入  构造注入

java在处理基本数据类型（例如int ,char,double）时，都是采用按值传递的方式执行，除此之外的其它类型都是按引用传递的方式执行。
对象除了在函数调用时时引用传递，在使用“=”赋值时也是采用引用传递。

#### webservice小记
WebService是一种跨编程语言和跨操作系统平台的远程调用技术。
Object方法： 
getClass() hashCode()  equals(Object)  clone()  toString()  notify()   notifyAll()   
wait(long) wait(long,int) wait()  finalize()   
通过使用Web Service,我们可以将应用程序转换为网络应用程序，从而使本地的应用程序可以向全世界发布信息或提供某种服务

1.高内聚，低耦合，模块和程序的高度独立性
2.所有的设备都可以像文件一样地操作
3.“命令的相互支持性”，命令们通过一个管道或是重定向，可以互相联系在一起

抽象类和接口的区别
值类型和引用类型的区别
存储过程和函数的区别

表中有A B C三列,用SQL语句实现：当A列大于B列时选择A列否则选择B列，当B列大于C列时选择B列否则选择C列。
select (case when a>b then a else b end ),
(case when b>c then b esle c end)
from table_name

#### 一个日期判断的sql语句？
请取出tb_send表中日期(SendTime字段)为当天的所有记录?
select * from tb where datediff(dd,SendTime,getdate())=0

#### case...when
大于或等于80表示优秀，大于或等于60表示及格，小于60分表示不及格。
select
(case when 语文>=80 then '优秀'
        when 语文>=60 then '及格'
else '不及格') as 语文,
(case when 数学>=80 then '优秀'
        when 数学>=60 then '及格'
else '不及格') as 数学,
(case when 英语>=80 then '优秀'
        when 英语>=60 then '及格'
else '不及格') as 英语,
from table

查询中用到的关键词主要包含六个，并且他们的顺序依次为 
select--from--where--group by--having--order by ->distinct ->top 

1.not and or一起出现时候，not > and > or 优先级顺序
2. 使用表达式生成新列
eg: 
SELECT 10 AS NAME 
UNION ALL 
SELECT 20 
UNION ALL
SELECT  30
UNION ALL  
SELECT 40

#### java
Java可以通过JNI调用本地的C/C++代码，本地的C/C++的代码也可以调用java代码。JNI 是本地编程接口，Java和C/C++互相通过的接口。Java通过C/C++使用本地的代码的一个关键性原因在于C/C++代码的高效性。
-------------------------------------------
#### 重构代码
public bool IsAdult(int age)
{
    var isAdult = age > 18;
    return isAdult;
}
-----------------------------------------
参数过多
public void RegisterUser(string userName, string password, string email, string phone)
{ ... }
重构后
public void RegisterUser(User user)
{ ... }
--------------------------------------------
public void RegisterUser(User user, bool sendEmail)
{ ... }
布尔参数在告诉方法不止做一件事，违反了Do one thing
重构后：
public void RegisterUser(User user)
{ ... }
public void SendEmail(User user)
{ ... }
-------------------------------------------
#### 字符串常量池 
String s1 = "Hello"; 
String s2 = "Hello"; S1=S2=S3 
String s3 = "Hel" + "lo";  S1=S3 S3虽然是拼接的，但拼接的都是已知的字符串，编译器优化
String s4 = "Hel" + new String("lo");  S1!=S3
String s5 = new String("Hello");   S1和S5是否相等
String s6 = s5.intern(); S1=S6 intern()将字符串添加到常量池中 
String s7 = "H"; 
String s8 = "ello"; 
String s9 = s7 + s8; S1!=S9 S7和S8拼接之后在堆中，被S9引用，地址和S1不一样

#### 异或运算及应用
0^a=a
a^a=0
a^b^c=a^c^b 
找出数组中只出现了一次的数（除了一个数只出现一次外，其他数都是出现两次）
升级版：数组中只出现1次的两个数字(百度面试题)。

































