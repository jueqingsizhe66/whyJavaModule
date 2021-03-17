## 了解java模块定义和相互应用

从manifest.mf看到了包的一层,可以指定启动函数，从module.info看到了模块的一层(可见与不可见)，
没有任何问题是加入一层无法解决的，如果还无法解决，接着加！
从命令行的角度出发，加入一层，会使得你的options增加了几个，比如-d指定模块路径，跟随module-info.java文件等相关选项
命令行就是流的思路(类似于Servlet控制层，夹带service函数，引入model层，service之后带入model的Dao层,实现CM控制
流畅才能解决问题,慢慢来,会很快，在这之前，得多想; 这可以指代javac、java、jlink、jmod、目标、远景、领头人)
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

## Proj3

3. 加入了包的概念

### 4. 打包jar
 
####  4.1 编写manifest.mf

```
Manifest-Version: 1.0
Class-Path: .
Main-Class: com.sum.App
Created-By: 14.0.2 (Oracle Corporation)

```

####  4.2  创建可执行jar包

   在未出现模块的概念时候使用cvfm，而在出现模块概念的时候使用 jar --create --file的方式。
   
```
E:\codeRoom\java\javabase\proj3>jar cvfm hello.jar manifest.mf com/sum/App.class
已添加清单
正在添加: com/sum/App.class(输入 = 610) (输出 = 407)(压缩了 33%)

```

####  4.3 运行jar包

```
E:\codeRoom\java\javabase\proj3>java -jar hello.jar
Hello world! 8
```

## Proj4

### 5. 引入了模块的概念

在com.sum加入了一个上层文件夹ModuleNameMain

并在ModuleNameMain文件夹下增加`module-info.java`文件

####  5.1 编译

```
E:\codeRoom\java\javabase\proj4>javac -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java

```

`com.sum`包也需要输出，这样可以直接访问App类， 包名字只有exports才能被外界访问
<2020-10-28 00:36> 洗澡的时候想到，这是项目中黑色区域，经常会忘记，细节决定成败!
```
module ModuleNameMain
{
    exports com.sum;
    requires ModuleNameAdd;
}
```

- `-d`表示产生的targets文件夹 包含ModuleNameMain

####  5.2 运行

```
E:\codeRoom\java\javabase\proj4>java --module-path targets -m ModuleNameMain/com.sum.App
Hello world! 8
```

注意包的路径之间用点号， 模块和包用路径名字划分开, 注意模块也是可以使`java.base , javafx.scene` 以点号结合的形式。


####  5.3 模块打包

引入模块后可剔除掉manifest.mf, 通过`--main-class`指定运行的主类(创建jar时候使用)

使用单行命令
为什么要在末尾增加一个点号，代表当前目录所有文件?

```
E:\codeRoom\java\javabase\proj4>jar --create --file lib/ModuleNameMain.jar --main-class com.sum.App -C targets/ModuleNameMain .
```

注意了targets后面得加上模块名字，否则运行时候报错！

####  5.4 运行打包后的模块

```
E:\codeRoom\java\javabase\proj4>java -p lib -m ModuleNameMain
Hello world! 8
```

注意 `-p`表示的模块jar包的输出路径

####  5.5 创建一个可打包的JRE

#####  5.5.1 创建jmod文件

同`jar --create --file`的形式有所不一样

```
E:\codeRoom\java\javabase\proj4>jmod create --class-path lib/ModuleNameMain.jar ModuleNameMain.jmod

```

#####  5.5.2 创建JRE文件夹

下面`--add-modules`是jmod文件！(只不过省略掉jmod后缀， `--module-path`类似`-C`)
`jlink --module-path jmodfile`(上个命令生成的jmod文件存放的文件夹) `--add-modules ModuleNameButton,ModuleNameMain,java.base --output myapp`

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

### 6. 多模块相互引用

####  6.1 `ModuleNameAdd module-info.java`加入`exports`

####  6.2 `ModuleNameMain module-info.java`加入`requires`

####  6.3 编译ModuleNameAdd模块 

```
    E:\codeRoom\java\javabase\proj5>javac -d targets/ModuleNameAdd ModuleNameAdd/module-info.java ModuleNameAdd/com/qny/*.java
    
```

####  6.4 编译moduleNameMain模块

```
    E:\codeRoom\java\javabase\proj5>javac --module-path targets -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/sum/*.java
```

注意增加`--module-path` 必须指定，虽然在`ModuleNameMain`中的`module-info.java requires ModuleNameAdd`;但是_javac_依然不知道module在哪里
所以必须指定！

####  6.5 运行多模块的主程序

<2020-10-27 17:32> 有效！多模块编程的时候只需要运行主程序jar即可。

```
E:\codeRoom\java\javabase\proj5>java --module-path targets -m ModuleNameMain/com.sum.App
Hello world! 8
```

####  6.6 制作jmod文件(可以直接运行module)

##### 6.6.1 制作jar

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


#####  6.6.2 制作jmod

切换到6.6.1 jar生成的路径中!

**注意jar文件一般放在lib文件夹下，不要放在jmod同一文件夹下**

```
E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameAdd.jar ModuleNameAdd.jmod

E:\codeRoom\java\javabase\proj5\targets\jars>jmod create  --class-path ModuleNameMain.jar ModuleNameMain.jmod
```


#####  6.6.3 制作可运行的JRE


- 创建JRE文件夹

下面`--add-modules`是jmod文件！(只不过省略掉jmod后缀， --module-path类似--classes)

`jlink --module-path jmodfile(上个命令生成的jmod文件存放的文件夹) --add-modules ModuleNameButton,ModuleNameMain,java.base --output myapp`

`java.base`为默认增加的模块名字。

```
E:\codeRoom\java\javabase\proj4>jlink --module-path . --add-modules ModuleNameMain,java.base --output myAppOne
```

- 生成一个JRE文件夹，文件夹内的java.exe包含新模块信息

```
E:\codeRoom\java\javabase\proj4\myAppOne\bin>java -m ModuleNameMain
Hello world! 8
```

## 附录

javac编译，java运行(编译运行)
javac编译，生产module(包含module-info.jar)或者非module的jar包(可能包含)，进一步导出jmod，jlink所有jmod行成一个jre，java运行(编译运行)


- javac.exe(根据java后缀文件生成class文件 或者模块的class路径,即module文件夹)
  - `--module-path`  编译后模块所在文件夹
  - `-d` 指定模块编译后存放位置
  - `javac  -d targets/ModuleNameAdd ModuleNameAdd/module-info.java ModuleNameAdd/com/qny/*.java`
  - `javac --module-path target -d targets/ModuleNameMain ModuleNameMain/module-info.java ModuleNameMain/com/qny/*.java`
- jar.exe (根据class文件或者module的class文件打包成jar包  可以指定启动函数, 中间产物或者最终文件)
  - `--create` 创建jar包
  - `--file` 指定jar包输出文件名
  - `--main-class` 指定主类，启动类,也可以通过manifest.tf文件指定
  - `-C` 指定编译后class路径(或者module的class路径,即module文件夹) jar只是class的压缩文件
  - `tf` 显示jar信息  `jar tf ModuleNameAdd.jar`
  - `jar --create --file targets/jars/ModuleNameAdd.jar -C targets/ModuleNameAdd .`
  - `jar --create --file targets/jars/ModuleNameMain.jar -C targets/ModuleNameAMain .`
  - `jar cvfm hello.jar manifest.mf com/sum/App.class` 另外一种打包方式
- jmod.exe  (根据jar包生成jmod包)
  - `create` 没有双破折号
  - `--class-path` 根据jar包具体路径，用于生成jmod文件
  - `jmod create --class-path targets/jars/ModuleNameAdd.jar ModuleNameAdd.jmod `
  - `jmod create --class-path targets/jars/ModuleNameMain.jar ModuleNameMain.jmod `
- jlink.exe (根据jmod生成jre文件夹)
  - `--module-path .` 指定可以找到jmod文件的文件夹(路径)
  - `--add-modules` 指定Jmod的模块名字(java.base)
  - `--output` 输出文件名
  - `jlink --module-path . --add-moduels ModuleNameMain,java.base --output MyAppJRE`
- java.exe (运行jar或module文件)
  - `-jar` 指定需要运行jar包
  - `--module-path`  模块所在文件夹
  - `-p` 指定jar包所在文件夹相对路径,jar包只是压缩文件，所以可能是module也可能不是
  - `-m`  指定需要运行模块
  - `java --module-path targets -m ModuleNameMain/com.sum.App`  运行多模块的一种方式

[1]: https://github.com/jueqingsizhe66/whyJavaModule/blob/develop/image/ThinkFromModuleUp.jpg
