title: Markdown语法
date: 2016-01-17 22:37:19
categories: [markdown]
tags: [markdown]
---
```
* hello world           *代表项目编号
``` System.out.println()
```                      代码风格
[on GitHub](https://github.com/jbt/markdown-editor)  超链接
[StackEdit][6]   [6]: https://github.com/benweet/stackedit    超链接
- **hello world**   **xxx** 加粗 等同于 ctrl+B,斜体 ctrl+I
 - 加粗    `Ctrl + B`
 - 斜体    `Ctrl + I`
 - 引用    `Ctrl + Q`
 - 插入链接    `Ctrl + L`
 - 插入代码    `Ctrl + K`
 - 插入图片    `Ctrl + G`
 - 提升标题    `Ctrl + H`
 - 有序列表    `Ctrl + O`
 - 无序列表    `Ctrl + U`
 - 横线    `Ctrl + R`
 - 撤销    `Ctrl + Z`
 - 重做    `Ctrl + Y`

表格
项目  |  价格  | 总结
------|--------| -------
使用冒号对齐
| :-------- | --------:| :--: |
项目1
	定义A     : 定义A
hello world [^footnote]  生成脚注
[TOC]  生成目录
公式 $$E=mc^2$$

```flow                 --流程图
st=>start: Start
op=>operation: Your Operation
cond=>condition: Yes or No?
e=>end

st->op->cond
cond(yes)->e
cond(no)->op```

~~helloworld~~ 删除线

```
