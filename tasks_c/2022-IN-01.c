#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>

int main(int argc, char** argv){
        if (argc != 3)
                errx(1, "Wrong number of arguments");

        int N= argv[1][0] - '0';
        int D= argv[2][0] - '0';

        //OR

//      int N = atoi(argv[1]);
//  int D = atoi(argv[2]);

        if (strlen(argv[1]) > 1){
                errx(6, "Wrong size of number");
        }
    if (strlen(argv[2]) > 1){
        errx(6, "Wrong size of number");
        }

        if (N <= 0){
                errx(6, "Nothing to be printed");
        }

        char child[5] = "DONG\n";
        char parent[5] = "DING ";
        int p1[2]; // unbloack_child
        int p2[2]; // unblock_parent
        int a = 42;

        if (pipe(p1) == -1)
                err(8, "Error while pipe");

        if (pipe(p2) == -1)
        err(8, "Error while pipe");


        pid_t pid = fork();

        if (pid == -1)
                err(7, "Error while fork");

        if (pid == 0){
                close(p1[0]);
                close(p2[1]);

                for (int i = 0; i < N; i++){
                        // This read will be successful only after parent write into the pipe and unblock the read action
                        if (read(p2[0],&a,sizeof(a)) == -1)
                                err(3, "Error while reading");
                        if (write(1,&child,5) != 5)
                                err(2, "Error while writing child");

                        //Signaling to the parent
                        if (write(p1[1],&a,sizeof(a)) != sizeof(a))
                                err(2, "Error while writing c");

                }
//              exit(0);
        }else{
                close(p2[0]);
                close(p1[1]);

                for (int i = 0; i < N; i++){
                        if (write(1, &parent,5) != 5)
                                err(3, "Error while writing parent" );

                        if (write(p2[1], &a, sizeof(a)) != sizeof(a)){
                                err(2, "Error while writing p");
                        }

                        if (read(p1[0],&a,sizeof(a)) == -1)
                                err(3, "Error while reading");

                        sleep(D);

                }
        }
        close(p2[1]);
        close(p1[0]);
        return 0;

}
