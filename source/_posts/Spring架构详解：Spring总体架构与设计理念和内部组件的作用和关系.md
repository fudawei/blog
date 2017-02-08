title: Spring架构详解：spring总体架构与设计理念个内部组件的作用和关系
tags: [Spring]
categories: [JavaEE框架]
date: 2016-12-15 12:53:14
---

Spring总体架构与设计理念
概述：

Spring作为现在最优秀的框架之一，已被广泛的使用。本系列文章将从以下角度对Spring的架构进行剖析：设计Spring框架总体结构的理念是什么？包含哪几个核心组件？为什么需要这些组件？它们又是如何结合在一起构成Spring的总体架构？Spring的AOP特性又是如何利用这些基础架构来工作的？

Spring的总体架构

Spring总共有十几个组件，但是真正核心的组件只有几个，下面是Spring框架的总体架构图：
![](/img/spring/spring_infrastructure.png)

从上图中可以看出Spring框架中的核心组件只有三个：Core、Context和Beans。它们构建起了整个Spring的骨骼架构。没有它们就不可能有AOP、Web等上层的特性功能。下面也将主要从这三个组件入手分析Spring。

Spring的设计理念

前面介绍了Spring的三个核心组件，如果再在它们三个中选出核心的话，那就非Beans组件莫属了，为何这样说，其实Spring就是面向Bean的编程（BOP,Bean Oriented Programming），Bean在Spring 中才是真正的主角。

Bean在Spring中作用就像Object对OOP的意义一样，没有对象的概念就像没有面向对象编程，Spring中没有Bean也就没有Spring存在的意义。就像一次演出舞台都准备好了但是却没有演员一样。为什 么要Bean这种角色Bean或者为何在Spring如此重要，这由Spring框架的设计目标决定，Spring为何如此流行，我们用Spring的原因是什么，想想你会发现原来Spring解决了一个非常关键的问题他可以让 你把对象之间的依赖关系转而用配置文件来管理，也就是他的依赖注入机制。而这个注入关系在一个叫Ioc容器中管理，那Ioc容器中有又是什么就是被Bean包裹的对象。Spring正是通过把对象包装在 Bean中而达到对这些对象管理以及一些列额外操作的目的。

它这种设计策略完全类似于Java实现OOP的设计理念，当然了Java本身的设计要比Spring复杂太多太多，但是都是构建一个数据结构，然后根据这个数据结构设计他的生存环境，并让它在这个环境中 按照一定的规律在不停的运动，在它们的不停运动中设计一系列与环境或者与其他个体完成信息交换。这样想来回过头想想我们用到的其他框架都是大慨类似的设计理念。

Spring内部组件的作用和关系
前面说Bean是Spring中关键因素，那Context和Core又有何作用呢？前面吧Bean比作一场演出中的演员的话，那Context就是这场演出的舞台背景，而Core应该就是演出的道具了。只有他们在一起才能 具备能演出一场好戏的最基本的条件。当然有最基本的条件还不能使这场演出脱颖而出，还要他表演的节目足够的精彩，这些节目就是Spring能提供的特色功能了。

我们知道Bean包装的是Object，而Object必然有数据，如何给这些数据提供生存环境就是Context要解决的问题，对Context来说他就是要发现每个Bean之间的关系，为它们建立这种关系并且要维护好 这种关系。所以Context就是一个Bean关系的集合，这个关系集合又叫Ioc容器，一旦建立起这个Ioc容器后Spring就可以为你工作了。那Core组件又有什么用武之地呢？其实Core就是发现、建立和维护每 个Bean之间的关系所需要的一些列的工具，从这个角度看来，Core这个组件叫Util更能让你理解。

它们之间可以用下图来表示：
![](/img/spring/spring_components.png)