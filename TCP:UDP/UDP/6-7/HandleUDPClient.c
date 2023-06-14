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

void handleListener(int clntSocket, int* messages, struct sockaddr_in echoServAddr) {
	char echoString[50]; 
    unsigned int echoStringLen;

	int idx = messages[0];

	for (;;) {
        while (messages[0] == idx) {
            sleep(1);
        }
		printf("messages info: %d %d\n", idx, messages[0]);
		while (idx < messages[0]) {
			if (messages[idx + 1] == 1) {
				sprintf(echoString, "%d is calling to %d\n", messages[idx + 2], messages[idx + 3]);
				echoStringLen = strlen(echoString);
				sendto(clntSocket, echoString, strlen(echoString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			} else if (messages[idx + 1] == 2) {
				sprintf(echoString, "%d is busy", messages[idx + 2]);
				echoStringLen = strlen(echoString);
				sendto(clntSocket, echoString, strlen(echoString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			} else if (messages[idx + 1] == 3) {
				sprintf(echoString, "%d is talking with %d", messages[idx + 2], messages[idx + 3]);
				echoStringLen = strlen(echoString);
				sendto(clntSocket, echoString, strlen(echoString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			} else if (messages[idx + 1] == 4) {
				sprintf(echoString, "%d is ending talk with %d", messages[idx + 2], messages[idx + 3]);
				echoStringLen = strlen(echoString);
				sendto(clntSocket, echoString, strlen(echoString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
			}
			idx += 3;
			sleep(2);
		}
	}
}

void HandleUDPClient(int clntSocket, int* boltuns, int* messages, struct sockaddr_in echoServAddr)
{
	for (;;) {
		socklen_t clientAddressLen = sizeof(echoServAddr);
	    char echoBuffer[RCVBUFSIZE];
	    int recvMsgSize;
	    /* Receive message from client */
	    recvMsgSize = recvfrom(clntSocket, echoBuffer, RCVBUFSIZE - 2, 0, (struct sockaddr *)&echoServAddr, &clientAddressLen);
	echoBuffer[RCVBUFSIZE - 1] = '\0';
	    // printf("rec %s\n", echoBuffer);
		// if (strcmp(echoBuffer, "listener") == 0) {
		if (echoBuffer[0] == 'l' && echoBuffer[1] == 'i') {
			printf("listener started\n");
			handleListener(clntSocket, messages, echoServAddr);
		} else {
		  	char* input1 = echoBuffer;
		    int int1 = 0, int2 = 0;
		    sscanf(input1, "%d %d", &int1, &int2);
			if (int1 > boltuns[0] || int2 > boltuns[0]) {
			  int1 = int2 = 0;
			} 
			if (int1 * int2 != 0) {
				printf("int1: %d, int2: %d\n", int1, int2);
				int messIdx = messages[0] + 1;
				messages[0] += 3;
				messages[messIdx] = 1;
				messages[messIdx + 1] = int1;
				messages[messIdx + 2] = int2;
				char sndString[100];
				sprintf(sndString, "%d is calling to %d", int1, int2);
				sendto(clntSocket, sndString, strlen(sndString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
				if (int1 * int2 != 0 && boltuns[int1] + boltuns[int2] == 0) {
				    boltuns[int1] = int2;
				    boltuns[int2] = int1;
				    char sendString[100];
				    sprintf(sendString, "%d is takking with %d", int1, int2);
				    sendto(clntSocket, sendString, strlen(sendString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
					messIdx = messages[0] + 1;
					messages[0] += 3;
					messages[messIdx] = 3;
					messages[messIdx + 1] = int1;
					messages[messIdx + 2] = int2;
					for (int i = 1; i < boltuns[0] + 1; ++i) {
				      printf("%d ", boltuns[i]);
				    }
					printf("\n");
				    sleep(rand() % 4 + 20);
				    boltuns[int1] = 0;
				    boltuns[int2] = 0;
					sprintf(sendString, "%d is ending talk with %d", int1, int2);
					messIdx = messages[0] + 1;
					messages[0] += 3;
					messages[messIdx] = 4;
					messages[messIdx + 1] = int1;
					messages[messIdx + 2] = int2;
				    sendto(clntSocket, sendString, strlen(sendString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
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
						sprintf(sendString, "%d is busy", int2);
						messIdx = messages[0] + 1;
						messages[0] += 3;
						messages[messIdx] = 2;
						messages[messIdx + 1] = int2;
						messages[messIdx + 2] = 0;
					} else {
						sprintf(sendString, "%d is busy", int1);
						messIdx = messages[0] + 1;
						messages[0] += 3;
						messages[messIdx] = 2;
						messages[messIdx + 1] = int1;
						messages[messIdx + 2] = 0;
					}
					sendto(clntSocket, sendString, strlen(sendString), 0, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr));
					sleep(2);
			  	}
				sleep(2);
			}
			sleep(2);
		}
	}
}