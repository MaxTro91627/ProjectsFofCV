#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for socket(), connect(), send(), and recv() */
#include <arpa/inet.h>  /* for sockaddr_in and inet_addr() */
#include <stdlib.h>     /* for atoi() and exit() */
#include <string.h>     /* for memset() */
#include <unistd.h>     /* for close() */
#include <sys/mman.h>
#include <time.h>


#define RCVBUFSIZE 40 

int N;

void DieWithError(char *errorMessage);  /* Error handling function */

int main(int argc, char *argv[])
{
	srand(time(NULL));
	int sock;                        /* Socket descriptor */
    struct sockaddr_in echoServAddr; /* Echo server address */
    unsigned short echoServPort;     /* Echo server port */
    char *servIP;                    /* Server IP address (dotted quad) */
    char echoString[40];                /* String to send to echo server */
  	char *b = echoString;

    char echoBuffer[RCVBUFSIZE];     /* Buffer for echo string */
    unsigned int echoStringLen;      /* Length of string to echo */
  	int readBytes = 30;
	struct sockaddr_in echoClntAddr;
    int bytesRcvd, totalBytesRcvd;   /* Bytes read in single recv() and total bytes read */
	

    if ((argc < 3) || (argc > 4))    /* Test for correct number of arguments */
    {
       	fprintf(stderr, "Usage: %s <Server IP> <Echo Word> [<Echo Port>]\n",
    	argv[0]);
       	exit(1);
    }

    servIP = argv[1];             /* First arg: server IP address (dotted quad) */
    // echoString = argv[2];         /* Second arg: string to echo */
    N = atoi(argv[2]);
  	printf("%d\n", N);

    if (argc == 4)
        echoServPort = atoi(argv[3]); /* Use given port, if any */
    else
        echoServPort = 7;  /* 7 is the well-known port for the echo service */
    

    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
        DieWithError("socket() failed");

    /* Construct the server address structure */
    memset(&echoServAddr, 0, sizeof(echoServAddr));     /* Zero out structure */
    echoServAddr.sin_family      = AF_INET;             /* Internet address family */
    echoServAddr.sin_addr.s_addr = inet_addr(servIP);   /* Server IP address */
    echoServAddr.sin_port        = htons(echoServPort); /* Server port */
    /* Establish the connection to the echo server */
    if (connect(sock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
        DieWithError("connect() failed");
      // scanf("%s", echoString);
      
    for (;;) {
		char echoString[100];                /* String to send to echo server */
  		// char *b = echoString;
		char echoBuffer[RCVBUFSIZE];     /* Buffer for echo string */
		if (rand() % 2) {
		    int int1 = rand() % N + 1;
		    int int2 = rand() % N + 1;
		    if (int1 == int2) {
		    	int2++;
		        if (int2 > N) {
		          	int2 = int2 % N;
		        }
		    }
		    sprintf(echoString, "%d %d", int1, int2);
		    echoStringLen = strlen(echoString);          /* Determine input length */
		      
			// printf("%d is calling to %d\n", int1, int2);
		    /* Send the string to the server */
		    if (send(sock, echoString, echoStringLen, 0) != echoStringLen)
		        DieWithError("send() sent a different number of bytes than expected");
			sendto(sock, echoString, echoStringLen, 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			
			printf("%d is calling to %d\n", int1, int2);
			if ((bytesRcvd = recv(sock, echoBuffer, RCVBUFSIZE - 1, 0)) <= 0)
				DieWithError("recv() failed or connection closed prematurely");
			char mes[100];
			char sm[100];
			int readInt;
			printf("%s\n", echoBuffer);
			sscanf(echoBuffer, "%d %s %s", &readInt, sm, mes);
			if (mes[0] != 'b') {
				if ((bytesRcvd = recv(sock, echoBuffer, RCVBUFSIZE - 1, 0)) <= 0)
					DieWithError("recv() failed or connection closed prematurely");
				printf("%s\n", echoBuffer);
			}
		    sleep(1);
		} else {
			sleep(7);
		} 
	}
}
