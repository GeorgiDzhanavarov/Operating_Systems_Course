#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <err.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <stdbool.h>

int main(int argc, char* argv[]){
        if(argc == 1){
                char buf[4096];

                ssize_t bytes_read;

                while( (bytes_read = read(0, &buf, sizeof(buf))) > 0){
                        if(write(1, &buf, bytes_read) != bytes_read){
                                err(2, "Error writing");
                        }
                }

                if(bytes_read == -1){
                        err(1, "Error reading");
                }

                exit(0);
        }

        bool numbers = false;
        int lines = 1;
        bool newLine = true;
        int argcCnt = 1;

        setbuf(stdout, NULL);

        if(strcmp(argv[1], "-n") == 0){
                numbers = true;
                argcCnt = 2;

                if(argc == 2){
                        char buf;
                        ssize_t bytes_read;
                        while((bytes_read = read(0, &buf, sizeof(buf))) > 0){
                                if(newLine){
                                        printf("%d ", lines);
                                        newLine = false;
                                }

                                if(buf == '\n'){
                                        lines++;
                                        newLine = true;
                                }

                                if(write(1, &buf, sizeof(buf)) < 0){
                                        err(2, "Error writing");
                                }
                        }

                        if(bytes_read == -1){
                                err(1, "Error reading");
                        }

                        exit(0);
                }
        }

        for(; argcCnt < argc; argcCnt++){
                int fd;
                if(strcmp(argv[argcCnt], "-") == 0){
                        fd = 0;
                }
                else{
                        fd = open(argv[argcCnt], O_RDONLY);
                        if(fd < 0){
                                warn("Cant open file");
                                continue;
                        }
                }

                char buf;
                ssize_t bytes_read;

                while((bytes_read = read(fd, &buf, sizeof(buf))) > 0){
                        if(numbers && newLine){
                                printf("%d ", lines);
                                newLine = false;
                        }

                        if(numbers && buf == '\n'){
                                lines++;
                                newLine = true;
                        }

                        if(write(1, &buf, sizeof(buf)) < 0){
                                err(2, "Error writing");
                        }
                }

                if(bytes_read == -1){
                        err(1, "Error reading");
                }

                if(fd != 0){
                        close(fd);
                }
        }

        exit(0);
}
