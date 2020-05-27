

HighHttpServer
===============
主要参考了《UNIX网络编程卷1:套接字联网API》《UNIX网络编程卷2:进程间通信》以及更多的参考了游双的
《Linux高性能服务器编程》，跟陈硕编写的《Linux多线程服务端编程：使用muduoC++网络库》的设计
思路有部分相同。还正在慢慢学习，争取理解
Linux下的简易web服务器，实现web端用户注册，登录功能,经压力测试可以实现上万的并发连接数据交换.
> * C/C++
> * B/S模型
> * [线程同步机制包装类](https://github.com/qinguoyi/TinyWebServer/tree/master/lock)
> * [http连接请求处理类](https://github.com/qinguoyi/TinyWebServer/tree/master/http)
> * [半同步/半反应堆线程池](https://github.com/qinguoyi/TinyWebServer/tree/master/threadpool)
> * [定时器处理非活动连接](https://github.com/qinguoyi/TinyWebServer/tree/master/timer)
> * [同步/异步日志系统 ](https://github.com/qinguoyi/TinyWebServer/tree/master/log)  
> * [数据库连接池](https://github.com/qinguoyi/TinyWebServer/tree/master/CGImysql) 
> * [CGI及同步线程注册和登录校验](https://github.com/qinguoyi/TinyWebServer/tree/master/CGImysql) 
> * [简易服务器压力测试](https://github.com/qinguoyi/TinyWebServer/tree/master/test_presure)

Update
----------
- [x] 
- [x] 


Demo
----------
> * 注册演示

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/registernew.gif" height="429"/> </div>

> * 登录演示

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/loginnew.gif" height="429"/> </div>

> * 请求图片文件演示(6M)

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/picture.gif" height="429"/> </div>

> * 请求视频文件演示(39M)

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/video.gif" height="429"/> </div>


测试结果
-------------
Webbench对服务器进行压力测试，可以实现上万的并发连接.
> * 并发连接总数：10500
> * 访问服务器时间：5s
> * 每秒钟响应请求数：552852 pages/min
> * 每秒钟传输数据量：1031990 bytes/sec
> * 所有访问均成功

**注意：** 使用本项目的webbench进行压测时，若报错显示webbench命令找不到，将可执行文件webbench删除后，重新编译即可。

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/testresult.png" height="201"/> </div>



框架
-------------
<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/root/frame.jpg" height="765"/> </div>


web端界面
-------------

> * 判断是否注册   
> * 注册
> * 注册失败提示
> * 登录
> * 登录失败提示


<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/interface/judge.jpg" height="200"/>         <img src="https://github.com/qinguoyi/TinyWebServer/blob/master/interface/signup.jpg" height="200"/>         <img src="https://github.com/qinguoyi/TinyWebServer/blob/master/interface/signupfail.jpg" height="200"/></div>

<div align=center><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/interface/signin.jpg" height="200"/><img src="https://github.com/qinguoyi/TinyWebServer/blob/master/interface/signinfail.jpg" height="200"/></div>

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
    connection_pool *connPool=connection_pool::GetInstance("localhost","root","root","yourdb",3306,5);
    ```

* 修改http_conn.cpp中的root路径

    ```C++
    const char* doc_root="/home/qgy/TinyWebServer/root";
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
	    connection_pool *connPool=connection_pool::GetInstance("localhost","root","root","yourdb",3306,5);
	    ```
	* 生成check.cgi

	    ```C++
	    make check.cgi
	    ```
	* 将生成的check.cgi放到root文件夹

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
