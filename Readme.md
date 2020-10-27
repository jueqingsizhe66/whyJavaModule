## 了解java模块定义和相互应用

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [-](#-)
- [Proj1](#proj1)
- [Proj3](#proj3)
- [Proj4](#proj4)
- [proj5](#proj5)


![记录][1]
<!-- markdown-toc end -->


1. Proj1   只是一个main函数
2. Proj2   加入了Mytool类 引用add函数
3. Proj3   引入了包的概念
4. Proj4   引入了模块的概念, 打包模块，打包JRE
5. Proj5   Proj1~4都是单模块的概念，在此步骤引入引入多模块相互引用



## Proj1 

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
## Proj3

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

   在未出现模块的概念时候使用cvfm，而在出现模块概念的时候使用 jar --create --file的方式。
   
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

## Proj4

5. 引入了模块的概念

在com.sum加入了一个上层文件夹ModuleNameMain

并在ModuleNameMain文件夹下增加`module-info.java`文件

  5.1 编译

    ```
    E:\codeRoom\java\javabase\proj4>javac -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

    ```

- `-d`表示产生的targets文件夹 包含ModuleNameMain

  5.2 运行

    ```
    E:\codeRoom\java\javabase\proj4>java --module-path targets -m ModuleNameMain/com.sum.App
    Hello world! 8
    ```

注意包的路径之间用点号， 模块和包用路径名字划分开, 注意模块也是可以使`java.base , javafx.scene` 以点号结合的形式。


  5.3 模块打包

引入模块后可剔除掉manifest.mf, 通过`--main-class`指定运行的主类(创建jar时候使用)

使用单行命令
为什么要在末尾增加一个点号，代表当前目录所有文件?

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

同`jar --create --file`的形式有所不一样

    ```
    E:\codeRoom\java\javabase\proj4>jmod create --class-path lib/ModuleNameMain.jar ModuleNameMain.jmod

    ```

  5.5.2 创建JRE文件夹

下面--add-modules是jmod文件！(只不过省略掉jmod后缀， --module-path类似--classes)
jlink --module-path jmodfile(上个命令生成的jmod文件存放的文件夹) --add-modules ModuleNameButton,ModuleNameMain,java.base --output myapp

`java.base`是默认会增加的模块名字。

    ```
    E:\codeRoom\java\javabase\proj4>jlink --module-path . --add-modules ModuleNameMain,java.base --output myAppOne
    ```

会生成一个JRE文件夹，里头的java.exe就包含这新的模块信息了

    ```
    E:\codeRoom\java\javabase\proj4\myAppOne\bin>java -m ModuleNameMain
    Hello world! 8
    ```

## proj5

6. 多模块相互引用

  6.1 `ModuleNameAdd module-info.java`加入`exports`
  6.2 `ModuleNameMain module-info.java`加入`requires`
  6.3 编译ModuleNameAdd模块 
```
    E:\codeRoom\java\javabase\proj5>javac -d targets/ModuleNameAdd ModuleNameAdd/module-info.java ModuleNameAdd/com/qny/*.java
    
```

  6.4 编译moduleNameMain模块

```
    E:\codeRoom\java\javabase\proj5>javac --module-path targets -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java
```

注意增加`--module-path` 必须指定，虽然在`ModuleNameMain`中的`module-info.java requires ModuleNameAdd`;但是_javac_依然不知道module在哪里
所以必须指定！

  6.5 运行多模块的主程序

<2020-10-27 17:32> 有效！多模块编程的时候只需要运行主程序jar即可。
    ```
    E:\codeRoom\java\javabase\proj5>java --module-path targets -m ModuleNameMain/com.sum.App
    Hello world! 8
    ```

  6.6 制作jmod文件(可以直接运行module)

  6.6.1 制作jar

注意jar和jmod都只是打包压缩的作用，真正编译阶段之时在javac阶段(java compile)

为什么要在jar末尾增加点号?

```

E:\codeRoom\java\javabase\proj5>jar --create --file targets/jars/ModuleNameAdd.jar -C targets/ModuleNameAdd .

E:\codeRoom\java\javabase\proj5>jar --create --file targets/jars/ModuleNameMain.jar -C targets/ModuleNameMain .

E:\codeRoom\java\javabase\proj5\targets\jars>jar tf ModuleNameAdd.jar
META-INF/
META-INF/MANIFEST.MF
module-info.class
com/
com/qny/
com/qny/Mytool.class
```

补充：
    ```
    E:\codeRoom\java\javabase\proj5\MyApp\bin>java -m ModuleNameMain
    模块 ModuleNameMain 不具有 ModuleMainClass 属性，请使用 -m <模块>/<主类>
    ```
    
如果想要能够直接使用ModuleNameMain,那么必须在`jar --create-file`阶段使用`--main-class`开关项    



  6.6.2 制作jmod

切换到6.6.1 jar生成的路径中!

**注意jar文件一般放在lib文件夹下，不要放在jmod同一文件夹下**

```
E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameAdd.jar ModuleNameAdd.jmod

E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameMain.jar ModuleNameMain.jmod
```


  6.6.3 制作可运行的JRE


- 创建JRE文件夹

下面`--add-modules`是jmod文件！(只不过省略掉jmod后缀， --module-path类似--classes)

`jlink --module-path jmodfile(上个命令生成的jmod文件存放的文件夹) --add-modules ModuleNameButton,ModuleNameMain,java.base --output myapp`

`java.base`是默认会增加的模块名字。

    ```
    E:\codeRoom\java\javabase\proj4>jlink --module-path . --add-modules ModuleNameMain,java.base --output myAppOne
    ```

- 会生成一个JRE文件夹，里头的java.exe就包含这新的模块信息了

    ```
    E:\codeRoom\java\javabase\proj4\myAppOne\bin>java -m ModuleNameMain
    Hello world! 8
    ```


[1]: https://github.com/jueqingsizhe66/whyJavaModule/blob/develop/image/ThinkFromModuleUp.jpg
