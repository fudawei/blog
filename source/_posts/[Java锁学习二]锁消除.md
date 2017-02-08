title: "[Java锁学习二]锁消除"
tags: [Java,内置锁]
categories: [Java,内置锁]
date: 2014-08-01 09:39:10
---
## 概述
锁消除是Java虚拟机在JIT编译是，通过对运行上下文的扫描，去除不可能存在共享资源竞争的锁，通过锁消除，可以节省毫无意义的请求锁时间。
<!--more-->
## 实验
看如下代码：
```
package com.winwill.lock;

/**
 * @author qifuguang
 * @date 15/6/5 14:11
 */
public class TestLockEliminate {
    public static String getString(String s1, String s2) {
        StringBuffer sb = new StringBuffer();
        sb.append(s1);
        sb.append(s2);
        return sb.toString();
    }

    public static void main(String[] args) {
        long tsStart = System.currentTimeMillis();
        for (int i = 0; i < 1000000; i++) {
            getString("TestLockEliminate ", "Suffix");
        }
        System.out.println("一共耗费：" + (System.currentTimeMillis() - tsStart) + " ms");
    }
}
```
getString()方法中的StringBuffer数以函数内部的局部变量，进作用于方法内部，不可能逃逸出该方法，因此他就不可能被多个线程同时访问，也就没有资源的竞争，但是StringBuffer的append操作却需要执行同步操作:
```
    @Override
    public synchronized StringBuffer append(String str) {
        toStringCache = null;
        super.append(str);
        return this;
    }
```
逃逸分析和锁消除分别可以使用参数-XX:+DoEscapeAnalysis和-XX:+EliminateLocks(锁消除必须在-server模式下)开启。使用如下参数运行上面的程序：
> -XX:+DoEscapeAnalysis -XX:-EliminateLocks

得到如下结果：
![这里写图片描述](http://img.blog.csdn.net/20150605143406270)

使用如下命令运行程序：
> -XX:+DoEscapeAnalysis -XX:+EliminateLocks

得到如下结果：
![这里写图片描述](http://img.blog.csdn.net/20150605143628409)

## 结论
由上面的例子可以看出，关闭了锁消除之后，StringBuffer每次append都会进行锁的申请，浪费了不必要的时间，开启锁消除之后性能得到了提高。


