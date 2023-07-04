#include <stdint.h>
#include <stdlib.h>
#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

typedef struct data{
     uint16_t offset;
     uint8_t length;
     uint8_t other;
}__attribute__((packed)) data;

/*
typedef struct data{
     uint16_t offset;
     uint8_t length;
     uint8_t other;
}data;
*/



int main(int argc, char* argv[]){
        if(argc != 5){
                errx(1, "We need 4 arguments!");
        }

        int fd1 = open(argv[1], O_RDONLY);
        if(fd1 < 0){
                err(2, "Error openig");
        }

        int fd2 = open(argv[2], O_RDONLY);
        if(fd2 < 0){
                err(2, "Error openig");
        }

        int fd3 = open(argv[3], O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR, S_IWUSR);
        if(fd3 < 0){
                err(2, "Error openig");
        }

        int fd4 = open(argv[4], O_CREAT | O_TRUNC | O_WRONLY, S_IRUSR, S_IWUSR);
        if(fd4 < 0){
                err(2, "Error opening");
        }

        struct stat st;
        if(stat(argv[2], &st) < 0){
                err(3, "Error stat");
        }

        data index;

        if(st.st_size % sizeof(index) != 0){
                errx(4, "Incorrect format");
        }

        //uint16_t towrite_offset = 0x0000;
        ssize_t bytes_read;
                data towrite = {.offset=0, .length=0, .other=0};

        while( (bytes_read = read(fd2, &index, sizeof(index))) > 0){
                if(lseek(fd1, index.offset, SEEK_SET) < 0){
                        err(6, "Error lseek");
                }

                char buf;

                if(read(fd1, &buf, 1) <= 0){
                        err(5, "Error reading");
                }

                if(buf <= 'A' || buf >= 'Z'){
                        continue;
                }

                if(write(fd3, &buf, sizeof(buf)) <= 0){
                        err(7, "Error writing");
                }

                ssize_t toread = 1;

                while(toread < index.length){
                        if(read(fd1, &buf, sizeof(buf)) <= 0){
                                err(5, "Error reading");
                        }

                        toread = toread + sizeof(char);

                        if(write(fd3, &buf, 1) <= 0){
                                err(7, "Error writing");
                        }
                }


                if(write(fd4, &towrite, sizeof(towrite)) < (ssize_t)sizeof(towrite)){
                        err(7, "Error writing");
                }

                                towrite.offset+=index.length;
                        towrite.length=index.length;

        }

        if(bytes_read == -1){
                err(5, "Error readind");
        }

        close(fd1);
        close(fd2);
        close(fd3);
        close(fd4);

        exit(0);
}
