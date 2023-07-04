#include <stdint.h>
#include <unistd.h>
#include <err.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <fcntl.h>

#define MAXP 8
#define MAXN 8

struct row_s {
        char            fname[MAXN];
        uint32_t        off;
        uint32_t        len;
};

typedef struct row_s row_t;

int main(int argc, const char* argv[])
{
        if (argc != 2) {
                errx(1, "Usage: %s index", argv[0]);
        }

        row_t arr[MAXP];

//      printf("%ld\n", sizeof(arr));

        int fi = 0;
        if ((fi=open(argv[1], O_RDONLY)) == -1) {
                err(2, "Cannot open %s", argv[1]);
        }

        struct stat st;
        if (fstat(fi, &st) == -1) {
                err(3, "Cannot stat %s", argv[1]);
        }

        if (((long unsigned int)st.st_size > sizeof(arr)) ||
                (st.st_size % sizeof(row_t) != 0)) {
                        err(4, "Inconsistent %s", argv[1]);
        }

        size_t nrows = st.st_size / sizeof(row_t);
//      printf("%ld\n", nrows);

        if (read(fi, arr, nrows * sizeof(row_t)) != (ssize_t)(nrows * sizeof(row_t))) {
                err(5, "Cannot read rows from %s", argv[1]);
        }
        close(fi);

        for (size_t i = 0; i < nrows; i++) {
//              printf("%s %d %d\n", arr[i].fname, arr[i].off, arr[i].len);
                if (arr[i].fname[MAXN-1] != 0x00) {
                        errx(6, "Wrong filename record in %s", argv[1]);
                }
        }

        int p[2];
        if (pipe(p) == -1) {
                err(7, "Cannot create pipe");
        }


        pid_t c = 0;
        size_t i = 0;

        for (i = 0; i < nrows; i++) {
                if ((c = fork()) == -1) {
                        err(1, "cannot fork");
                }
                if (c == 0) {
                        close(p[0]);
                        break;
                }
        }

        if (c == 0) {
                fprintf(stderr, "c: %ld f: %s o: %d l: %d\n", i, arr[i].fname, arr[i].off, arr[i].len);

                if ((fi=open(arr[i].fname, O_RDONLY)) == -1) {
                        err(8, "Cannot open %s", arr[i].fname);
                }

                if (fstat(fi, &st) == -1) {
                        err(9, "Cannot fstat %s", arr[i].fname);
                }

                if (((arr[i].off + arr[i].len)*sizeof(uint16_t)) >
                        (long unsigned int)st.st_size) {
                                err(10, "Wrong size of %s based on %s", arr[i].fname, argv[1]);
                }

                if (lseek(fi, arr[i].off * sizeof(uint16_t), SEEK_SET) == -1) {
                                err(11, "Cannot seek in %s", arr[i].fname);
                }

                uint16_t r = 0x0000;
                uint16_t e = 0x0000;
                for (uint32_t j = 0; j < arr[i].len; j++) {
                        if (read(fi, &e, sizeof(e)) != sizeof(e)) {
                                err(12, "Cannot read from %s", arr[i].fname);
                        }
//                      fprintf(stderr, "c: %ld e: %04X\n", i, e);
                        r ^= e;
                }
//              fprintf(stderr, "c: %ld r: %04X\n", i, r);

                if (write(p[1], &r, sizeof(r)) != sizeof(r)) {
                        err(13, "c: %ld cannot write result in pipe", i);
                }

                close(fi);
                close(p[1]);
                exit(0);
        }

        close(p[1]);
//      fprintf(stderr, "p i: %ld\n", i);

        uint16_t r = 0x0000;
        uint16_t e = 0x0000;
        while (read(p[0], &e, sizeof(e)) == sizeof(e)) {
//              fprintf(stderr, "pesho: %04X\n", e);
                r ^= e;
        }

        printf("result: %04X\n", r);
        return 0;
}
