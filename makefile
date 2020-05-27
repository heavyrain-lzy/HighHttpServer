server: main.c ./threadpool/threadpool.h ./http/http_conn.cpp ./http/http_conn.h ./lock_sem/locker.h ./log/log.cpp ./log/log.h ./log/block_queue.h ./mysqlpool/sql_connection_pool.cpp ./mysqlpool/sql_connection_pool.h
	g++ -o server main.c ./threadpool/threadpool.h ./http/http_conn.cpp ./http/http_conn.h ./lock_sem/locker.h ./log/log.cpp ./log/log.h ./mysqlpool/sql_connection_pool.cpp ./mysqlpool/sql_connection_pool.h -lpthread -lmysqlclient

check.cgi:./mysqlpool/sign.cpp ./mysqlpool/sql_connection_pool.cpp ./mysqlpool/sql_connection_pool.h
	g++ -o check.cgi ./mysqlpool/sign.cpp ./mysqlpool/sql_connection_pool.cpp ./mysqlpool/sql_connection_pool.h -lmysqlclient

clean:
	rm  -r server
	rm  -r check.cgi
