title: '[git]git命令自动补全'
tags: [代码管理,git]
categories: [代码管理,git]
date: 2014-09-02 16:58:32
---
# 背景
在Mac上安装了git之后，发现命令不能自动补全，使用起来非常不方便，本文介绍怎么让git命令能够自动补全。
<!--more-->
# 确保bash能够自动补全
在终端（本文使用的是OS X的终端）执行如下命令：

```
brew list 
```

看看是否已经安装有bash-completion，比如我的机器(已经安装了)运行上面的命令会显示：

>bash-completion	node		openssl		pkg-config	wget

如果没有安装，运行如下命令安装bash-completion：

```
brew install bash-completion
```
等待安装完成之后，运行如下命令：

```
brew info bash-completion
```

运行上面的命令后会在终端显示下图：
![](http://7xlune.com1.z0.glb.clouddn.com/images/git命令自动补全/bash-completion.png)

仔细阅读箭头所指的地方，依照提示将矩形框内的内容添加到~/.bash_profile文件(如果没有该文件，新建)，然后重启终端，bash-completion功能安装完成。

# 让git支持自动补全
从github上clone git的源码到本地：

```
git clone https://github.com/git/git.git
```
找到"contrib/completion/"目录下的git-completion.bash，将该文件拷贝到`~/`目录下下并重命名为.git-completion.bash:

```
cp git-completion.bash ~/.git-completion.bash
```

在~/.bashrc文件中追加如下内容：

```
source ~/.git-completion.bash
```

重启终端，大功告成，现在git能够使用tab键自动补全命令了，enjoy it！

