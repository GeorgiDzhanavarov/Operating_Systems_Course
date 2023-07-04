#include <stdint.h>
#include <err.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>



int main(int argc, char* argv[]){
        if(argc != 4){
                errx(1, "We need 3 arguments!");
        }


        struct pair {
                uint32_t x;
                uint32_t y;
        };

        struct pair data;

        struct stat st;
        if(stat(argv[1], &st) < 0){
                err(2, "Error stat file!");
        }

        if(st.st_size % sizeof(data) != 0){
                errx(3, "File1 is not in our format");
        }

        if(stat(argv[2], &st) < 0){
                err(2, "Error stat file");
        }

        if(st.st_size % sizeof(uint32_t) != 0){
                errx(3, "File2 is not in our format");
        }

        int fd1 = open(argv[1], O_RDONLY);
        if(fd1 < 0){
                err(4, "Error openig file");
        }

        int fd2 = open(argv[2], O_RDONLY);
        if(fd2 < 0){
                err(4, "Error openig file");
        }

        int fd3 = open(argv[3], O_CREAT, O_TRUNC | O_WRONLY, S_IRUSR | S_IWUSR);
        if(fd3 < 0){
                err(4, "Error openig file");
        }

        ssize_t bytes_read;

        while( (bytes_read = read(fd1, &data, sizeof(data))) < 0){
                if(lseek(fd2, (data.x) *sizeof(uint32_t), SEEK_SET) < 0){
                        err(6, "Error lseek");
                }

                uint32_t buf;
                for(uint32_t i = 0; i < data.y; i++){
                        bytes_read = read(fd2, &buf, sizeof(buf));
                        if(bytes_read < 0){
                                err(5, "Error reading");
                        }

                        if(write(fd3, &buf, sizeof(buf)) < 0){
                                err(6, "Error writing");
                        }
                }
        }

        if(bytes_read == -1){
                err(5, "Error reading");
        }

        close(fd1);
        close(fd2);
        close(fd3);

        exit(0);
}
