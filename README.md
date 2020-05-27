

HighHttpServer
===============
主要参考了《UNIX网络编程卷1:套接字联网API》《UNIX网络编程卷2:进程间通信》以及更多的参考了游双的
《Linux高性能服务器编程》，跟陈硕编写的《Linux多线程服务端编程：使用muduoC++网络库》的设计
思路有部分相同。还正在慢慢学习，争取理解
Linux下的简易web服务器，实现web端用户注册，登录功能，查看资源
> * C/C++
> * [RAII包装互斥锁条件变量信号量](https://github.com/heavyrain-lzy/HighHttpServer/lock_sem)
> * [http连接请求处理类](https://github.com/heavyrain-lzy/HighHttpServer/http)
> * [线程池](https://github.com/heavyrain-lzy/HighHttpServer/threadpool)
> * [定时器处理非活跃连接](https://github.com/heavyrain-lzy/HighHttpServer/timer)
> * [同步/异步日志系统](https://github.com/heavyrain-lzy/HighHttpServer/log)  
> * [数据库连接池](https://github.com/heavyrain-lzy/HighHttpServer/mysqlpool) 
> * [Webbench压力测试](https://github.com/heavyrain-lzy/HighHttpServer/test_presure)

更新日志
----------
- [x] 
- [x] 


功能说明
----------
> * 注册
> * 登录
> * 请求视频文件演示

测试结果
-------------
Webbench对服务器进行压力测试，可以实现上万的并发连接.
> * 并发连接总数：10500
> * 访问服务器时间：5s
> * 每秒钟响应请求数：552852 pages/min
> * 每秒钟传输数据量：1031990 bytes/sec
> * 所有访问均成功

<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/source/testresult.png" height="201"/> </div>


框架
-------------
<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/source/frame.jpg" height="765"/> </div>


web端界面
-------------

> * home界面
> * 注册
> * 注册失败提示
> * 登录
> * 登录失败提示


<div align=center><img src="https://github.com/heavyrain-lzy/HighHttpServer/source/home.jpg" height="200"/> 
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/source/regist.jpg" height="200"/>
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/source/registError.jpg" height="200"/></div>

<div align=center>        
	<img src="https://github.com/heavyrain-lzy/HighHttpServer/source/log.jpg" height="200"/>        
	 <img src="https://github.com/heavyrain-lzy/HighHttpServer/source/logError.jpg" height="200"/></div>

web端测试
------------
* 服务器测试环境
	* Ubuntu版本16.04
	* MySQL版本8.0

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
    //root root为服务器数据库的登录名和密码
    connection_pool *connPool=connection_pool::GetInstance("localhost","root","password","yourdb",3306,5);
    ```

* 修改http_conn.cpp中的root路径

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
	
	* 修改sign.cpp中的数据库初始化信息

	    ```C++
	    //root root为服务器数据库的登录名和密码
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

- [x] 同步线程注册/登录校验
	* 关闭http_conn.cpp中CGI,打开同步线程
	    
	    ```C++
	    6 //同步线程登录校验
	    7 #define SYN

	    9  //CGI多进程登录校验
	    10 //#define CGI
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
