title: Spring架构详解：Bean详解和Context组件详解
tags: [Spring]
categories: [JavaEE框架]
date: 2016-12-15 12:53:14
---

# Bean详解

前面已经说明了Bean组件对Spring的重要性，下面看看Bean这个组件式怎么设计的。Bean组件在Spring的org.springframework.beans包下。这个包下的所有类主要解决了三件事：Bean的定义、Bean 的创建以及对Bean的解析。对Spring的使用者来说唯一需要关心的就是Bean的创建，其他两个由Spring在内部帮你完成了，对你来说是透明的。

SpringBean的创建时典型的工厂模式，他的顶级接口是BeanFactory，下图是这个工厂的继承层次关系：

![](/img/spring/spring_bean_factory.png)
BeanFactory有三个子类：ListableBeanFactory、HierarchicalBeanFactory和Autowire Capable Bean Factory。但是从上图中我们可以发现最终的默认实现类是DefaultListableBeanFactory，他实 现了所有的接口。那为何要定义这么多层次的接口呢？查阅这些接口的源码和说明发现，每个接口都有他使用的场合，它主要是为了区分在Spring内部在操作过程中对象的传递和转化过程中，对对象的 数据访问所做的限制。例如ListableBeanFactory接口表示这些Bean是可列表的，而HierarchicalBeanFactory表示的是这些Bean是有继承关系的，也就是每个Bean有可能有父Bean。 AutowireCapableBeanFactory接口定义Bean的自动装配规则。这四个接口共同定义了Bean的集合、Bean之间的关系、以及Bean行为。

Bean的定义主要有BeanDefinition描述，如下图说明了这些类的层次关系：

![](/img/spring/spring_BeanDefinition.png)
Bean的定义就是完整的描述了在Spring的配置文件中你定义的节点中所有的信息，包括各种子节点。当Spring成功解析你定义的一个节点后，在Spring的内部他就被转化 成BeanDefinition对象。以后所有的操作都是对这个对象完成的。 Bean的解析过程非常复杂，功能被分的很细，因为这里需要被扩展的地方很多，必须保证有足够的灵活性，以应对可能的变化。Bean的解析主要就是对Spring配置文件的解析。这个解析过程主要通过 下图中的类完成：
![](/img/spring/spring_analysis.png)


# Context组件详解

Context在Spring的org.springframework.context包下，前面已经讲解了Context组件在Spring中的作用，他实际上就是给Spring提供一个运行时的环境，用以保存各个对象的状态。下面看一下这个 环境是如何构建的。

ApplicationContext是Context的顶级父类，他除了能标识一个应用环境的基本信息外，他还继承了五个接口，这五个接口主要是扩展了Context的功能。下面是Context的类结构图：
![](/img/spring/spring_context.png)

从上图中可以看出ApplicationContext继承了BeanFactory，这也说明了Spring容器中运行的主体对象是Bean，另外ApplicationContext继承了ResourceLoader接口，使得ApplicationContext可以访 问到任何外部资源，这将在Core中详细说明。

ApplicationContext的子类主要包含两个方面：

ConfigurableApplicationContext表示该Context是可修改的，也就是在构建Context中用户可以动态添加或修改已有的配置信息，它下面又有多个子类，其中最经常使用的是可更新的Context，即 AbstractRefreshableApplicationContext类。

WebApplicationContext顾名思义，就是为web准备的Context他可以直接访问到ServletContext，通常情况下，这个接口使用的少。

再往下分就是按照构建Context的文件类型，接着就是访问Context的方式。这样一级一级构成了完整的Context等级层次。

总体来说ApplicationContext必须要完成以下几件事：

标识一个应用环境
利用BeanFactory创建Bean对象
保存对象关系表
能够捕获各种事件
Context作为Spring的Ioc容器，基本上整合了Spring的大部分功能，或者说是大部分功能的基础。

