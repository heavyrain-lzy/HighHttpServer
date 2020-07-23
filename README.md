

HighHttpServer
===============
主要参考了《UNIX网络编程卷1:套接字联网API》《UNIX网络编程卷2:进程间通信》以及更多的参考了游双的
《Linux高性能服务器编程》，跟陈硕编写的《Linux多线程服务端编程：使用muduoC++网络库》的设计
思路有部分相同。还正在慢慢学习。
Linux下的简易web服务器，实现web端用户注册，登录功能，查看资源。
注：近期要忙着做实验写论文，但是也忙着秋招，相信大家都能有好的归宿。

> * [RAII包装互斥锁条件变量信号量](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/lock_sem)
> * [http连接请求处理类](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/http)
> * [线程池](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/threadpool)
> * [定时器处理非活跃连接](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/timer)
> * [同步/异步日志系统](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/log)  
> * [数据库连接池](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/mysqlpool) 
> * [Webbench压力测试](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/test_presure)

项目目的
===============
看了很多相关的书籍但是没有真正的
代码入手是不行，所以从书上和网上的资源入手，“攒出”一个项目练手，
能更加理解书上的内容

更新日志
----------
- [x] 解决了传输大文件问题--2020.05.28
- [x] 


困难点
----------
1、请求较大的视频会出现网页失败情况，并在Firefox不能请求，
只能在Chrome下请求，观察日志是由于网页会突然重新发送新数据
具体情况，需要持续更新。
2、epoll的使用机制基本算弄清楚了。

功能说明
----------
> * 注册
> * 登录
> * 请求视频文件演示

测试结果
-------------
Webbench对服务器进行压力测试，由于自己的使用的是虚拟机
只分配了1G的内存和20G的固态，导致Webbench最多fork4500的
子进程。
> * 并发连接总数：4500
> * 访问服务器时间：5s
> * 每秒钟响应请求数：404700 pages/min
> * 每秒钟传输数据量：754969 bytes/sec
> * 所有访问均成功

<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/explain_webbench.jpg" height="201"/> </div>

<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/pressureTest.jpg" height="201"/> </div>
<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/tooManyFork.jpg" height="201"/> </div>
如果图片加载失败，请点击缩略图直接查看图片！！！

框架
-------------
<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/frame.jpg" height="765"/> </div>
如果图片加载失败，请点击缩略图直接查看图片！！！

web端界面
-------------

> * home界面
> * 注册
> * 注册失败提示
> * 登录
> * 登录失败提示

如果图片加载失败，请点击缩略图直接查看图片！！！
![](https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/home.jpg)
<div align=center>
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/regist.jpg" height="200"/>
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/registError.jpg" height="200"/></div>

<div align=center>        
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/log.jpg" height="200"/>        
	 <img src="https://github.com/heavyrain-lzy/HighHttpServer/tree/master/interface/logError.jpg" height="200"/></div>

日志关闭
------------
可以通过log.h中的宏定义LOG_OPEN来关闭和开启日志	 
	 
web端测试
------------
* 服务器测试环境
	* Ubuntu版本19.10
	* MySQL版本8.0.20

* 测试前确认已安装MySQL数据库

    ```C++
    //建立yourdb库
    create database yourdb set utf8;

    //创建user表
    USE yourdb;
    CREATE TABLE user(
        username char(50) NULL,
        passwd char(50) NULL
    )ENGINE=InnoDB;

    //添加数据
    INSERT INTO user(username, passwd) VALUES('name', 'passwd');
    ```

* 修改main.c中的数据库初始化信息

    ```C++
    //root password为服务器数据库的登录名和密码
    connection_pool *connPool=connection_pool::GetInstance("localhost","root","password","yourdb",3306,5);
    ```

* 修改http_conn.cpp中的source路径

    ```C++
    const char* doc_root="/home/evan/HeighHttpServer/source";
    ```
* 选择任一校验方式，代码中使用同步校验。当使用CGI时才进行如下修改，否则可跳过本步骤，直接生成server

- [ ] CGI多进程注册/登录校验
	* 打开http_conn.cpp中CGI,关闭同步线程
	    ```C++
	    6 //同步线程登录校验
	    7 //#define SYN

	    9  //CGI多进程登录校验
	    10 #define CGI
	    ```

	    * 打开日志
	    ```C++
	    在log.h中
	    #define SYN
	    ```
	    * 关闭日志
	    ```C++
	    在log.h中
	     //#define SYN
	
	* 修改sign.cpp中的数据库初始化信息

	    ```C++
	    //root password为服务器数据库的登录名和密码
	    connection_pool *connPool=connection_pool::GetInstance("localhost","root","password","yourdb",3306,5);
	    ```
	* 生成check.cgi

	    ```C++
	    make check.cgi
	    ```
	* 将生成的check.cgi放到source文件夹

	    ```C++
	    cp ./check.cgi ./source
	    ```


* 生成server

    ```C++
    make
    ```

* 启动server

    ```C++
    ./server port
    ```

* 浏览器端

    ```C++
    ip:port
    ```
