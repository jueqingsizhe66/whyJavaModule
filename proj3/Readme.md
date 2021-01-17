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

E:\codeRoom\java\javabase\proj3>jar cvfm hello2.jar manifest.mf com/sum/*.class
已添加清单
正在添加: com/sum/App.class(输入 = 610) (输出 = 407)(压缩了 33%)
正在添加: com/sum/App2.class(输入 = 472) (输出 = 313)(压缩了 33%)
正在添加: com/sum/Mytool.class(输入 = 252) (输出 = 197)(压缩了 21%)
```

增加所有的的class文件进入jar包，从另一方面证明jar cvfm命令就是用于压缩一定目录结构的class文件，打包的作用，同时这个jar可以
考虑manifest.mf的语法结构

4.3 运行jar包
```
E:\codeRoom\java\javabase\proj3>java -jar hello.jar
Hello world! 8
```
