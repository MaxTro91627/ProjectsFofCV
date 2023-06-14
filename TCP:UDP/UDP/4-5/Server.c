#include "UDPEchoServer.h"
#include <sys/wait.h>       /* for waitpid() */
#include <stdlib.h>
#include <sys/wait.h>
#include <time.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <sys/stat.h>
#include <sys/fcntl.h>
#include <string.h>
#include <arpa/inet.h>
#include "sys/shm.h"

#define SHM_NAME1 "/boltuns"
#define SHM_NAME2 "/ports"

int N;
int shm_fd_1;
int shm_fd_2;
int *boltuns;
int *ports;

void my_handler(int nsig) {

  munmap(boltuns, N + 2);
  close(shm_fd_1);
  shm_unlink(SHM_NAME1);
  munmap(ports, N + 2);
  close(shm_fd_2);
  shm_unlink(SHM_NAME2);

    exit(0);
}

int main(int argc, char** argv) {
	signal(SIGINT, my_handler);
  	int clntSock;                    /* Socket descriptor for client */
  	unsigned short echoServPort;     /* Server port */
 	pid_t processID;                 /* Process ID from fork() */
  	unsigned int childProcCount = 0; /* Number of child processes */
	struct ThreadArgs *threadArgs;

    if (argc != 3)     /* Test for correct number of arguments */
    {
        fprintf(stderr, "Usage:  %s <Server Port> <N>\n", argv[0]);
        exit(1);
    }
    
    echoServPort = atoi(argv[1]);  /* First arg:  local port */

    N = atoi(argv[2]);
    shm_fd_1 = shm_open(SHM_NAME1, O_CREAT | O_RDWR, 0644);
    ftruncate(shm_fd_1, N + 2);
    boltuns = mmap(NULL, N + 2, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd_1, 0);

	shm_fd_2 = shm_open(SHM_NAME2, O_CREAT | O_RDWR, 0644);
  	ftruncate(shm_fd_2, N + 2);
  	ports = mmap(NULL, N + 2, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd_2, 0);

    for(int i = 0; i < N + 1; ++i) {
      boltuns[i] = 0;
	  ports[i] = 0;
    }
    boltuns[0] = N;
	struct sockaddr_in echoServAddr;
    for (int i = 0; i < N; ++i) {
		pid_t processID = fork();
	    /* Fork child process and report any errors */
	    if (processID < 0)
	      DieWithError("fork() failed");
	    else if (processID == 0) {
			int servSock;
			servSock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		 	echoServAddr.sin_family = AF_INET;
			echoServAddr.sin_addr.s_addr = INADDR_ANY;
			
			echoServAddr.sin_port = htons(echoServPort + i);
			if (bind(servSock, (struct sockaddr *) &echoServAddr, sizeof(echoServAddr)) < 0)
	                DieWithError("bind() failed");
	      	HandleUDPClient(clntSock, boltuns, ports, echoServAddr);
	      	close(servSock); /* Child closes parent socket */
	      	exit(0); /* Child process terminates */
	    }
        
        printf("with child process: %d\n", (int) processID);
        close(clntSock);       /* Parent closes child socket descriptor */
        childProcCount++;      /* Increment number of outstanding child processes */

        while (childProcCount) /* Clean up all zombies */
        {
            processID = waitpid((pid_t) -1, NULL, WNOHANG);  /* Non-blocking wait */
            if (processID < 0)  /* waitpid() error? */
                DieWithError("waitpid() failed");
            else if (processID == 0)  /* No zombie to wait on */
                break;
            else
                childProcCount--;  /* Cleaned up after a child */ 
        }
    }
}