#include <stdio.h>      /* for printf() and fprintf() */
#include <sys/socket.h> /* for recv() and send() */
#include <unistd.h>     /* for close() */
#include <sys/mman.h>
#include <string.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>
#include <semaphore.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include <string.h>
#include <arpa/inet.h>

#define RCVBUFSIZE 32

void DieWithError(char *errorMessage);  /* Error handling function */

void HandleUDPClient(int clntSocket, int* boltuns, int* ports, struct sockaddr_in echoServAddr)
{
	for (;;) {
	socklen_t clientAddressLen = sizeof(echoServAddr);

	char echoBuffer[RCVBUFSIZE];
	int recvMsgSize;
	/* Receive message from client */
	recvMsgSize = recvfrom(clntSocket, echoBuffer, RCVBUFSIZE - 2, 0, (struct sockaddr *)&echoServAddr, &clientAddressLen);
	echoBuffer[RCVBUFSIZE - 1] = '\0';
	char* input1 = echoBuffer;
	int int1 = 0, int2 = 0;
	sscanf(input1, "%d %d", &int1, &int2);
	printf("int1: %d, int2: %d\n", int1, int2);
		if (int1 > boltuns[0] || int2 > boltuns[0]) {
		  int1 = int2 = 0;
		}

		if (int1 * int2 != 0 && boltuns[int1] + boltuns[int2] == 0) {
		    boltuns[int1] = int2;
		    boltuns[int2] = int1;
		    char sendString[100];
		    sprintf(sendString, "%d is takking with %d\n", int1, int2);
			sendto(clntSocket, sendString, strlen(sendString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			for (int i = 1; i < boltuns[0] + 1; ++i) {
		      printf("%d ", boltuns[i]);
		    }
			printf("\n");
		    sleep(rand() % 4 + 20);
		    boltuns[int1] = 0;
		    boltuns[int2] = 0;
			for (int i = 1; i < boltuns[0] + 1; ++i) {
		      printf("%d ", boltuns[i]);
		    }
			printf("\n");
		} else if (boltuns[int1] + boltuns[int2] != 0) {
			for (int i = 1; i < boltuns[0] + 1; ++i) {
		      printf("%d ", boltuns[i]);
		    }
			printf("\n");
			char sendString[100];
			if (boltuns[int2] != 0) {
				sprintf(sendString, "%d is busy\n", int2);
			} else {
				sprintf(sendString, "%d is busy\n", int1);
			}
			sendto(clntSocket, sendString, strlen(sendString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			sleep(2);
	  	}
		sleep(2);
	}
}