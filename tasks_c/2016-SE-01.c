#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdint.h>
#include <err.h>

int main(int argc, char* argv[]){
        if (argc != 2){
                errx(1, "We need one argument!");
        }

        int fd = open(argv[1], O_RDWR);
        if(fd < 0){
                err(2, "Error opening the file!");
        }

        uint8_t countingSort[256] = {0};

                uint8_t buf;
                ssize_t read_bytes;

                while ( (read_bytes = read(fd, &buf, 1)) > 0 ){
                        //printf("%02x | %d \n ",buf,buf );
                        countingSort[buf]++;
                }

                if (read_bytes == -1){
                        err(3, "Error reading!");
                }

                if ( lseek(fd, 0, SEEK_SET) == -1){
                        err(4, "Error while lseek");
                }

                for (int i = 0; i < 256; i++){
                        while (countingSort[i] > 0){
                                if (write(fd, &i, 1) == -1){
                                        err(5, "Error while writing");
                                }
                                countingSort[i]--;
                        }

                }

                close(fd);
                exit(0);
}
