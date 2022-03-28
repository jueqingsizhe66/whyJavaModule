## 了解java模块定义和相互应用

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [了解java模块定义和相互应用](#了解java模块定义和相互应用)
    - [简介](#简介)
- [Proj1](#proj1)
- [Proj3](#proj3)
    - [4. 打包jar](#4-打包jar)
        - [4.1 编写manifest.mf](#41-编写manifestmf)
        - [4.2  创建可执行jar包](#42--创建可执行jar包)
        - [4.3 运行jar包](#43-运行jar包)
- [Proj4](#proj4)
    - [5. 引入了模块的概念](#5-引入了模块的概念)
        - [5.1 编译](#51-编译)
        - [5.2 运行](#52-运行)
        - [5.3 模块打包](#53-模块打包)
        - [5.4 运行打包后的模块](#54-运行打包后的模块)
        - [5.5 创建一个可打包的JRE](#55-创建一个可打包的jre)
            - [5.5.1 创建jmod文件](#551-创建jmod文件)
            - [5.5.2 创建JRE文件夹](#552-创建jre文件夹)
- [proj5](#proj5)
    - [6. 多模块相互引用](#6-多模块相互引用)
        - [6.1 `ModuleNameAdd module-info.java`加入`exports`](#61-modulenameadd-module-infojava加入exports)
        - [6.2 `ModuleNameMain module-info.java`加入`requires`](#62-modulenamemain-module-infojava加入requires)
        - [6.3 编译ModuleNameAdd模块](#63-编译modulenameadd模块)
        - [6.4 编译moduleNameMain模块](#64-编译modulenamemain模块)
        - [6.5 运行多模块的主程序](#65-运行多模块的主程序)
        - [6.6 制作jmod文件(可以直接运行module)](#66-制作jmod文件可以直接运行module)
            - [6.6.1 制作jar](#661-制作jar)
            - [6.6.2 制作jmod](#662-制作jmod)
            - [6.6.3 制作可运行的JRE](#663-制作可运行的jre)
- [附录](#附录)

<!-- markdown-toc end -->

<center>
 ![one programe game][5] 
</center>
### 简介

通过java去认识模块化编程的意义； 
1. 我们有一堆java文件，扁平化管理，直接`javac *.java` ,然后对主文件进行`java`即可完成运行
*存在的问题，不好进行拓展，也不好管理*

 <center>
 ![gamefirst][6]
 </center>

2. 为了解决管理的问题，我们在项目名下面，引入了包机制,我们把所有的`*.java`文件都放在`com.sun`底下
然后我们再次`javac com/sun/*.java`, 然后运行`java com.sun.Main`, 前提我们的java文件头部得包含
`Package com.sun` ; 
*我们解决了什么问题？ 没有！*
我们只是引入了一个包机制。但是不代表没用，也就是说我们可以把com/sun解析成com.sun类， 在这一步做了一次具备重要意义的概念引入
`全路径类名`, 也就是我们的Main类，Button类,People类不在没有类路径了，他们都在com.sun底下。

**全路径类**
他是什么？ 为什么要引入全路径类？ 什么时候会出现全路径类的概念，它的使用场景是什么？  <2021-10-11 23:27> 

    在编译后，让一个java文件的文件路径识别为一个java的可查找全路径类名,全路径类以点号划分，每一个点号代表未编译时候的一层文件夹名字。
    <2021-06-27 21:49>再次学习该全路径类的概念！温固java编译和运行发生的事情，编译涉及的是包路径，运行涉及的是全路径类

这里要区分全路径类和包路径的区别，一般包路径指代编译前的文件夹路径(javac运行)，全路径类表示类的点路径(java或者javaw运行)

3. 有了全路径类的概念，我们进一步形成可执行jar包
我们添加了manifest.mf文件，然后编写我们的主类。 然后运行我们的jar包

4. 包机制并没有给项目的模块化带来根本性改变，为此我们引入了module.java, 我们在项目名(project)和包名(com/sun) --全称project/com/sun引入模块名字，比如ModuleNameMain，并在ModuleNameMain引入module.java文件，指定requires 和exports

- exports管编译，通常是工具类和可运行类的文件夹
    表示允许在编译时和运行时访问指定包的public成员
- opens管运行!(如果运行需要也得opens,通常指可运行类 App或者Main类所在文件夹)
    用于声明该模块的指定包在runtime允许使用反射访问
    主要用于解决deep reflection问题，open的作用是表示该模块下的所有的包在runtime都允许deep reflection(包括public及private类型)

[详见opens和exports区别介绍][3]

于是我们通过java的-d选项指定模块输出路径和模块名字(比如modules/ModuleNameMain, 输出路径文当前文件夹下的modules文件夹，ModuleNameMain为模块名字)，并带上module.java文件，以及ModuleNameMain/com/sun/*.java 该模块所在包路径下的所有java文件

然后我们就可以通过java --module-path 指定modules文件夹（表示在modules文件夹下寻找模块信息）,指定-m ModuleNameMain/com.sun.Main
来运行对应模块的全路径类！！！ *注意* _全路径类_
<2021-10-11 23:24>  在项目文件夹和包文件夹中间加入一个层级，模块文件夹， 这样顺序是  项目名字目录--> 模块名字目录--> 包名字目录
每个模块名字目录下都有一个module-info.java文件
模块文件夹内的所有包路径在exports 模块后，均可被引入(import)!

[模块的引入][4]

5. 进一步我们又加入了新的module，于是我们编写了module.java文件，增加了exports（不需要opens，因为不需要运行它,所以opens用的几率较少？）,增加了requires文件；紧接着，我们建立了包路径，`com.button`,再把相关类放在其中，然后接着跑一遍`javac`, `javac -d modules/ModuleNameButton ModuleNameButton/module.java ModuleNameMain/com/button/*.java`
然后因为我们的ModuleNameMain需要用到ModuleNameMain, 于是我们需要在ModuleNameMain中的module.java增加`requires ModuleNameButton`

那么，我们在编译ModuleNameMain模块的时候，就需要`javac --module-path modules -d modules/ModuleNameMain ModuleNameMain/module.java ModuleNameMain/com/sun/*.java` 完成ModuleNameMain的编译

那么，如何运行？
`java --module-path modules ModuleNameMain/com.sun/Main`

6. 那如何再次基础上进一步封装你的模块到JRC中？ 拷给别人后直接运行模块即可！
注意这一步我们只管把jar包做变换，jar变jmod，jmod变成jre项目即可
那就得调用jmod和jlink，在这之前还得先创建jar包(用jar工具,注意这次不是使用jar cvfm 创建jar包)

`jar --create --file ModuleNameButton.jar -C modules/ModuleNameButton . `
`jar --create --file ModuleNameMain.jar -C modules/ModuleNameMain . `

然后使用jmod
`
jmod create --class-path ModuleNameButton.jar ModuleNameButton.jmod
jmod create --class-path ModuleNameMain.jar ModuleNameMain.jmod
`

`
jlink --module-path jmodfile(把jmod文件都放在jmodfile目录下)  --add-modules ModuleNameButton,ModuleNameMain,java.base --output  myapp
`

ya!到此为此，你就玩high了,也明白了java的编译阶段的包路径、运行阶段全路径类、多模块编程、命令行编译，JRE包的生成！
<2021-06-22 22:43>

----------------------------------------------------------

从manifest.mf看到了包的一层,可以指定启动函数，从module.info看到了模块的一层(可见与不可见)，
没有任何问题是加入一层无法解决的，如果还无法解决，接着加！

从命令行的角度出发，加入一层，会使得你的options增加了几个，比如-d指定模块路径，跟随module-info.java文件等相关选项
命令行就是流的思路(类似于Servlet控制层，夹带service函数，引入model层，service之后带入model的Dao层,实现CM控制
流畅才能解决问题,慢慢来,会很快，在这之前，得多想; 这可以指代javac、jar、jmod、jlink、java、目标、愿景、领头人)

参考[JAVAFX JRE模块环境搭建][2]

1. Proj1   只是一个main函数
2. Proj2   加入了Mytool类 引用add函数
3. Proj3   引入了包的概念
4. Proj4   引入了模块的概念, 打包模块，打包JRE
5. Proj5   Proj1~4都是单模块的概念，在此步骤引入引入多模块相互引用

## Proj1 

1. 编译

*包路径*，*包机制*
```
E:\codeRoom\java\javabase\proj3>javac com/sum/*.java`
```

2. 运行

*全路径类*
```
E:\codeRoom\java\javabase\proj3>java com.sum.App
Hello world! 8

```

## Proj2

3. 加入了包的概念

### 4. 打包jar
 
####  4.1 编写manifest.mf

主类、运行类指定
注意看jdk版本，是14.0.2？

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

`com.sum`包也需要输出，这样可以直接访问App类， 包名字只有exports才能被外界访问(exports还得和opens区分开)
<2020-10-28 00:36> 洗澡的时候想到，这是项目中黑色区域，经常会忘记，细节决定成败!
```
module ModuleNameMain
{
    exports com.sum;
    requires ModuleNameAdd;
}
```

- `-d`表示产生的targets文件夹 包含ModuleNameMain
注意exports模块，才能让其他模块可见或者使用`-m`运行该模块(没加exports，相当于不可见！会出问题)
注意: `com.sum`是模块名称？  `javafx.base`和 `javafx.controls`是模块名称
文件夹`a.b`是可以创建的

模块名底下有包和module-info.java, 包最底层是类文件！


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
  - `java --module-path targets -m ModuleNameMain/com.sum.App`  运行多模块的一种方式, 运行的时候都得用`包名+类名`的形式写法，即`ModuleNameMain`是模块包名字、`com.sum.App`是类名字
  
`(java -m 
    (jlink --module-path --add-modules --output 
        (jmod  create --class-path 
            (jar  --create --file  -C 
                (javac --module-path ? -d ?  *.java)))))`

[1]: https://github.com/jueqingsizhe66/whyJavaModule/blob/develop/image/ThinkFromModuleUp.jpg
[2]: https://www.bilibili.com/video/BV1fA41147kZ?p=3&spm_id_from=pageDriver
[3]: https://segmentfault.com/a/1190000013409571
[4]:https://www.bilibili.com/video/BV1fA41147kZ?p=5 
[5]:https://github.com/jueqingsizhe66/whyJavaModule/blob/develop/onegame.png 
[6]:https://github.com/jueqingsizhe66/whyJavaModule/blob/develop/gameFirst.png 
