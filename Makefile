all: server client devnull

prof: serverProfiling client

server: server.o ../ssocket/ssocket.o
	gcc -o3 server.o ../ssocket/ssocket.o -o serverTesis -lpthread

serverProfiling: server.o ../ssocket/ssocket.o
	gcc -g -o3 server.o ../ssocket/ssocket.o -o serverTesis -lpthread

rm_server:
	rm serverTesis server.o

client: client.o ../ssocket/ssocket.o
	gcc -o3 client.o ../ssocket/ssocket.o -o clientTesis -lpthread

rm_client:
	rm clientTesis client.o

devnull: dev_null.o
	gcc -g -o3 dev_null.o -o dev_null -lpthread

rm_devnull:
	rm dev_null dev_null.o

clean: rm_client rm_server rm_devnull