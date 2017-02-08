title: Python笔记
date: 2015-10-24 13:35:17
categories: [Python]
tags: [Python]
---

import Image 
def test(): 
im = Image.open(‘D:\111.png’) 
(w,h)= im.size 
im.thumbnail((w//2,h//2)) 
im.save(‘D:\thumbnail.jpg’,’jpeg’) 
if name == ‘main‘: 
test()

round(1.15,2) ===> 1.2 
ord(‘a’) ===> 97 #### 字母和数字相互转换 
chr(65) ===> ‘A’ 
divmod(15,6) ===>(2,3)

‘-‘*40 ===> ‘———————————————-’ 
‘an’ in ‘Django’ ===>True 
‘xyz’ not in ‘Django’ ===> True 
字符串拼接用 join “;”.join[‘list1’,’list2’] 
列表扩充 list1.extend(list2)

u’ABC’.encode(‘utf-8’) ####把unicode转为utf-8 
‘abc’.decode(‘utf-8’) ####把utf-8转为unicode

保存python文件时，保存为utf-8格式

！/usr/bin/env python

--coding:utf-8 --

List列表 =[‘jack’,’mike’] 
list.append(‘marry’) 
list[0] list[1] ####根据下标访问制定元素 
list.insert(1,’Jack’) ####插入 
list.pop() ####弹出最后一个元素 
list.pop(1) ####弹出制定元素 
list[1]=’Sarah’ ####赋值 
list 列表 =[‘jack’,’mike’,’marry’] 
s = [‘python’,’java’,list,’scheme’] ####list元素也可以是另一个list 
这样如果要取mike的值， s[2][1]

在序列中循环时，索引位置和对应值可以使用enumerate()函数同时得到 
for i,v in enumerate([‘tic’,’tac’,’tom’]): 
print i,v 
同时循环两个或更多序列，可以使用zip()整体打包 
questions = [‘name’,’quesst’,’favorite’] 
answers = [‘lance’,’the’,’only’] 
for q,a in zip(questions,answers): 
print ‘what is your {0}?it is {1}’.format(q,a) 
pass 语句

def fib(n): 
result = [] 
a,b = 0,1 
while a < n: 
result.append(b) 
a,b = b,a+b 
return result #### 返回一个包含数列的链表 
f100 = fib(100)

tuple 元组的值不能变，更安全 
tuple 当只有一个元素的时候定义： t=(1,) 
当 tuple 中包含list时候，list的值是可以变化的 
eg: t=(‘a’,’b’,[‘A’,’B’]) 
t[2][0]=’x’ t[2][1]=’y’

循环 for 语句 
names = [‘mike’,’marry’,’java’] 
for name in names: 
print name 
for x in [1,2,3,4,5]: 
sum = sum+x 
range(5) ===> 0,1,2,3,4 
1到100的和： 
for x in range(101): 
sum = sum+x

birth = raw_input(‘birth:’)

dict 和 set 
d ={‘mick’:98,’Bob’:93,’marry’:88} 
d[‘mick’] 
d[‘mick’] = 90 
d.pop(‘Bob’)

重复元素在 set 中自动被过滤 
s = set([1,1,2,2,3,3]) 
s ===> set([1,2,3]) 
s.add(4) 
s.remove(4) 
a = set(‘abc’) b = set(‘deab’) 
a - b 
a | b 
a ^ b 
a & b

list 内容可变 比如： a = [‘c’,’b’,’a’] 
a.sort() a===> [‘a’,’b’,’c’] #### 值改变 
tuple　内容不可变　比如：a = ‘abc’ 
b = a.replace(‘a’,’A’) b===>’Abc’ a===>’abc’ ####值不变

import math 
def move(x, y, step, angle=0): 
nx = x + step * math.cos(angle) 
ny = y - step * math.sin(angle) 
return nx, ny ####返回多个值，实质是返回一个tuple 
x,y = move(100,100,60,math.pi/6) 
print x,y

def add_end(L=None): 
if L is None: 
L = [] 
L.append(‘END’) 
return L #### 默认参数必须指向不变对象

def calc(*numbers): 
sum = 0 
for n in numbers: 
sum = sum + n * n 
return sum #### 把函数参数变为可变参数

可变参数允许你传入0个或任意个参数，这些可变参数在函数调用时自动组装为一个tuple。 
而关键字参数允许你传入0个或任意个含参数名的参数，这些关键字参数在函数内部自动组装为一个dict

在Python中定义函数，可以用必选参数、默认参数、可变参数和关键字参数 
*args是可变参数，args接收的是一个tuple 
**kw是关键字参数，kw接收的是一个dict

使用递归函数需要注意防止栈溢出。在计算机中，函数调用是通过栈（stack）这种数据结构实现的， 
每当进入一个函数调用，栈就会加一层栈帧，每当函数返回，栈就会减一层栈帧。 
由于栈的大小不是无限的，所以，递归调用的次数过多，会导致栈溢出 
解决递归调用栈溢出的方法是通过尾递归优化

切片特性： 
L=[‘mick’,’java’,’marry’,’hello’] 
L[:3] L[-3:] 
L = range(100) 
L[:10:2] ####到10为止，步长为2 
eg: ‘ABCDEFG’[::2]

Python的for循环抽象程度要高于Java的for循环 
因为Python的for循环不仅可以用在list或tuple上，还可以作用在其他可迭代对象上

如何判断一个对象是可迭代对象呢？方法是通过collections模块的Iterable类型判断 
from collections import Iterable 
isinstance(‘abc’, Iterable) ####str是否可迭代 
True 
isinstance([1,2,3], Iterable) #### list是否可迭代 
True 
isinstance(123, Iterable) #### 整数是否可迭代 
False

Python内置的enumerate函数可以把一个list变成索引-元素对 
这样就可以在for循环中同时迭代索引和元素本身 
for i, value in enumerate([‘A’, ‘B’, ‘C’]): 
print i, value

列表生成式 ： 
[x*x for x in range(1,11) if x % 2] 
[m + n for m in ‘ABC’ for n in ‘XYZ’] 
squares = map(lambda x:x**2,range(10)) 
[(x,y) for x in [1,2,3] for y in [2,3,1] if x != y]

列出当前目录下的所有文件和目录名 
import os #### 导入os模块，模块的概念后面讲到 
[d for d in os.listdir(‘.’)] #### os.listdir可以列出文件和目录

for循环其实可以同时使用两个甚至多个变量，比如dict的iteritems()可以同时迭代key和value 
d = {‘x’:’A’,’y’:’B’,’z’:’C’} 
for k,v in d.iteritems(): #### 或者[k+’=’+v for k,v in d.iteritems()] 
print k,’=’,v 
L = [‘Hello’,’World’,’IBM’,’Apple’] 
[s.lower() for s in L] 
isinstance(x, str) ####判断是否字符串

生成器： 
g = (x * x for x in range(10))

函数式编程的一个特点就是，允许把函数本身作为参数传入另一个函数，还允许返回一个函数！

Python对函数式编程提供部分支持。由于Python允许使用变量，因此，Python不是纯函数式编程语言 
变量可以指向函数 
如 f = abs 
def add(x,y,f): 
return f(x)+f(y)

Python 内建了 map() 和 reduce() 函数 函数式编程工具 filter(),map(),reduce() 
map()函数接收两个参数，一个是函数，一个是序列，map将传入的函数依次作用到序列的每个元素，并把结果作为新的list返回 
educe把一个函数作用在一个序列[x1, x2, x3…]上，这个函数必须接收两个参数， 
reduce把结果继续和序列的下一个元素做累积计算，其效果就是： reduce(f, [x1, x2, x3, x4]) = f(f(f(x1, x2), x3), x4)

str 类型转化成 int 类型： 
def fn(x, y): 
return x * 10 + y 
def char2num(s): 
return {‘0’: 0, ‘1’: 1, ‘2’: 2, ‘3’: 3, ‘4’: 4, ‘5’: 5, ‘6’: 6, ‘7’: 7, ‘8’: 8, ‘9’: 9}[s] 
reduce(fn, map(char2num, ‘13579’)) 
13579 
def str2int(s): 
return reduce(lambda x,y: x*10+y, map(char2num, s)) ####编写str–>int 函数

和map()类似，filter()也接收一个函数和一个序列。和 map()不同的时，filter()把传入的函数依次作用于每个元素 
eg: 
def is_odd(n): 
return n % 2 == 1 
filter(is_odd, [1, 2, 4, 5, 6, 9, 10, 15]) ==>1,5,9,15

def not_empty(s): 
return s and s.strip() 
filter(not_empty, [‘A’, ”, ‘B’, None, ‘C’, ’ ‘])

[‘A’, ‘B’, ‘C’]

seq = range(8) 
def add(x,y): 
return x+y 
map(add,seq,seq) 
reduce(add,ra nge(1,11))

sorted([12,32,39,45]) 
sorted()函数也是一个高阶函数，它还可以接收一个比较函数来实现自定义的排序 
eg： sorted([12,34,24,54],reversed_sort) 
def reversed_sort(x,y): 
if x >y : 
return -1 
if x < y: 
return 1 
return 0

sorted([‘bob’,’about’,’zo’,’bac’],cmp_ignore_cast)

字典： 
cleese = {} 或者 palin = dict() 都可以创建字典，第二个属于工厂模式

默认字典排序 
def cmp_ignore_case(s1,s2): 
u1 = s1.upper() 
u2 = s2.upper() 
if u1 < u2: 
return -1 
if u1 > u2: 
return 1 
return 0;

在函数调用前后自动打印日志，但又不希望修改now()函数的定义，

这种在代码运行期间动态增加功能的方式，称之为“装饰器”（Decorator）。

字典： tel = {‘jack’:3089,’merry’:2309} 
tel[‘jack’] 
del tel[‘jack’] 
tel.keys() 
‘jack’ in tel

偏函数就是把某些参数固定 
import functools 
int2 = functools.partial(int,base = 2)

面向对象编程——Object Oriented Programming，简称OOP 
“测试驱动开发”（TDD：Test-Driven Development）

我5分钟后到，如果没到，请再读一遍此短信…

os.path.abspath(‘.’) 
‘D:\green\python’ ####得到当前目录

对文件重命名:

os.rename(‘test.txt’, ‘test.py’) 
#### 删掉文件: 
os.remove(‘test.py’)

os.path.splitext()可以直接让你得到文件扩展名

os.path.splitext(‘/path/to/file.txt’) 
(‘/path/to/file’, ‘.txt’)

把一个路径拆分为两部分，后一部分总是最后级别的目录或文件名

os.path.split(‘/Users/michael/testdir/file.txt’) 
(‘/Users/michael/testdir’, ‘file.txt’)

在某个目录下创建一个新目录，

首先把新目录的完整路径表示出来:

os.path.join(‘/Users/michael’, ‘testdir’) 
‘/Users/michael/testdir’

然后创建一个目录:

os.mkdir(‘/Users/michael/testdir’)

删掉一个目录:

os.rmdir(‘/Users/michael/testdir’)

序列化：

序列化之后，就可以把序列化后的内容写入磁盘，或者通过网络传输到别的机器上。

反过来，把变量内容从序列化的对象重新读到内存里称之为反序列化，即unpickling。

区别在于cPickle是C语言写的，速度快

pickle是纯Python写的，速度慢，跟cStringIO和StringIO一个道理

先尝试导入cPickle，如果失败，再导入pickle：

try: 
import cPickle as pickle 
except ImportError: 
import pickle 
d = dict(name = ‘Bob’,age = 20,score = 80) 
f = open(‘dump.txt’,’wb’)

pickle.dump(d,f) 直接把对象序列化后写入一个file-like Object

pickle.dump(d,f) 
f.close()

把任意对象序列化成一个str，然后可以把这个str写入文件

pickle.dumps(d)

import pickle 
with open(‘mydata.pick1’,’wb’) as mysave: #### 以二进制文件打开写入 
pickle.dump([1,2,’three’],mysave) 
with open(‘mydata.pick1’,’rb’) as myread: #### 以二进制文件打开读取 
a_list = pickle.load(myread) #### 腌制数据出现问题PickleError

with open(‘man.pick1’,’wb’) as mysave: 
pickle.dump(man,mysave) 
####包含写入内容和文件名 
except IOError as err: 
print(‘File error’+str(err))

with open(‘www.txt’,’rb’) as mysave: 
data = mysave.readline() 
dd = data.strip().split(‘,’) ####去除字符串的空格，且以“，”分割，存入列表中

list.sort() 改变列表 
sorted(list) 不改变列表

强烈建议使用Python的r前缀，就不用考虑转义 
s = r’ABC-001’ 、

对应的正则表达式字符串不变：

‘ABC-001’

正则表达式切分

如果用户输入了一组标签，下次记得用正则表达式来把不规范的输入转化成正确的数组。

re.split(r’\s+’, ‘a b c’) 
[‘a’, ‘b’, ‘c’] 
re.split(r’[\s,]+’, ‘a,b, c d’) 
[‘a’, ‘b’, ‘c’, ‘d’] 
re.split(r’[\s,\;]+’, ‘a,b;; c d’) 
[‘a’, ‘b’, ‘c’, ‘d’] 
分组 
m = re.match(r’^(\d{3})-(\d{3,8})$’, ‘010-12345’) 
-> m 
<_sre.SRE_Match object at 0x1026fb3e8> 
-> m.group(0) 
‘010-12345’ 
-> m.group(1) 
‘010’ 
-> m.group(2) 
‘12345’

正则表达式默认采用贪婪匹配

eg: re.match(r’^(\d+)(0*)′,‘102300′).groups()===>(‘102300′,”)贪婪匹配re.match(r′(\d+?)(0∗)’, ‘102300’).groups() ===> (‘1023’, ‘00’) ####非贪婪匹配

正则表达式编译优化：

如果一个正则表达式要重复使用几千次，出于效率的考虑，我们可以预编译该正则表达式

import re

编译:

-> re_telephone = re.compile(r’^(\d{3})-(\d{3,8})$’)

使用：

-> re_telephone.match(‘010-12345’).groups() 
(‘010’, ‘12345’) 
-> re_telephone.match(‘010-8086’).groups() 
(‘010’, ‘8086’) 
re_telephone.match(‘010-8086’).group(i) #### group(1)取得第一个

内建模块： 
collections ==> namedtuple deque OrderedDict 
namedtuple 一个点的二维坐标 
from collections import namedtuple 
-> Point = namedtuple(‘Point’, [‘x’, ‘y’]) 
-> p = Point(1, 2) 
-> p.x 
1

isinstance(p, Point) 
Circle = namedtuple(‘Circle’, [‘x’, ‘y’, ‘r’])

deque 
deque是为了高效实现插入和删除操作的双向列表，适合用于队列和栈

from collections import deque ####要用到collection.deque 
-> q = deque([‘a’, ‘b’, ‘c’]) 
-> q.append(‘x’) 
-> q.appendleft(‘y’) 
-> q 
deque([‘y’, ‘a’, ‘b’, ‘c’, ‘x’]) 
deque除了实现list的append()和pop()外，还支持appendleft()和popleft() 
这样就可以非常高效地往头部添加或删除元素。

OrderedDict 在对dict做迭代时，我们无法确定Key的顺序。 
如果要保持Key的顺序，可以用OrderedDict 
od = OrderedDict() 
-> od[‘z’] = 1 
-> od[‘y’] = 2 
-> od[‘x’] = 3 
-> od.keys() #### 按照插入的Key的顺序返回 
[‘z’, ‘y’, ‘x’]

hashlib

摘要算法之所以能指出数据是否被篡改过，就是因为摘要函数是一个单向函数

计算f(data)很容易，但通过digest反推data却非常困难

import hashlib 
md5 = hashlib.md5() 
md5.update(‘how to use’) ####多次调用md5.update() 
md5.update(’ python’) 
a = md5.hexdigest()

md5 = hashlib.md5() 
md5.update(‘how to use python’) ####单次调用md5.update() 
b = md5.hexdigest() 
print a == b #### 计算出md5的值 
from math import pi 
[str(round(pi,i)) for i in range(1,6)]

sha1 用法类似于md5 
与 C++ 语言不通，python中没有定义构造函数new的概念。python会为你完成对象构建 
然后你可以使用init()方法定制对象的初始状态 
目标标识符赋值至self参数

好的web应用应当遵循 模型-试图-控制器(Model-View-Controller) 模式

eg:交换变量 
x = 6 
y = 7 
x, y = y,x

eg:if语句在行内 
print ‘hello’ if True else ‘world’ 
eg:连接 
print str(1) + ‘world’ 
eg:两个列表同时迭代 
nfc = [‘packet’,’hello’] 
afc = [‘River’,’world’] 
for teama,teamb in zip(nfc,afc): 
print teama,teamb 
eg:索引迭代 
for index,team in enumerate(nfc): 
print index,team 
eg:筛选出偶数： 
even=[num for num in nums if num % 2 == 0] 
eg:字典推导： 
teams = [‘packet’,’www’,’river’] 
print {key:value for value,key in enumerate(teams)} 
{‘www’:1,’river’:2,’packet’:0} 
eg:将列表转换成字符串： 
print “,”.join(teams) 
eg:从字典中获取元素： 
data = {‘user’:1,’name’:2,’three’:4} 
print data.get(‘user’,False) 
eg: 
若是3的倍数则打印”Fizz”替换3的倍数，5的倍数打印”Buzz”,既是3的倍数又是5的倍数打印”FizzBuzz” 
for x in range(101): 
print ‘Fizz’[x%3*4:] + ‘Buzz’[x%5*4:] or x

eg：统计次数 Counter库 
from collections import Counter 
print Counter(‘hello’) 
->Counter({‘l’:2,’h’:1,’e’:1,’o’:1}) 
select top(3) with ties * from tablename order by name desc

遍历目录方法： 
import os 
fileList = [] 
rootdir = “/data” 
for root, subFolders, files in os.walk(rootdir): 
if ‘.svn’ in subFolders: subFolders.remove(‘.svn’) 
for file in files: 
if file.find(“.t2t”) != -1:#### 查找特定扩展名的文件 
file_dir_path = os.path.join(root,file) 
fileList.append(file_dir_path) 
print fileList 
print “;”.join(fileList)

列表按列排序 
a = [(‘2011-03-17’, ‘2.26’, 6429600, ‘0.0’), (‘2011-03-16’, ‘2.26’, 12036900, ‘-3.0’), 
(‘2011-03-15’, ‘2.33’, 15615500,’-19.1’)] 
-> print a[0][0] 
2011-03-17 
-> b = sorted(a, key=lambda result: result[1],reverse=True) //第二列排序 
-> print b 
[(‘2011-03-15’, ‘2.33’, 15615500, ‘-19.1’), (‘2011-03-17’, ‘2.26’, 6429600, ‘0.0’), 
(‘2011-03-16’, ‘2.26’, 12036900, ‘-3.0’)] 
-> c = sorted(a, key=lambda result: result[2],reverse=True) //同理，第三列排序

列表去重(list uniq) 
-> lst= [(1,’sss’),(2,’fsdf’),(1,’sss’),(3,’fd’)] //列表里面是元组 
-> set(lst) 
set([(2, ‘fsdf’), (3, ‘fd’), (1, ‘sss’)]) 
-> lst = [1, 1, 3, 4, 4, 5, 6, 7, 6] //列表里面是基本类型 
-> set(lst) 
set([1, 3, 4, 5, 6, 7])

字典,列表,字符串互转 
字典转化为字符串 
-> params = {“server”:”mpilgrim”, “database”:”master”, “uid”:”sa”, “pwd”:”secret”} 
-> [“%s=%s” % (k, v) for k, v in params.items()] 
[‘server=mpilgrim’, ‘uid=sa’, ‘database=master’, ‘pwd=secret’] 
-> “;”.join([“%s=%s” % (k, v) for k, v in params.items()]) 
‘server=mpilgrim;uid=sa;database=master;pwd=secret’

字符串转化为字典 
-> a = ‘server=mpilgrim;uid=sa;database=master;pwd=secret’ 
-> aa = {} 
-> for i in a.split(‘;’):aa[i.split(‘=’,1)[0]] = i.split(‘=’,1)[1] 
-> aa 
{‘pwd’: ‘secret’, ‘database’: ‘master’, ‘uid’: ‘sa’, ‘server’: ‘mpilgrim’}

Python调用系统命令或者脚本 
使用 os.system() 调用系统命令 , 程序中无法获得到输出和返回值 
-> import os 
-> os.system(‘ls -l /proc/cpuinfo’) 
-> os.system(“ls -l /proc/cpuinfo”) 
-r–r–r– 1 root root 0 3月 29 16:53 /proc/cpuinfo 
使用 os.popen() 调用系统命令, 程序中可以获得命令输出，但是不能得到执行的返回值 
-> out = os.popen(“ls -l /proc/cpuinfo”) 
-> print out.read() 
-r–r–r– 1 root root 0 3月 29 16:59 /proc/cpuinfo 
使用 commands.getstatusoutput() 调用系统命令, 程序中可以获得命令输出和执行的返回值 
-> import commands 
-> commands.getstatusoutput(‘ls /bin/ls’) 
(0, ‘/bin/ls’) 
Python读写文件 
一次性读入文件到列表，速度较快，适用文件比较小的情况下 
track_file = “track_stock.conf” 
fd = open(track_file) 
content_list = fd.readlines() 
fd.close() 
for line in content_list: 
print line 
逐行读入，速度较慢,适用没有足够内存读取整个文件(文件太大) 
fd = open(file_path) 
fd.seek(0) 
title = fd.readline() 
keyword = fd.readline() 
uuid = fd.readline() 
fd.close()

写文件 write 与 writelines 的区别 
Fd.write(str) : 把str写到文件中，write()并不会在str后加上一个换行符 
Fd.writelines(content) : 把content的内容全部写到文件中,原样写入，不会在每行后面加上任何东西

import math 
dir(math) 列出math模块包含的函数 
dir(builtins)列出python内置函数 
查询字符串都包含哪些函数 dir(”) 
print(math.tanh.doc) 打印模块函数的说明文档 
将整数和字符串转换为浮点数 float(3) float(‘3.3’) 
将整数和浮点数转换为字符串 str(88) str(9.7) 
字符串转换为整数 int(‘5’) 
全局变量 局部变量 
在函数里面改变全局变量，需要先 global name 声明当前引用的是全局变量

默认值： 
def great(name,greeting = ‘hello’) 
关键字参数 
def shop(where = ‘store’,what = ‘pasta’,howmuch=’10 pounds’) 
shop() shop(what = ‘towels’) shop(howmuch = ‘a ton’,what = ‘towels’,where = ‘bakery’)

模块 引入模块后，import shapes 使用 dir(shapes) 来列出其中的函数

返回文件名的扩展名： 
dot = fname.rfind(‘.’) 
if dot == -1: 
return ” 
else: 
return fname[dot+1:]

字符串函数 
ss.find(‘ee’) 
ss.rfind(‘.’) 从右往左搜索 
ss.index(‘ee’) 
ss.rindex(‘ee’) 
设置格式的函数： 
‘{0} like {1}’.format(‘Jack’,’Ice Cream’) ==>’Jack like Ice Cream’ 
‘{who} {pet} has fleas’.format(pet=’dog’,who=’my’) ==> ‘my dog has fleas’

strip函数 
s.strip(ch) 从s开头和末尾删除在ch中出现的字符 
s.lstrip(ch) 从左侧 
s.rstrip(ch) 从右侧 
name.lstrip() 
name.strip(‘_- ‘)

拆分函数： 
s.partition(t) 将s拆分成3个字符串，head,t,tail 
s.rpartition(t) 
url = ‘www.google.com’ 
url.partition(‘.’) 
(‘www’, ‘.’, ‘google.com’) 
url.rpartition(‘.’) 
(‘www.google’, ‘.’, ‘com’)

s.split() 以t为分隔符，将s划分为一系列字符串，并返回由这些字符串组成的列表。 
s.rsplit() 
s.splitlines() 
url.split(‘.’) 
[‘www’, ‘google’, ‘com’] 
ss = ‘a long time ago, princess ate an apple’ 
ss.split 

ss.split() 
[‘a’, ‘long’, ‘time’, ‘ago,’, ‘princess’, ‘ate’, ‘an’, ‘apple’]

替换函数： 
s = ‘up,up and away’ 
s.replace(‘up’,’down’) 
s.replace(old,new) 将S中的每个old替换为new 
s.expandtabs(n) 将 s中的每个制表符号替换为n个空格

正则表达式 
def is_done(s): 
return re.match(‘done|quit’,s)!=None 
re.match(regex,s)不匹配时返回None，否则返回一个特殊的正则表达式匹配对象

列表函数： 
s.append(x) 
s.count(x) 
s.extend(lst) 
s.insert(i,x) 
s.pop(i) 
s.remove(x) 
s.reverse() 就地反转 
s.sort() 就地排序 
还可以为包含元组的列表进行排序，自然排序 
pst = [(1,2),(1,-1),(2,5),(4,1)] 
pst.sort()

使用列表解析 
cap_name = [n.capitalize() for n in name] 
使用列表解析进行筛选 
result = [n for n in nums if n > 0]

字典中键是唯一的，否则会产生覆盖

字典函数： 
d.items() 
d.keys() 
d.values() 
d.get(key) 获取key对应的value 
d.pop(key) 删除键key并返回与之相关联的值 
d.clear() 
d.copy() d = dict.copy() 
d.fromkeys(s,t) 
d.setdefault(key,v) 如果键包含在字典中，则返回其值；否则返回V并将(key,v)添加到字典中 
d.update(e) 将e中的键值对添加到字典中，e可能是字典，也可能是键值对序列

设置字符串格式： 
print(‘value %.2f’ % x) 如果要在字符串中包含%,必须使用%%。 
格式化字符串 
‘My {pet} has {prob}’.format(pet=’dog’,prob=’fleas’) 
‘My{0} has {1}’.format(‘dog’,’fleas’) 
‘1/81={x}’.format(x=1/81) 
‘1/81={x:.3f}’.format(x=1/81)

os.getcwd() 返回当前目录 
os.lilstdir(p) 返回一个字符串列表，其中包括p指定的文件夹中所有的文件和文件夹的名称 
os.chdir(p) 将当前工作目录设置为p 
os.path.isfile(p) 当p指向一个文件名称是，返回True 
os.path.isdir(p) 目录时，返回True 
os.stat(fname) 返回有关fname的信息，如大小和最后一次修改时间

若提示找不到模块 sys.path.append() 将包含py文件的路径加入到path中即可 
若提示找不到函数 则 使用 模块.函数的方式执行函数 
调用f.read()之后，文件指针指向文件末尾，通过调用f.seek(0),让文件指针重新指向了文件开头，这样写入f时，从开头开始。

若输入年龄不符合要求一直循环，符合要求则返回 
def getAge(): 
while True: 
try: 
n = int(raw_input(‘how old are you’)) 
return n 
except ValueError: 
print(‘please input an integer’) 
if name == ‘main‘: 
getAge()

注意int()讲一个书转化为整数 int(‘12’,16) –> 18 意思是把16进制的12转换为10进制的数字

把字符串中单词的出现频次转化为字典####3

keep = {‘a’,’b’,’c’,’d’,”,’-‘,”’”} 
def normalize(s): 
result = ” 
for c in s.lower(): 
if c in keep: 
result += c 
return result

def make_dict(s): 
s = normalize(s) 
words = s.split() 
d = {} 
for w in words: 
if w in d: 
d[w] += 1 
else: 
d[w] = 1 
return d

计算字典的value的和 
num = sum(d[w] for w in d)

s.swapcase() #####大小写变换 
s.upper() s.lower() 
s.capitalize() #####句首大写 
s.title() #####首字母大写 
print s1.ljust(20) 
print s1.rjust(20,’t’) #####以t填充 
print s1.center(20,’*’)

s1.find(‘of’) #####返回第一次出现的位置 
s1.find(‘of’,6,len(s1))

print s1.rfind(‘of’) 
print rindex(‘of’) 
print s1.count(‘of’) 
print s1.replace(‘of’,’new’)

print s1.strip() #####去除字符串前后空格 
print s1.lstrip() 
print s1.rstrip()

s1.split() ##### 把字符串分开存到列表中 
print s1.split()[2] ##### 访问列表中下标为2的项 
s1.splitlines() #####把一行作为列表中的一个元素

list = [‘mick’,’jerry’,’hello’] 
print ‘+’.join(list)

print s2.startswith(’ ‘) ##### 以某些字符开始 
print s2.endswith(’ ‘) ##### 以某些字符结束

help(‘sys’) #####查看sys模块内置函数 
s4.isalnum() ##### 检查字符串是否由字母和数字组成 
s4.isalpha() #####检查字符串是否只由字母组成 
s4.isdigit() #####检查字符串是否只由数字组成 
s4.isapace() 
s4.isupper() 
s4.islower()

list 不能直接赋值，可以通过列表元素赋值 
eg: list[1:3]=[22,34]

n = [(‘tom’,12,170),(‘jerry’,11,180)] 
for name,age,high in n: 
print ‘name is:’,name

for i in ‘happy’: 
list1.append(ord(i)) 
print list1 <===> list1 = [ord(x) for x in ‘happy’]

tt = [x*y for x in range(10) for y in range(10)] 
str1 = [x+y for x in ‘happy’ for y in ‘good’] 
tuple1 = [(x,y) for x in range(4) for y in range(3)]

访问字典： 
print ‘the is %(a)s,%(b)s’ % {‘a’:123,’b’:456} 
d.clear() #####删除全部元素 
del d[‘a’] #####根据键删除相应值

三种方法： 
for k in d: 
print ‘d[%s]=’%k,d[k] ##### 访问字典的键值 
for(k,v) in d.items(): 
print ‘d[%s]=’%k,v ##### 访问字典的键值 
for (k,v) in zip(d.iterkeys(),d.itervalues()): 
print ‘d[%s]=’%k,v ##### 访问字典的键值

复杂的字典

dict2 = {‘a’:’aa’,’b’:(‘apple’,’orange’),’c’:{‘d’:’dd’,’f’:’ff’}} 
里面嵌套元组，字典 
print dict2[‘c’][‘d’] 
print dict2[‘b’][0]

dict.keys() 
dict.values() 
dict.get(‘a’) #####根据键得到值 
dict2.get(‘f’,’exitst’) ##### 不存在则返回’exitst’

dict1 = {‘a’:’bpp’,’b’:’cpp’,’c’:’app’} 
print sorted(dict1.items(),key = lambda d:d[0]) ##### 以键排序 
print sorted(dict1.items(),key = lambda d:d[1]) ##### 以值排序

import copy 
dict2 = {‘a’:123,’b’:456} 
dict3 = copy.deepcopy(dict2) ##### dict3改变不改变dict2的值 
dict4 = copy.copy(dict2) ##### dict4改变会改变dict2的值

import os 
os.getcwd() ##### 当前工作目录 
os.chdir(‘../python’) ##### 改变工作目录

data = open(‘sketch.txt’) 
print(data.readline(),end = ’ ‘) 
data.seek(0) ##### 使用seek方法返回到文件起始位置 
data.close()

print x, 在变量后面加逗号可以使得print不换行

help(s.split) 查询split()的用法，或者help–>python DOCS

import os 
if os.path.exitst(‘www.txt’)

out = open(‘data.out’,’w’) 
print (‘Norwegian Blues ‘,file = out) 
out.close() ##### 刷新输出

w模式会清除已有内容 
a模式不清除已有内容，追加文件 
w+ 读写，不清除 
若文件不存在，则创建，再进行读写

import os 
def test(): 
man= [] 
other = [] 
try: 
data = open(‘www.txt’) 
for each_line in data: 
try: 
(role,line) = each_line.split(‘:’,1) 
line = line.strip() 
if role == ‘man’: 
man.append(line) 
else: 
other.append(line) 
except ValueError: 
pass 
data.close() 
except IOError as err2: 
print (‘{0}’.format(err2)) 
try: 
man_file = open(‘man_data.txt’,’w’) 
other_file = open(‘other_data.txt’,’w’) 
##### print(man,file=man_file) 
##### print(other,file=other_file) 
man_file.writelines(‘%s’% x for x in man) 
other_file.writelines(‘%s’ % y for y in other) 
except IOError as err: 
print(‘File open error{0}’ % str(err)) 
finally: 
man_file.close() 
other_file.close() 
if name == ‘main‘: 
print(os.getcwd()) 
test()

with语句利用了一种名为上下文管理协议的python技术 
try: 
with open(‘its.txt’,’w’) as data: 
print (‘it\’s ..’,file = data) 
except IOError as err: 
print (‘file error’+str(err))

except IOError as err2: 
print(‘error’+str(err2)) 
print(‘error{0}’.format(err2))

def santi(time_string): 
if ‘:’ in time_string: 
sep = ‘:’ 
elif ‘-’ in time_string: 
sep = ‘-’ 
else: 
return time_string 
(mins,seconds) = time_string.split(sep) 
return mins+’.’+seconds 
def test(): 
data = [‘2.13’,’2:38’,’2-23’] 
list = [santi(ti) for ti in data] 
list.sort() 
print list ##### 对不规则数据进行统一变换

sorted(list2,reverse=True) ##### 逆序排列 
sorted(set(list2),reverse = True)[2:7] ##### 去除重复数据，逆序排列，取2-7个数据

类： 
def santi(time_string): 
if ‘:’ in time_string: 
sep = ‘:’ 
elif ‘-’ in time_string: 
sep = ‘-’ 
else: 
return time_string 
(mins,seconds) = time_string.split(sep) 
return mins+’,’+seconds 
def get_coach_data(filename): 
try: 
with open(filename) as f: 
data = f.readline() 
temp = data.strip().split(‘,’) 
return Athlete(temp.pop(0),temp.pop(0),temp) 
except IOError as ioerr: 
print (‘File error:’+str(ioerr)) 
class Athlete: 
def init(self,a_name,a_dob=None,a_time=[]): 
self.name = a_name 
self.dob = a_dob 
self.times = a_time 
def top3(self): 
return (sorted(set([santi(t) for t in self.times]))[0:3]) 
if name == ‘main‘: 
james = get_coach_data(‘james.txt’) 
print(james.name+“‘s fastest times are:”+str(james.top3()))

.pyc 文件的内容是平台独立的，所以 Python 模块目录可以在不同架构的机器之间共享。

import sys 
sys.path.append(‘utf/guido/lib/python’)

内置函数 dir() 用于按模块名搜索模块定义，返回一个字符串类型的存储列表

对齐方式，rjust(n) n位右对齐，同理 ljust(n)

print str(x).rjust(4),repr(x*x).rjust(4),repr(x*x*x).rjust(4)

str.zfill(6) 向字符串左侧添加0 
eg ‘12’.zfill(5) ===> ‘00012’

str.format() 用法

print ‘{0} and {1}’ . format(‘spam’ , ‘eggs’ )

JPEG 或 EXE 这样的二进制文件，在操作这些文件时一定要记得以二进制模式打开

import os 
os.getcwd() ##### 返回当前工作目录

os.chdir(‘../xx’) ##### 改变当前工作目录 
os.system(‘mkdir today’) ##### 执行命令

应该用 import os 风格而非 from os import * 。这样可以保证随操作系统不

同而有所变化的 os.open() 不会覆盖内置函数 open()

针对日常的文件和目录管理任务， shutil 模块提供了一个易于使用的高级接口

-> import shutil 
-> shutil. copyfile(‘data.db’ , ‘archive.db’ ) 
-> shutil. move(‘/build/executables’ , ‘installdir’ )

glob 模块提供了一个函数用于从目录通配符搜索中生成文件列表

import glob 
-> glob. glob(‘*.py’ ) 
[‘primes.py’, ‘random.py’, ‘quote.py’]

在命令行中执行

python demo.py one two three 后可以得到以下输出结果 
-> import sys 
-> print sys. argv 
[‘demo.py’, ‘one’, ‘two’, ‘three’]

import re 
re. findall(r’ \bf[a-z]*’ , ‘which foot or hand fell fastest’ ) 
[‘foot’, ‘fell’, ‘fastest’] 
re. sub(r’(\b[a-z]+) \1’ , r’ \1’ , ‘cat in the the hat’ ) 
‘cat in the hat’

相对于 timeit 的细粒度， profile 和 pstats 模块提供了针对更大代码块的时间度量工具。

使用元组封装和拆封来交换元素看起来要比使用传统的方法要诱人的多

def f(a,L= []): 
L.append(a) 
return L 
print f(1) 
print f(2) 
print f(3) #####会累积

python fibo.py 50 
if name ==’main‘: 
import sys 
fib(int(sys.argv[1]))

以同样的方式，可以使用**操作符分拆关键字参数为字典 
def parrot(voltage,state=’a stiff’,action=’voom’): 
print ‘this parrot’,action, 
print ‘if you put’,voltage,’hello’, 
print ‘eswe would’,state 
d={‘voltage’:’four mill’,’state’:’Blues’,’action’:’acc’} 
parrot(**d)

python文件操作： 
chmod+x hello.py 为文件添加执行权限 ./hello.py 
文件读取方式 
read([size) 读取size个字节 
readline([size]) 读取一行 
readlines([sizes]) 读取完文件（受buffer大小限制），返回每一行组成的列表；一定要读完的话可以用迭代器 
文件写入方式 
write(str) 将字符串写入文件 
writelines(sequence_of_string) 写多行到文件

mode: 
r 只读方式，文件必须存在 
w 只写方式，文件不存在则创建；存在则清空文件内容 
a 追加方式，文件不存在则创建 
r+/w+ 读写方式打开 
a+ 追加和读写方式打开

type(f) 查看f属性 help(file) 查看file所有方法 help(f.tell) 查看f的tell方法 
f. tab 补齐命令 查看f可以使用哪些命令 
vim yy -》 1000p 产生足够大的数据量 
f = open(‘imooc.txt’) 
itedr_f = iter(f) //使用迭代器对文件进行操作，不消耗大量内存的情况下对文件进行遍历 
lines = 0 
for line in iter_f: 
lines += 1 
python写磁盘时机： 
1.主动调用close()或者flush方法，写缓存同步到磁盘 f.close() f.flush() 
2.写入数据量大于或者等于写缓存，写缓存同步到磁盘 
eg: 
f = open(‘yuchuan.txt’,’w’) 
for i in range(10000): 
f.writelines(‘test write’ + str(i) + ‘\n’) 
此时调到后台执行 
vim yuchuan.txt 
f.close() 
vim yuchuan.txt

python文件为什么要关闭： 
1.将写缓存同步到磁盘 
2.linux系统中每个进程打开文件的个数是有限的 
3.如果打开文件数到了系统限制，在打开文件就会失败

linux下，ps得到PID之后， cat /proc/20384(PID) 列出该进程详细信息 
for i in range(1025): 
list_f.append(open(‘imooc.txt’,’w’)) 
print “%d:%d” % (i,list_f[i].fileno()) //提示打开文件过多 
Seek 
os.SEEK_SET 相对文件起始位置 
os.SEEK_CUR 相对文件当前位置 
os.SEEK_END 相对文件结尾位置

f.read(3) 读入三个字节 
f.tell() 返回当前相对于文件头的偏移位置 
f.seek(0.os.SEEK_SET) 返回文件头 
f.seek(0,os.SEEK_END) 返回文件尾 
f.seek(-5,os.SEEK_CUR) 从当前位置前5个开始读取

python标准文件： 
标准输入： sys.stdin 
标准输出：sys.stdout 
标准错误：sys.stderr

sys模块提供sys.argv属性，通过该属性可以得到命令行参数； sys.argv:字符串组成的列表

f.encoding //查看文件编码 
import codec 
//创建指定编码格式文件 
f = codec.open(‘test.txt’,’w’,’utf-8’,errors,buffering)

使用os模块对文件进行操作 
os.read(fd,buffersize) 
os.write(fd,string) 
os.lseek(fd,pos,how) 文件指针操作 
os.close(fd)

fd = os.open(‘imooc.txt’,os.O_CREAT | os.O_RDWR) 
n = os.write(fd,’imooc’) 
l = os.lseek(fd,0,os.SEEK_SET) 
str1 = os.read(fd,5) 
os.close(fd) 
OS模块常用方法介绍： 
access(path,mode) 判断该文件权限 eg: os.access(‘imooc.txt’,os.F_OK) os.R_OK os.W_OK os.X_OR 
listdir(path) 返回当前目录下所有文件组成的列表 eg: os.listdir(‘./’) 
remove(path) eg: os.remove(‘imooc.txt’) 
rename(old,new) eg: os.rename(‘test/’,’test1’) 
mkdir(path[,mode]) 创建目录 eg: 
mkdirs(path[,mode]) 创建多级目录 
removedirs(path) 
rmdir(path)

os.path 模块方法介绍： 
exists(path) 当前路径是否存在 
isdir(s) 是否是一个目录 
isfile(path) 是否是一个文件 
getsize(filename) 返回文件大小 
dirname(p) 返回路径的目录 
basename(p) 返回路径的文件名

练习 
import ConfigParser 
cfg = ConfigParser.ConfigParser() 
help(cfg.read) 
cfg.read(‘study.txt’) 
help(cfg.sections) 
cfg.sections() 
help(cfg.items) 
for se in cfg.sections(): 
print se 
print cfg.items(se) 
cfg.set(‘userinfo’,’email’,’user@163.com’) 
cfg.set(‘userinfo’,’pwd’,’123456’) 
cfg.remove_option(‘userinfo’,’email’)

Case: 
import os 
import os.path 
import ConfigParser 
”’ 
dump ini 
del section 
del item 
modify item 
add section 
save modify 
”’ 
class student_info(object): 
def init(self,recordfile): 
self.logfile = recordfile 
self.cfg = ConfigParser.ConfigParser() 
def cfg_load(self): 
self.cfg.read(self.logfile) 
def cfg_dump(self): 
se_list = self.cfg.sections() 
print “—->” 
for se in se_list: 
print se 
print self.cfg.items(se) 
print “<—-” 
def delete_item(self,section,key): 
self.cfg.remove_option(section,key) 
def delete_section(self,section): 
self.cfg.remove_section(section) 
def add_section(self,section): 
self.cfg.add_section(section) 
def set_item(self,section,key,value): 
self.cfg.set(section,key,value) 
def save(self): 
fp = open(logfile,’w’) 
self.cfg.write(fp) 
fp.close() 
if name ==’main‘: 
info = student_info(‘study.txt’) 
info.cfg_load() 
info.cfg_dump() 
info.set_item(‘userinfo’,’pwd’,’123456’) 
info.cfg_dump() 
info.add_section(‘login’) 
info.set_item(‘login’,’2015-7-14’,’20’) 
info.cfg_dump() 
info.save()
