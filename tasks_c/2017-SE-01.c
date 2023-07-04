#include <stdint.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <err.h>
#include <unistd.h>
#include <sys/types.h>

int main(int argc, char* argv[]){

        if(argc != 4){
                errx(1, "We need 3 arguments");
        }

        struct stat st1;
        struct stat st2;

        if(stat(argv[1], &st1) < 0){
                err(2, "Error stat");
        }

        if(stat(argv[2], &st2) < 0){
                err(2, "Error stat");
        }

        if(st1.st_size != st2.st_size){
                errx(3, "Files must have same length");
        }

                //0xFFFF = UINT16_T = 65 535
                if(st1.st_size > 0xFFFF){
                warnx("Size of file is too big. Patch file maybe not correct");
        }


        int fd1 = open(argv[1], O_RDONLY);
        if(fd1 < 0){
                err(4, "Error opening");
        }

        int fd2 = open(argv[2], O_RDONLY);
        if(fd2 < 0){
                err(4, "Error opening");
        }

        int fd3 = open(argv[3], O_CREAT | O_TRUNC | O_RDWR, S_IRUSR, S_IWUSR);
        if(fd3 < 0){
                err(4, "Error opening");
        }

        struct data {
                uint16_t offset;
                uint8_t b1;
                uint8_t b2;
        }__attribute__((packed));

        struct data d;

        for(d.offset = 0; d.offset < st1.st_size; d.offset++){
                if(read(fd1, &d.b1, sizeof(d.b1)) <= 0){
                        err(5, "Error reading");
                }

                if(read(fd2, &d.b2, sizeof(d.b2)) <= 0){
                        err(5, "Error reading");
                }

                if(d.b1 != d.b2){
                        if(write(fd3, &d, sizeof(d)) != sizeof(d)){
                                err(6, "Error writing");
                        }
                }
        }

        close(fd1);
        close(fd2);
        close(fd3);

    exit(0);
}
