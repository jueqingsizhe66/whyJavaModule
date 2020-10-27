1. 编译
```
E:\codeRoom\java\javabase\proj3>javac com/sum/*.java`
```
2. 运行
```
E:\codeRoom\java\javabase\proj3>java com.sum.App
Hello world! 8

```
    `

3. 加入了包的概念

4. 打包jar
 
4.1 编写manifest.mf
```
Manifest-Version: 1.0
Class-Path: .
Main-Class: com.sum.App
Created-By: 14.0.2 (Oracle Corporation)
```
4.2  创建可执行jar包
```
E:\codeRoom\java\javabase\proj3>jar cvfm hello.jar manifest.mf com/sum/App.class
已添加清单
正在添加: com/sum/App.class(输入 = 610) (输出 = 407)(压缩了 33%)

```
4.3 运行jar包
```
E:\codeRoom\java\javabase\proj3>java -jar hello.jar
Hello world! 8
```


5. 引入了模块的概念

在com.sum加入了一个上层文件夹ModuleNameMain

并在ModuleNameMain文件夹下增加module-info.java文件

5.1 编译

```
E:\codeRoom\java\javabase\proj4>javac -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

```

- -d表示产生的targets文件夹 包含ModuleNameMain

5.2 运行

```
E:\codeRoom\java\javabase\proj4>java --module-path targets -m ModuleNameMain/com.sum.App
Hello world! 8
```
注意包的路径之间用点号， 模块和包用路径名字划分开。


5.3 模块打包

可以剔除掉manifest.mf

使用单行命令

```
E:\codeRoom\java\javabase\proj4>jar --create --file lib/ModuleNameMain.jar --main-class com.sum.App -C targets/ModuleNameMain .
```

注意了targets后面得加上模块名字，否则运行时候报错！

5.4 运行打包后的模块

```
E:\codeRoom\java\javabase\proj4>java -p lib -m ModuleNameMain
Hello world! 8
```

注意 `-p`表示的模块jar包的输出路径

5.5 创建一个可打包的JRE

5.5.1 创建jmod文件

```
E:\codeRoom\java\javabase\proj4>jmod create --class-path lib/ModuleNameMain.jar ModuleNameMain.jmod

```

5.5.2 创建JRE文件夹

下面--add-modules是jmod文件！(只不过省略掉jmod后缀， --module-path类似--classes)
jlink --module-path jmodfile(上个命令生成的jmod文件存放的文件夹) --add-modules ModuleNameButton,ModuleNameMain,java.base --output myapp

```
E:\codeRoom\java\javabase\proj4>jlink --module-path . --add-modules ModuleNameMain,java.base --output myAppOne
```

会生成一个JRE文件夹，里头的java.exe就包含这新的模块信息了
```
E:\codeRoom\java\javabase\proj4\myAppOne\bin>java -m ModuleNameMain
Hello world! 8
```
