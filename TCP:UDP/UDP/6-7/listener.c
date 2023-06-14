#include <stdio.h>
#include <sys/socket.h>
#include <arpa/inet.h> 
#include <stdlib.h>
#include <string.h> 
#include <unistd.h>
#include <semaphore.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <signal.h>
#include <time.h>
#include <sys/fcntl.h>

#define RCVBUFSIZE 50

void DieWithError(char *errorMessage);  /* Error handling function */

int main(int argc, char *argv[]) {
    
    int sock;                        /* Socket descriptor */
    struct sockaddr_in echoServAddr; /* Echo server address */
    unsigned short echoServPort;     /* Echo server port */
    char *servIP;                    /* Server IP address (dotted quad) */
    char echoString[50];              /* String to send to echo server */
    char echoBuffer[RCVBUFSIZE];     /* Buffer for echo string */
    unsigned int echoStringLen;      /* Length of string to echo */
    int bytesRcvd, totalBytesRcvd;   /* Bytes read in single recv()
                                        and total bytes read */
    int place = 0;

    if (argc != 3) {
       fprintf(stderr, "Usage: %s <Server IP> <Echo Port>\n",
               argv[0]);
       exit(1);
    }

    servIP = argv[1];
    echoServPort = atoi(argv[2]);

    if ((sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0)
        DieWithError("socket() failed");

    memset(&echoServAddr, 0, sizeof(echoServAddr));
    echoServAddr.sin_family      = AF_INET;
    echoServAddr.sin_addr.s_addr = inet_addr(servIP);
    echoServAddr.sin_port        = htons(echoServPort);

    sprintf(echoString, "listener");
    echoStringLen = strlen(echoString);

	sendto(sock, echoString, echoStringLen, 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
    sleep(1);
 	unsigned int cliAddrLen;
    cliAddrLen = sizeof(echoServAddr);
    if ((bytesRcvd = recvfrom(sock, echoBuffer, RCVBUFSIZE - 1, 0,
		            (struct sockaddr *) &echoServAddr, &cliAddrLen)) < 0)
        DieWithError("recv() failed or connection closed prematurely");
    echoBuffer[bytesRcvd] = '\0';

    printf("%s\n", echoBuffer);

    while (echoBuffer[0] != '?') {
        if ((bytesRcvd = recvfrom(sock, echoBuffer, RCVBUFSIZE - 1, 0,
		            (struct sockaddr *) &echoServAddr, &cliAddrLen)) < 0)
            DieWithError("recv() failed or connection closed prematurely");
        echoBuffer[bytesRcvd] = '\0';
        printf("%s\n", echoBuffer);
    }

    close(sock);
    exit(0);
}