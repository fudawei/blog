title: Thrift入门教程
tags: [thrift]
categories: [thrift]
date: 2015-09-11 16:42:30
---
# 概述
Thrift最初由Facebook研发，主要用于各个服务之间的RPC通信，支持跨语言，常用的语言比如C++, Java, Python, PHP, Ruby, Erlang, Perl, Haskell, C#, Cocoa, JavaScript, Node.js, Smalltalk, and OCaml都支持。Thrift是一个典型的CS（客户端/服务端）结构，客户端和服务端可以使用不同的语言开发。既然客户端和服务端能使用不同的语言开发，那么一定就要有一种中间语言来关联客户端和服务端的语言，没错，这种语言就是IDL（Interface Description Language）。
<!--more-->
# Thrift IDL
本节介绍Thrift的接口定义语言，Thrift IDL支持的数据类型包含：

## 基本类型

thrift不支持无符号类型，因为很多编程语言不存在无符号类型，比如java
   
   * byte: 有符号字节
   * i16: 16位有符号整数
   * i32: 32位有符号整数
   * i64: 64位有符号整数
   * double: 64位浮点数
   * string: 字符串  

## 容器类型

集合中的元素可以是除了service之外的任何类型，包括exception。
   
   * list<T>: 一系列由T类型的数据组成的有序列表，元素可以重复
   * set<T>:  一系列由T类型的数据组成的无序集合，元素不可重复
   * map<K, V>: 一个字典结构，key为K类型，value为V类型，相当于Java中的HMap<K,V>  
   
## 结构体(struct) 
   
就像C语言一样，thrift也支持struct类型，目的就是将一些数据聚合在一起，方便传输管理。struct的定       义形式如下：  
 
```
struct People {
     1: string name;
     2: i32 age;
     3: string sex;
}
```
   
## 枚举(enum)  

枚举的定义形式和Java的Enum定义差不多，例如：
   
``` 
enum Sex {
    MALE,
    FEMALE
}
```
   
## 异常(exception)    

thrift支持自定义exception，规则和struct一样，如下：
   
```
exception RequestException {
    1: i32 code;
    2: string reason;
}
```
   
## 服务(service)  

thrift定义服务相当于Java中创建Interface一样，创建的service经过代码生成命令之后就会生成客户端和服务端的框架代码。定义形式如下：
   
```
service HelloWordService {
     // service中定义的函数，相当于Java interface中定义的函数
     string doAction(1: string name, 2: i32 age);
 }
```
   
## 类型定义  

thrift支持类似C++一样的typedef定义，比如：

```
typedef i32 Integer
typedef i64 Long
```
**注意，末尾没有逗号或者分号**

## 常量(const) 
 
thrift也支持常量定义，使用const关键字，例如：
    
```
const i32 MAX_RETRIES_TIME = 10
const string MY_WEBSITE = "http://fudawei.github.io";
```
 
**末尾的分号是可选的，可有可无，并且支持16进制赋值**

## 命名空间

thrift的命名空间相当于Java中的package的意思，主要目的是组织代码。thrift使用关键字namespace定义命名空间，例如：
    
```
namespace java com.winwill.thrift
```

**格式是：namespace 语言名 路径， 注意末尾不能有分号。**

## 文件包含

thrift也支持文件包含，相当于C/C++中的include，Java中的import。使用关键字include定义，例 如：
    
```
include "global.thrift"
```

## 注释

thrift注释方式支持shell风格的注释，支持C/C++风格的注释，即#和//开头的语句都单当做注释，/**/包裹的语句也是注释。
    
## 可选与必选

thrift提供两个关键字required，optional，分别用于表示对应的字段时必填的还是可选的。例如：
    
```
struct People {
    1: required string name;
    2: optional i32 age;
}
```

表示name是必填的，age是可选的。
    
# 生成代码
 知道了怎么定义thirtf文件之后，我们需要用定义好的thrift文件生成我们需要的目标语言的源码，本文以生成java源码为例。假设现在定义了如下一个thrift文件：
 
 ```
namespace java com.winwill.thrift
 
enum RequestType {
    SAY_HELLO,   //问好
    QUERY_TIME,  //询问时间
}

struct Request {
    1: required RequestType type;  // 请求的类型，必选
    2: required string name;       // 发起请求的人的名字，必选
    3: optional i32 age;           // 发起请求的人的年龄，可选
}

exception RequestException {
    1: required i32 code;
    2: optional string reason;
}

// 服务名
service HelloWordService {
    string doAction(1: Request request) throws (1:RequestException qe); // 可能抛出异常。
}
 ```
 
 在终端运行如下命令(前提是已经安装thrift)：
 
 ```
 thrift --gen java Test.thrift
 ```
 则在当前目录会生成一个gen-java目录，该目录下会按照namespace定义的路径名一次一层层生成文件夹，到gen-java/com/winwill/thrift/目录下可以看到生成的4个Java类：
 ![目录结构](http://7xlune.com1.z0.glb.clouddn.com/images/Thrift入门教程/thrift-gen-java.png)
 可以看到，thrift文件中定义的enum，struct，exception，service都相应地生成了一个Java类，这就是能支持Java语言的基本的框架代码。
 
# 服务端实现
上面代码生成这一步已经将接口代码生成了，现在需要做的是实现HelloWordService的具体逻辑，实现的方式就是创建一个Java类，implements com.winwill.thrift.HelloWordService，例如：

```
package com.winwill.thrift;


import org.apache.commons.lang3.StringUtils;
import org.apache.thrift.TException;

import java.util.Date;

/**
 * @author qifuguang
 * @date 15/9/11 15:53
 */
public class HelloWordServiceImpl implements com.winwill.thrift.HelloWordService.Iface {
    // 实现这个方法完成具体的逻辑。
    public String doAction(com.winwill.thrift.Request request) throws com.winwill.thrift.RequestException, TException {
        System.out.println("Get request: " + request);
        if (StringUtils.isBlank(request.getName()) || request.getType() == null) {
            throw new com.winwill.thrift.RequestException();
        }
        String result = "Hello, " + request.getName();
        if (request.getType() == com.winwill.thrift.RequestType.SAY_HELLO) {
            result += ", Welcome!";
        } else {
            result += ", Now is " + new Date().toLocaleString();
        }
        return result;
    }
}

```

# 启动服务
上面这个就是服务端的具体实现类，现在需要启动这个服务，所以需要一个启动类，启动类的代码如下：

```
package com.winwill.thrift;

import org.apache.thrift.server.TServer;
import org.apache.thrift.server.TSimpleServer;
import org.apache.thrift.transport.TServerSocket;

import java.net.ServerSocket;

/**
 * @author qifuguang
 * @date 15/9/11 16:07
 */
public class HelloWordServer {
    public static void main(String[] args) throws Exception {
        ServerSocket socket = new ServerSocket(7912);
        TServerSocket serverTransport = new TServerSocket(socket);
        com.winwill.thrift.HelloWordService.Processor processor = new com.winwill.thrift.HelloWordService.Processor(new HelloWordServiceImpl());
        TServer server = new TSimpleServer(processor, serverTransport);
        System.out.println("Running server...");
        server.serve();
    }
}

```
运行之后看到控制台的输出为：
>Running server...

# 客户端请求
现在服务已经启动，可以通过客户端向服务端发送请求了，客户端的代码如下：

```
package com.winwill.thrift;

import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.transport.TSocket;
import org.apache.thrift.transport.TTransport;

/**
 * @author qifuguang
 * @date 15/9/11 16:13
 */
public class HelloWordClient {
    public static void main(String[] args) throws Exception {
        TTransport transport = new TSocket("localhost", 8888);
        TProtocol protocol = new TBinaryProtocol(transport);

        // 创建client
        com.winwill.thrift.HelloWordService.Client client = new com.winwill.thrift.HelloWordService.Client(protocol);

        transport.open();  // 建立连接

        // 第一种请求类型
        com.winwill.thrift.Request request = new com.winwill.thrift.Request()
                .setType(com.winwill.thrift.RequestType.SAY_HELLO).setName("飞鸟").setAge(24);
        System.out.println(client.doAction(request));

        // 第二种请求类型
        request.setType(com.winwill.thrift.RequestType.QUERY_TIME).setName("飞鸟");
        System.out.println(client.doAction(request));

        transport.close();  // 请求结束，断开连接
    }
}
```
运行客户端代码，得到结果：
> Hello, 飞鸟, Welcome!  
Hello, 飞鸟, Now is 2015-9-11 16:37:22

并且此时，服务端会有请求日志：
> Running server...  
Get request: Request(type:SAY_HELLO, name:飞鸟, age:24)  
Get request: Request(type:QUERY_TIME, name:飞鸟, age:24)  

可以看到，客户端成功将请求发到了服务端，服务端成功地将请求结果返回给客户端，整个通信过程完成。


# 注意事项
* 本文为作者个人理解，如理解有误，请留言相告，感激不尽；
* 本文为作者原创，转载请注明出处，原文地址：[http://fudawei.github.io/2015/09/11/Thrift入门教程/](http://fudawei.github.io/2015/09/11/Thrift入门教程/)

