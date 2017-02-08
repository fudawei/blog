title: Python学习笔记
date: 2016-05-12 15:36:20
categories: [Python]
tags: [Pycharm]
---
You can try out the features described in the tips while this dialog stays open on the screen.

pyCharm Tips ->
Open directory -> Open in current window -> Add to currently opended projects
Ctrl+shitf+T 快速打开类

Ctrl+空格  快速补全
ctrl+空格 两次，补全类名无论该类是否被引入
Ctrl+G find usages in the popup menu
ctrl+shift+空格  View | Quick Document   查看方法文档 （查看外部文档 用 Shift+F2）
F3    jump to declarations
ctrl+F3   浏览该类大致结构   Navigate  | File Structure
alt+shift+R     快速重命名    Refactor | Rename
补全的时候使用Tab
shift+click 或者 鼠标中键
alt+F1
ctrl+D  重复所选块
ctrl+p   此时，如果光标在括号中间，可以显示所需参数
ctrl+q   最后一次修改的地方
ctrl+shift+上    移动
alt+enter  自动导入包
alt+F7  查找该方法在其他地方的使用情况
ctrl+o  覆盖基类方法




pyCharm 中安装模块两种方式：
1. FIle - Settings - Project Interpreter
2. tar.gz 包安装模块  解压 -> python  setup.py install

Question
1. Non-ASCII character '\xe5' in file ……
# -*- coding: UTF-8 -*-
或者
#coding=utf-8
!# /usr/bin/python

### python语法
1. python中的类采用CapWords约定，每个单词的首字母要大写，其他字母小写。
2. 类的私有属性、私有方法以两个下划线作为前缀，对象铜通过点操作符来访问类中的属性和方法。
3. self相当于Java语言中的this关键字，表示本类
4. 方法名的首字母小写，其后每个单词的首字母要大写
行内注释应该至少用两个空格和语句分开，他们以#和单个空格开始

eg:
class MyClass:
    __username = ''
    password = ''
    def __init__(self,username,password):
        self.__username = username
        self.password = password

    def getUserName(self):
        return self.__username + self.password

if __name__ == "__main__":
    myclass = MyClass('hello','pass')
    print myclass.getUserName()

python中的长整型相当于java的BigInteger类型，数字后面加上“L”,范围为正负 20亿
以单下划线开头的(_foo)代表不能直接访问的类属性，需通过类提供的接口进行访问
以双下划线开头的(__foo)代表类的私有成员
以双下划线开头和结尾(__foo__)代表Python中特殊方法专用的标识，例如 __init__() 代表类的构造函数
** python不支持C语言中的自增和自减操作 **

str()函数：把值转换为合理形式的字符串，以便用户理解
repr()函数：创建一个字符串，以合法的Python表达式形式来表示值
eg:
print repr('my name is max')   ==>  'my name is max'
print repr(12345L)   ==>    12345L
print str('my name is max')   ==>   my name is max
print str(12345L)   ==>    12345

input()函数是把读入的用户输入数据默认为Python表达式，而raw_input()函数是把读入的数据转换为字符串。

str1.decode('gb2312')  表示将gb2312编码的字符串str1转换成Unicode编码
str2.encode('gb2312')  表示将Unicode编码的字符串str2转换成gb2312编码

# -*- coding:utf-8 -*-
# for循环可以迭代字典、字符串、列表、元组
dict= {
    'one' : '1',
    'two' : '2',
    'three' : '3'
}
for key in dict:
    print key+':'+dict[key]
zifu = 'yang'
for zz in zifu:
    print zz

shuzu = [(1,2),(3,4),(5,6)]
for (a,b) in shuzu:
    print a,b

for a in shuzu:
    print a

读取文件
with open("ceshi.txt") as ff:
    for readline in ff:
        print readline
迭代：
mys = ['one','two','three','four']
my = iter(mys)
print my.next()
print my.next()
print my.next()
print my.next()

for my in iter(mys):
    print my

并行迭代 使用zip()或者enumerate()
# -*- coding:utf-8 -*-
names = ['one','two','three','four']
ages = [22,23,34,45]
for name,age in zip(names,ages):
    print name,u'年龄是',age

关键字查询(使用enumerate并行迭代)
# -*- coding:utf-8 -*-
zifu = raw_input('please the key:')
list = ['sun flower','red flower','blue flower','green grass']
for index, lst in enumerate(list):  #index为索引
    if zifu in lst:
        print lst

exec语句用来动态的创造Python代码，然后将其作为语句执行
eg: exec 'print "hello world"'
如果没有 __init__.py 文件，python不能识别对应的包。__init__.py文件可以为空，用于标志当前文件夹是一个包

# 参数封装为元组传递
def login(* userpwds):
    username = userpwds[0]
    password = userpwds[1]
    if(username == 'admin') and (password == 'admin'):
        print 'success'
    else:
        print 'fail'
login('admin','admin')
# 参数为字典传递
def login2(** userpwds):
    keys = userpwds.keys()
    username = ''
    password = ''
    for key in keys:
        if 'username' == key:
            username = userpwds[key]
        if 'password' == key:
            password = userpwds[key]
    if(username == 'admin') and (password == 'admin'):
        print 'success'
    else:
        print 'fail'
login2(username='admin', password='admin')
如果函数的参数类型既有元组(形式参数前加*)，又有字典(形式参数钱加**),那么*必须写在**的前面。

返回多个参数
def operate(x, y, z):
    x = x + 5
    y = y + 5
    z = z + 5
    oper = [x,y,z]
    numbers = tuple(oper)
    # 打包到元组中
    return numbers
x, y, z = operate(1, 2, 3)  # 解包元组
print x, y, z

创建一个名称为myFirstModule.py的文件，即定义了一个名称为myFirstModule的模块
def myFun1():
    print 'myFun1'

def myFun2():
    print 'myFun2'

class MyClass:
    def myClassFun(self):
        print 'MyClass myClassFun'
导入该模块
# -*- coding:utf-8 -*-
import  myFirstModule
myFirstModule.myFun1()
myFirstModule.myFun2()
myclass = myFirstModule.MyClass()
myclass.myClassFun()

python中的from ... import 语句可以将模块中的类或函数导入，从而不需要使用模块名作为前缀
eg: from  addPerson import  Person
导入一个模块下的所有类和函数，可以使用   from module_name import *
global 引用全局变量

模块内置函数
1. apply()  把输入参数放入元组或列表传递给函数
def login(username, password):
    msg = ''
    if(username == 'admin') and (password == 'admin'):
        msg = 'success'
    else:
        msg = 'fail'
    return msg
print apply(login,('admin','admin'))

2. filter()  返回符合条件的元素
def validate(usernames):
    if(len(usernames) > 4) and (len(usernames) < 12):
        return usernames
print filter(validate,('admin','maxinaglin','mxl','adm','wangling'))

3. reduce() 实现连续处理功能
def operate(x, y):
    return x*y
print reduce(operate,(7,8,9),0)  # 初始值为0,连乘

4. map()  可以对多个序列中的每个元素执行相同的操作
def add1(a):
    return a + 1
def add2(a, b):
    return a + b
def add3(a, b, c):
    return a + b + c

a1 = [1,2,3,4,5]
a2 = [1,2,3,4,5]
a3 = [1,2,3,4,5]

b = map(add1, a1)
print b
b = map(add2, a1, a2)
print b
b = map(add3, a1, a2, a3)
print b

5. 随机生成四位数并判断奇偶数
import random
allNums = []
for each in range(10):
    allNums.append(random.randint(1000, 9999))
print u'随机从1000-9999生成的四位数'+str(allNums)
print u'偶数为:'+str(filter(lambda n : n%2==0, allNums))
print u'奇数为:'+str(filter(lambda n : n%2==1,allNums))
输出 ==>
随机从1000-9999生成的四位数[1382, 7860, 5015, 6757, 7185, 2757, 1802, 8612, 2294, 8688]
偶数为:[1382, 7860, 1802, 8612, 2294, 8688]
奇数为:[5015, 6757, 7185, 2757]

分片
userList = list('python')
print userList
userList[2:] = list('rite')
print userList
输出 ==>
['p', 'y', 't', 'h', 'o', 'n']
['p', 'y', 'r', 'i', 't', 'e']

numbers = [0,6]
numbers[1:1] = [1,2,3,4]  # 相当于插入
print numbers
输出 ==>
[0, 1, 2, 3, 4, 6]

userList = ['001','002','003','004','005','006']
subUser1 = userList[-3:-1]
subUser2 = userList[0:-2]
输出 ==>
['004', '005']
['001', '002', '003', '004']

userList1 = ['001','002','003','004','005','006']
userList2 = ['aaa','bbb']
userList = [userList1,userList2]
print userList
print userList[0][1]
print userList[1][1]
输出 ==>
[['001', '002', '003', '004', '005', '006'], ['aaa', 'bbb']]
002
bbb
利用for遍历
for i in range(len(userList)):
    for j in range(len(userList[i])):
        print userList[i][j]

列表的连接
使用extend()或者+运算符
userList1.extend(userList2)   extend修改了被扩展的列表，并非真正连接两个列表返回一个全新的列表
userList1 = userList1 + userList2

列表去重
checked = []
def fruitFun(fruitList):
    global  checked
    for e in fruitList:
        if e not in checked:
            checked.append(e)
fruitList = ['apple','banana','apple','strawberry','pear','banana']
fruitFun(fruitList)
print checked

迭代字符串
zifu='yang'
for zi in zifu:
	print zi
'y','a','n','g'

ctrl+E   最近的文件
双击shift   搜索
ctrl+shift+N  找某一个文件

更新&&迭代
userDic = [('002','June'), ('003','Tom')]
dic_userDic = dict(userDic)
print dic_userDic
dic_userDic['004'] = 'hello'
print dic_userDic
del(dic_userDic['002'])

print dic_userDic

for key in dic_userDic:
    print 'userDic[%s] = ' % key ,dic_userDic[key]
for (key,value) in dic_userDic.items():
    print 'userDic[%s] = ' %key,value
for key in dic_userDic.itervalues():
    print key
for (key,value) in zip(dic_userDic.iterkeys(), dic_userDic.itervalues()):
    print 'userDic[%s]=' % key,value
print dic_userDic.has_key('003')

newDIc={'003':'new'}
dic_userDic.update(newDIc)
print dic_userDic


letter1 = ['a','b','c','d']
sep = '-'
print sep.join(letter1)
print '/'.join(letter1)
输出 ==>
a-b-c-d
a/b/c/d

内置方法
class Person:
    def __init__(self, name):
        self.name = name
        self.age = 11
    def sayHi(self):
        print 'hello,my name is ',self.name
        print '\nage is ',self.age
p = Person('yuchuan')
p.sayHi()
__init__方法是构造函数，在程序中起到初始化对象的作用

copyfile()和move()使用shutil模块

凡是可以序列化的对象都可以持久化
python中主要使用一些模块（例如dbhash、anydbm和shelve）完成持久化操作


2.
代码片段
#coding=utf-8
1. 比较文件的不同
# -*- coding: UTF-8 -*-
import difflib
text1="""text1:  ###定义字符串1
hello world
add String"""
text1_line = text1.splitlines()
text2="""text2:  ###定义字符串2
hello
add string"""
text2_line = text2.splitlines()
d = difflib.Differ()
diff = d.compare(text1_line,text2_line)
print '\n'.join(list(diff))
### 后面三行换成如下，可以输出html美观页面
d = difflib.HtmlDiff()
print d.make_file(text1_line,text2_line)

2. 根据输入的IP或子网返回网络、掩码、广播、反向解析、子网数、IP类型等信息
from IPy import IP
ip_s = raw_input('Please input an IP or net-range')
ips=IP(ip_s)
if len(ips) > 1:
    print('net: %s' % ips.net())
    print('netmask: %s' % ips.netmask())
    print('broadcast: %s' % ips.broadcast())
    print('reverse address: %s' % ips.reverseName())
    print('subnet: %s' % len(ips))
else:
    print('reverse address %s' % ips.reverseName()[0])
print('hexadecimal: %s' % ips.strHex())
print('binary ip: %s' % ips.strBin())
print('iptype: %s' % ips.iptype())

3. 发送邮件
# -*- coding:utf-8 -*-
import smtplib
import string
from smtplib import SMTP_SSL
HOST="smtp.163.com"
SUBJECT="Test email from Python"
TO="735699812@qq.com"
FROM="yuchuan512@163.com"
text="Python rules them all"
BODY=string.join(("FROM: %s" % FROM,
                  "To: %s" % TO,
                  "SUBJECT: %s" % SUBJECT,
                  "",text),"\r\n")
server = SMTP_SSL(HOST)
server.login("yuchuan512@163.com","Yu**2")
server.sendmail(FROM,TO,BODY)
server.quit()

3.1 邮件发送html网页
# -*- coding:utf-8 -*-
import smtplib
from smtplib import SMTP_SSL
from email.mime.text import MIMEText
HOST = "smtp.163.com"
SUBJECT = u"流量数据报表"
TO = "735699812@qq.com"
FROM="yuchuan512@163.com"
msg=MIMEText("""<table width="800" border="0" cellspacing = "0" cellpadding = "4">
    <tr>
        <td bgcolor="#CECFAD" height="20" style="font-size:14px">官网数据<a href=""></a></td>
    </tr></table""", "html", "utf-8")
msg['Subject'] = SUBJECT
msg['From'] = FROM
msg['To'] = TO
server = SMTP_SSL(HOST)
server.login("yuchuan512@163.com", "Yu**2")
server.sendmail(FROM, TO, msg.as_string())
server.quit()
3.2 发送带图片附件的邮件
# -*- coding:utf-8 -*-
import smtplib
from email.mime.image import MIMEImage
from email.mime.multipart import MIMEMultipart
from smtplib import SMTP_SSL
from email.mime.text import MIMEText
HOST = "smtp.163.com"
SUBJECT = u"流量数据报表"
##TO = "735699812@qq.com"
TO = "yuchuan512@163.com"
FROM="yuchuan512@163.com"

def addimg(src, imgid):
    fp = open(src,'rb')
    msgImage = MIMEImage(fp.read())
    fp.close()
    msgImage.add_header('Content-ID', imgid)
    return msgImage

msg = MIMEMultipart('related')

msgText=MIMEText("""<table width = "800" border = "0" cellspacing = "0" cellpadding = "4">
    <tr>
        <td bgcolor = "#CECFAD" height = "20" style = "font-size:14px">官网数据<a href=""></a></td>
    </tr>
    <tr>
        <td><img src = "cid:a1"></td>
        <td><img src = "cid:a2"></td>
    </tr>
    <tr>
        <td><img src = "cid:a3"></td>
        <td><img src = "cid:a4"></td>
    </tr>

    </table""", "html", "utf-8")
msg.attach(msgText)

msg.attach(addimg("../img/a1.png", "a1"))
msg.attach(addimg("../img/a2.png", "a2"))
msg.attach(addimg("../img/a3.png", "a3"))
msg.attach(addimg("../img/a4.png", "a4"))

try:
    msg['Subject'] = SUBJECT
    msg['From'] = FROM
    msg['To'] = TO
    server = SMTP_SSL(HOST)
    server.login("yuchuan512@163.com", "Yu**12")
    server.sendmail(FROM, TO, msg.as_string())
    server.quit()
    print 'success'
except Exception,  e:
    print '失败'+str(e)





