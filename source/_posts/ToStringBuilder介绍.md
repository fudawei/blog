title: "ToStringBuilder介绍"
date: 2013-06-01 03:33:39
tags: [Java,Java基础]
categories: [Java]
---
### ToStringBuilder简单介绍
ToStringBuilder是用于构建一个类的toString字符串的工具类，提供了多种不同的格式，同时还能自定义打印哪些变量。

### ToStringBuilder主要方法

* append()方法： 该方法用于自定义添加需要打印哪些变量，只有使用append添加的变量才会在toString函数中打印。
* reflectionToString()方法： 该方法使用反射机制打印一个类中的所有变量，该函数还提供一个变量style，用于指定使用什么样的格式打印变量，几种不的style将在下面介绍。
<!--more-->
### 使用示例
下面的代码使用了ToStringBuilder的append方法将index变量添加进去

```
package com.xiaomi.test;

import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author qifuguang
 * @date 15/5/10 22:39
 */
public class Subject {
    private int index;
    private String name;

    public Subject(int index, String name) {
        this.index = index;
        this.name = name;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this).append("index", index).toString();
    }

    public static void main(String[] args) {
        System.out.println(new Subject(1, "subject1").toString());
    }
}
```

运行结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230514295)
可以看到toString仅仅打印了index，但是并没有打印name，所以只有append添加的变量才会被打印。

下面的代码使用了ToStringBuilder的静态方法reflectionToString打印

```
package com.xiaomi.test;

import org.apache.commons.lang.builder.ToStringBuilder;

/**
 * @author qifuguang
 * @date 15/5/10 22:39
 */
public class Subject {
    private int index;
    private String name;

    public Subject(int index, String name) {
        this.index = index;
        this.name = name;
    }

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
    }

    public static void main(String[] args) {
        System.out.println(new Subject(1, "subject1").toString());
    }
}

```
运行结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230428412)
由此可见reflectionToString这个函数默认打印所有变量，上面的示例使用的是默认的style，也就是ToStringStyle.DEFAULT_STYLE；
如果将style换成ToStringStyle.NO_FIELD_NAMES_STYLE，则打印结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230651452)
可以看到并没有打印变量的名字，仅仅打印了变量的值；
如果换成ToStringStyle.MULTI_LINE_STYLE，则打印结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230607254)
可以看到每个变量打印一行；
如果换成ToStringStyle.SHORT_PREFIX_STYLE，则打印结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230839248)
可以看到类前面没有了包名；
如果换成ToStringStyle.SIMPLE_STYLE，则打印结果如下：
![这里写图片描述](http://img.blog.csdn.net/20150510230738499)
可以看到，这次直接没有了类名，直接只一次打印了变量的值。

### 结语
在自定义类的时候往往需要重写toString方法，ToStringBuilder工具类提供了很好支持，如果能够使用该类重写toString，那想必是极好的了。
