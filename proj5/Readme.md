5. 引入了模块的概念

在com.sum加入了一个上层文件夹ModuleNameMain

并在ModuleNameMain文件夹下增加module-info.java文件

5.1 编译

```
E:\codeRoom\java\javabase\proj4>javac -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

```

注意必须先编译ModuleNameAdd, 因为它被ModuleNameMain需要，必须完全清楚依赖关系

```
E:\codeRoom\java\javabase\proj6>javac -d targets/Main1 ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java
ModuleNameMain\module-info.java:4: 错误: 找不到模块: ModuleNameAdd
    requires ModuleNameAdd;
             ^
1 个错误
```

按照上述模式编译ModuleNameMain还有问题

```
E:\codeRoom\java\javabase\proj6>javac -d targets/Main1 ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java
ModuleNameMain\module-info.java:4: 错误: 找不到模块: ModuleNameAdd
    requires ModuleNameAdd;
             ^
1 个错误

```



```
E:\codeRoom\java\javabase\proj6>javac --module-path targets -d targets/ModueNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

```

yes it works now!!

```
E:\codeRoom\java\javabase\proj6>java --module-path targets -m ModuleNameMain/com.sum.App
Hello world! 8
运行成功，注意到运行时候模块名字下面使用点号进行连接， 而在编译阶段，模块名字后面使用路径的形式，因为编译的是文件的形式
```

--------------------

原因是没有指定 `--module-path targets` 把模块放在那里高速javac.exe，他才能知道去哪里找到模块内部的class文件！
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
E:\codeRoom\java\javabase\proj4>jar --create --file lib/a.jar  -C targets/ModuleNameAdd .
```
注意a.jar名字可以随便起，他只是把ModuleNameAdd的文件结构压缩起来，然后放在a.jar包中，只要他是放在lib文件夹下，都是可以访问的，
jar包形式在同一个文件夹下是皇帝的新装，默认都是以模块形式存在(本质是模块起作用)

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

6. 多模块相互引用

6.1 ModuleNameAdd module-info.java加入exports
6.2 ModuleNameMain module-info.java加入requires
6.3 编译ModuleNameAdd模块 
    E:\codeRoom\java\javabase\proj5>javac -d targets/ModuleNameAdd ModuleNameAdd/module-info.java ModuleNameAdd/com/qny/*.java
    
6.4 编译moduleNameMain模块

E:\codeRoom\java\javabase\proj5>javac --module-path targets -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

注意增加--module-path 必须指定，虽然在ModuleNameMain中的module-info.java requires ModuleNameAdd;但是javac依然不知道module在哪里
所以必须指定！

6.5 运行多模块的主程序
E:\codeRoom\java\javabase\proj5>java --module-path targets -m ModuleNameMain/com.sum.App
Hello world! 8

6.7 制作jmod文件(可以直接运行module)

6.7.1 制作jar

E:\codeRoom\java\javabase\proj5>jar --create --file targets/jars/ModuleNameAdd.jar -C targets/ModuleNameAdd .

E:\codeRoom\java\javabase\proj5>jar --create --file targets/jars/ModuleNameMain.jar -C targets/ModuleNameMain .


E:\codeRoom\java\javabase\proj5\targets\jars>jar tf ModuleNameAdd.jar
META-INF/
META-INF/MANIFEST.MF
module-info.class
com/
com/qny/
com/qny/Mytool.class

6.7.2 制作jmod

切换到6.7.1 jar生成的路径中!

E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameAdd.jar ModuleNameAdd.jmod

E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameMain.jar ModuleNameMain.jmod
