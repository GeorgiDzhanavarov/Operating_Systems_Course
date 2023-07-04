#include <stdint.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>

typedef struct s1_header{
        uint32_t magic;
        uint32_t count;
}__attribute__((packed)) s1_header;

typedef struct s2_header{
        uint32_t magic1;
        uint16_t magic2;
        uint16_t reserved;
        uint64_t count;
}__attribute__((packed)) s2_header;

typedef struct s2_data{
        uint16_t type;
        uint16_t reserved1;
        uint16_t reserved2;
        uint16_t reserved3;
        uint32_t offset1;
        uint32_t offset2;
}__attribute__((packed)) s2_data;


int main(int argc, char** argv){
        if (argc != 3)
                errx(1,"Wrong number of arguments");

        s1_header s1_h;
        s2_header s2_h;
        s2_data s2_d;

        struct stat s1;
        struct stat s2;

        if (stat(argv[1],&s1) == -1){
                err(2, "Error while trying to stat");
        }

    if (stat(argv[2],&s2) == -1){
        err(2, "Error while trying to stat");
    }

        int fd1 = open(argv[1], O_RDWR);
        if (fd1 == -1){
                err(4, "Error while opening f1");
        }

        if (read(fd1, &s1_h, sizeof(s1_h)) == -1){
                err(5, "Error while reading");
        }
        if (s1_h.magic != 0x21796F4A ){
                errx(6,"Wrong magic number");
        }

        int fd2 = open(argv[2], O_RDONLY);
        if (fd2 == -1){
        err(4, "Error while opening f1");
    }


    if (read(fd2, &s2_h, sizeof(s2_h)) == -1){
        err(5, "Error while reading");
    }
    if ((s1.st_size - sizeof(s1_h)) % s1_h.count != 0){
        errx(3, "Error wrong size of f1");
    }
    if ((s1.st_size - sizeof(s1_h)) % sizeof(uint64_t) != 0){
        errx(3, "Error wrong size of f1 data ");
    }
    if (s2_h.magic1 != 0xAFBC7A37 ){
        errx(6,"Wrong magic number");
    }
        if (s2_h.magic2 != 0x1C27){
                errx(6, "Wrong magic number");
        }

        if ((s2.st_size - sizeof(s2_h))% s2_h.count != 0){
        errx(3, "Error wrong size of f2");
    }
        ssize_t rs = -1;
        uint64_t el1;
        uint64_t el2;
        while ( (rs = read(fd2, &s2_d, sizeof(s2_d))) > 0){
                if (rs == -1){
                        err(4, "Error while reading");
                }

                if (s2_d.type != 0 && s2_d.type != 1 ){
                        errx(5, "Type should be 0 or 1");
                }

                if (s2_d.reserved1 != 0 || s2_d.reserved2 != 0 || s2_d.reserved3 != 0){
                        errx(6, "All reserved should be 0");
                }
                if (s2_d.type == 0){
                        //less
                        if ( s2_d.offset1 > s1_h.count){
                                errx(6, "There is no such address in f1");
                        }
                        if ( s2_d.offset2 > s1_h.count){
                errx(6, "There is no such address in f1");
            }
                        if ( lseek(fd1,sizeof(s1_h)+(s2_d.offset1*sizeof(uint64_t)) , SEEK_SET)== -1){
                                err(7, "Error while leek");
                        }
                        if ( read(fd1,&el1,sizeof(el1)) == -1){
                                err(8, "Error while reading");
                        }

                        if ( lseek(fd1,sizeof(s1_h)+(s2_d.offset2*sizeof(uint64_t)) , SEEK_SET)== -1){
                err(7, "Error while leek");
            }
            if ( read(fd1,&el2,sizeof(el2)) == -1){
                err(8, "Error while reading");
            }
                        //check if that is the right way to compare
                        if ( el1 > el2){
                                lseek(fd1,sizeof(s1_h)+(s2_d.offset1*sizeof(uint64_t)) , SEEK_SET);
                                if (write(fd1,&el2,sizeof(el2)) != sizeof(el2)){
                                        err(5, "Error while writing");
                                }
                                lseek(fd1,sizeof(s1_h)+(s2_d.offset2*sizeof(uint64_t)) , SEEK_SET);
                if (write(fd1,&el1,sizeof(el1)) != sizeof(el2)){
                    err(5, "Error while writing");
                }
                        }
                }else{
                        //bigger
            if ( s2_d.offset2 > s1_h.count){
                errx(6, "There is no such address in f1");
            }
            if ( s2_d.offset1 > s1_h.count){
                errx(6, "There is no such address in f1");
            }

            if ( lseek(fd1,sizeof(s1_h)+(s2_d.offset1*sizeof(uint64_t)) , SEEK_SET)== -1){
                err(7, "Error while leek");
            }
            if ( read(fd1,&el1,sizeof(el1)) == -1){
                err(8, "Error while reading");
            }

            if ( lseek(fd1,sizeof(s1_h)+(s2_d.offset2*sizeof(uint64_t)) , SEEK_SET)== -1){
                err(7, "Error while leek");
            }
            if ( read(fd1,&el2,sizeof(el2)) == -1){
                err(8, "Error while reading");
            }
            //check if that is the right way to compare
                        if ( el1 < el2){
                lseek(fd1,sizeof(s1_h)+(s2_d.offset1*sizeof(uint64_t)) , SEEK_SET);
                if (write(fd1,&el2,sizeof(el2)) != sizeof(el2)){
                    err(5, "Error while writing");
                }
                lseek(fd1,sizeof(s1_h)+(s2_d.offset2*sizeof(uint64_t)) , SEEK_SET);
                if (write(fd1,&el1,sizeof(el1)) != sizeof(el2)){
                    err(5, "Error while writing");
                }
            }
                }


        }
        close(fd2);
        close(fd1);
        return 0;

}
