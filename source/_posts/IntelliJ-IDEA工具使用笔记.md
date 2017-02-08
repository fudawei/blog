title: IntelliJ IDEA工具使用笔记
date: 2014-06-09 22:26:49
categories: [Java,开发工具]
tags: [IntelliJ]
---
IntelliJ IDEA 工具使用
[参考极客学院](http://wiki.jikexueyuan.com/project/intellij-idea-tutorial/settings-introduce-1.html)
ctrl+N 输入类名，从下拉列表选择
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
alt+F7  查找该方法，类 在其他地方的使用情况
ctrl+O  覆盖基类方法
ctrl+Q 快速文档
ctrl+B  跳转定义
ctrl+F12  类结构
重命名变量  选中 shift+F6
ctrl+I 实现接口方法
alt+insert  生成getter、setter方法
ctrl+alt+T  surround with
ctrl+shift+空格   补全new
ctrl+shift+backspace  适用于跟代码很深，需要返回原来的编辑位置
Alt+Q  查看当前所属于哪个类
Ctrl+E  最近打开的文件
Ctrl+J  呼出 Live Template abbreviation   eg： it ctrl+J
方法之间有虚线分割： open the editor settings and select the Show method separators check box in the Appearance page.
Alt+Up/Down  当前类的方法之间循环切换
while debugging the program, select its text in the editor (you may press a Ctrl+W a few times to efficiently perform this operation) and press Alt+F8.

To quickly evaluate the value of any expression while debugging the program, hold Alt and click this expression to see its value and calculate it, call a method, etc.

Alt+Shift+C  快速浏览该项目最近操作
Ctrl+空格    完成html,css等的文件名称|属性补全
直接写出文件名称，会提示是否创建该文件
Ctrl+Shift+I 快速浏览某类或方法
Alt+Shift+F10 you can access the Run/Debug dropdown
You can quickly open a Maven project by selecting a pom.xml file in the File | Open dialog. The corresponding Maven project is imported with default settings, without launching the wizard.



eg:
private FileOutputStream 此时按下 ctrl+shift+空格  会补全一个本地变量 fileOutputStream


.IntelliJ IDEA 这个目录保存IntelliJ的配置，如果配置乱了可以删掉这个目录重新设置
1. config 目录：是 IntelliJ IDEA 个性化化配置目录，这个目录主要记录了：IDE 主要配置功能、自定义的代码模板、自定义的文件模板、自定义的快捷键、Project 的 tasks 记录等等个性化的设置。
2. system 目录是 IntelliJ IDEA 系统文件目录，里面主要有：缓存、索引、容器文件输出等等
可以修改 bin/idea.properties里面的  idea.config.path=F:/360SycDir/idea_config/config 来指定config目录位置，同步自己的配置文件
右键 开启Toolbox

Appearance 可以修改主题及主题字体
Font  可以修改代码字体
Console Font 可以修改控制台字体

如果遇到蓝屏断电等情况可能会造成InteliJ崩溃，缓存索引出问题，此时可以点击File-Invalidate Caches 就可以了

编译三种方式
1. Compile： 对选定的目标（java类文件）进行强制性编译，不管目标是否被修改过
2. Rebuild：对选定的目标（Project)进行强制性编译，由于Rebuild的目标是Project，所以时间较长
3. Make   ：使用最多的编译操作，对选定的目标（Project或Module）进行编译，但是只编译修改过的文件

点击项目栏可以直接进行搜索
has no Save button. Since in IntelliJ IDEA you can undo refactorings and revert changes from Local History
Code | Reformat Code  (CTRL+ALT+L)   格式化代码
Code | Optimiza Import (CTRL+ALT+O)  优化导入

Ctrl+F9 Make Project  可以映射Ctrl+S为Make Project，因为IntelliJ没有保存的概念
Shift X 2 可以呼出搜索框
Alt+左右箭头   切换Tab页
Smart completion   Ctrl+Shift+空格
Ctrl+Shift+F12 最大化窗口
Ctrl+E 最近文件
Ctrl+Tab  切换最近文件
Ctrl+F12    类文件结构   可以直接搜索
Shift+Alt+Up/Down   移动行
Ctrl+Y  删除行
查看提示  Alt+Enter
Ctrl+I  实现接口方法
Ctrl+H  在接口文件中查看接口被那些类实现
Ctrl+U  查看源代码
Alt+Left/Right 退回上一层代码

Shift+F10  Run
Shift+F9   Debug
Ctrl+F9    Make
Ctrl+F10   Update application


Shift+F9   Debug
Ctrl+Shift+I  快速浏览该类
Ctrl+Alt+T   Surround With
Ctrl+Alt+J  Surround with live template
Ctrl+Alt+U  UML图
Ctrl+Shift+Alt+T   重命名一个变量
Ctrl+G   定位到行

Ctrl+Shift+A  可以查看搜索所有的快捷键
Alt+Enter  快速修正
Alt+Insert  生成getter、setter方法
在左边的文件位置，可以直接按下Alt+Enter 新建文件
Ctrl+Q  快速浏览API说明
Ctrl+P 查看API参数
Ctrl+Shift+N  查找某个文件并定位到具体行数  Hello:18 表示定位到18行
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

模板用法，可以在  Editor | Live Templates修改，使用的时候Tab即可

### Eclipse VS  IntelliJ IDEA
| template            | Eclipse    | IntelliJ IDEA   |
| ------------------- | ----------| --------------|
| Define a main method|  main      |  psvm    |
| Iterate over an array| for  |  itar  |
| Iterate over a collection| for  |  itco  |
| Iterate over a list |  for  |  itli  |
| Iterate over an iterable | foreach  |  iter  |
| print to System out |  sysout |  sout  |
| print to System err | syserr  |  serr  |

apply a template to an expression you've already typed
eg .ifn   ->   if(..==null){...}Statement
Editor  | General   | Postfix Completion

选中项目 - View -open module settings  - > SDKS   可以指定多种SDK，方便在不同项目中切换
新建的包以层级目录显示 在设置齿轮 Compate empty middle package 去掉勾选

调试
step into   F7
smart step into  shift+F7
step over   F8
step over  F8
step out   shift+F8
Resume    F9
Toggle breakpoint   Ctrl+F8
Evaluate expression Alt+F8

deploying to application servers in IntelliJ IDEA is more or less similar to what you are probably used to in Eclipse

new Date().var 自动赋值给本地变量

断点进入后，点击Drop Frame按钮之后，断点重新回到方法体之外
IntelliJ自动补全功能默认区分大小写，可以在 Code Completion 中把Case sensitive completion 设置为None
Auto Import 中开启自动导包功能

Code Folding  设置哪些类型是默认折叠的
若文件太多行数，可以进行垂直或水平分割修改代码
Debug状态下，如果要批量删除断点，可以点击左下角的红点，选中要删除的断点删除
Ctrl+Alt+T 选择自定义折叠代码区域功能
Editor Tabs show tabs in single row 把Tab分多行显示
Java- Code Generation 把注释放在紧贴代码的头部
Compiler -> 在make或者rebuild过程很慢的时候，可以增加此堆的内存设置，一般大内存的机器设置1500
Editor->General 中设置查看最近文件数量
