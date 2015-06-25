all: server serverReuse client devnull

server: server.o ../ssocket/ssocket.o
	gcc server.o ../ssocket/ssocket.o -o server -lpthread

serverReuse: serverReuse.o ../ssocket/ssocket.o
	gcc serverReuse.o ../ssocket/ssocket.o -o serverReuse -lpthread

rm_server:
	rm server server.o

devnull: dev_null.o
	gcc -g dev_null.o -o dev_null -lpthread

rm_devnull:
	rm dev_null dev_null.o

client: client.o ../ssocket/ssocket.o
	gcc client.o ../ssocket/ssocket.o -o client -lpthread

rm_client:
	rm client client.o

clean: rm_client rm_server rm_devnull
