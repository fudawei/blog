title: "[Java并发包学习一]Executor和ExecutorService"
date: 2013-08-11 01:05:45
tags: [Java,并发库]
categories: [Java,并发库]
---
本文介绍jdk8并发包中的Executor/ExecutorService这两个接口。
# Executor接口
## 概述
该类提供一个提交任务的方法，提交的任务可以在提交程序本线程运行，也可以在不同的线程运行，也可以在一个线程池中的线程运行，全看如何使用。
> However, the {@code Executor} interface does not strictly
 require that execution be asynchronous. In the simplest case, an executor can run the submitted task immediately in the caller's thread

然而，该接口并没有严格规定提交的任务是异步执行的，最简单的情况，提交的任务可以直接由任务的caller thread执行。
>More typically, tasks are executed in some thread other
than the caller's thread.  The executor below spawns a new thread for each task
<!--more-->
更典型的情况是提交的任务并不是由caller thread执行，而是创建了新的线程去执行，比如线程池。

## execute方法
该接口提供一个方法：
```
void execute(Runnable command);
```
该方法的作用是提交一个任务，这个任务在未来的某一时刻会被执行，该任务可能被新的线程执行，可能被线程池中的线程执行，也有可能就被提交者本身的线程执行。

# ExecutorService接口
## 概述
ExecutorService继承于Executor，它提供一些可以管理任务的执行、取消、结束的方法。
## shutdown方法
```
void shutdown();
```
shutdown方法调用之后，马上拒绝接收新的任务，但是之前已经提交的任务会继续执行。

## shutdownNow方法
```
List<Runnable> shutdownNow();
```
该函数调用之后，马上拒绝接收新的任务，并且会尝试结束当前正在执行的任务，直到所有任务真正结束为止，并且会返回等待执行的任务的列表。

## isShutdown方法
```
boolean isShutdown();
```
该函数判断service是否已经被shutdown，如果调用过shutdown函数，则返回true，否则返回false。

## isTerminated方法
```
boolean isTerminated();
```
该函数判断service中得所有任务是否已经全部执行完毕，并且应该注意的是：**如果没有调用过shutdown函数或者shutdownNow函数，该函数的返回值不可能为true。**

## awaitTermination方法
```
boolean awaitTermination(long timeout, TimeUnit unit)
        throws InterruptedException;
```
该函数会一直阻塞直到所有的任务已经被执行或者等待时间到。

## submit方法
```
<T> Future<T> submit(Callable<T> task);
<T> Future<T> submit(Runnable task, T result);
Future<?> submit(Runnable task);
```
这些函数都是向service提交一个任务，并且返回一个Futrue对象，用于追踪任务的执行情况。区别在于第一个函数在任务执行完毕之后Futrue.get()将会返回任务执行的结果，第二个函数在任务执行完毕之后Future.get()将会返回给定的result结果，而第三个函数在任务执行完毕之后Future.get()将会返回null。

## invokeAll方法
```
<T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks) throws InterruptedException;

<T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks,long timeout, TimeUnit unit)
throws InterruptedException;
```
这些方法比较好理解，就是执行任务列表中的所有任务，并返回与每个任务对应的Futue。也就是说，任务彼此之间不会相互影响，可以通过future跟踪每一个任务的执行情况，比如是否被取消，是正常完成，还是异常完成，这主要使用Future类提供的API。invokeAll是一个阻塞方法，会等待任务列表中的所有任务都执行完成。不管任务是正常完成，还是异常终止，Future.isDone()始终返回true。通过
Future.isCanceled()可以判断任务是否在执行的过程中被取消。通过Future.get()可以获取任务的返回结果，或者是任务在执行中抛出的异常。

## invokeAny方法
```
<T> T invokeAny(Collection<? extends Callable<T>> tasks)
        throws InterruptedException, ExecutionException;

<T> T invokeAny(Collection<? extends Callable<T>> tasks,
      long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
```
上面的函数执行给定的一系列任务，当某一个任务成功执行（没有抛出异常）时，返回该任务对应的Future对象，其他所有未被执行的任务都将取消。如果执行过程中修改了tasks列表，则返回的结果是不确定的。第二个函数带有超时时间。此外还应该注意：
>* 一旦有1个任务正常完成(执行过程中没有抛异常)，线程池会终止>其他未完成的任务 。
>* 如果提交的任务列表中，没有1个正常完成的任务，那么调用invokeAny会抛异常，究竟抛的是哪儿个任务的异常，无关紧要
>* invokeAny()和任务的提交顺序无关，只是返回最早正常执行完成的任务
>* 如果在超时之前，所有任务已经都是异常终止，那就没有必要在等下去了；如果超时之后，仍然有正在运行或等待运行的任务，那么会抛出TimeoutException。 

