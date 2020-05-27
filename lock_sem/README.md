
RAII线程同步机制包装类
===============
多线程同步，确保任一时刻只能有一个线程能进临界区,RAII包装机制有很多优点
：易于编程，不会忘记解锁等，但是也存在锁区域过大，不能灵活加锁的弊端
> * 信号量
> * 互斥锁
> * 条件变量

<div align=center><img src="https://github.com/twomonkeyclub/TinyWebServer/blob/master/root/test1.jpg" height="350"/> </div>




