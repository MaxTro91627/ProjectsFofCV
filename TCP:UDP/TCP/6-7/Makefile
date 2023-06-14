all: Client Server listener
Client: Client.c DieWithError.c
	gcc Client.c DieWithError.c -o Client
Server: TCPEchoServer.h Server.c DieWithError.c
	gcc Server.c DieWithError.c HandleTCPClient.c \
	CreateTCPServerSocket.c AcceptTCPConnection.c \
	-o Server -lrt
listener: listener.c DieWithError.c
	gcc listener.c DieWithError.c -o listener
