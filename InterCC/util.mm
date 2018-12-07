//
//  util.h
//  dloadtool
//
//  Created by Joshua Hill on 1/31/13.
//
//

#ifndef __dloadtool__util__
#define __dloadtool__util__


#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#include <iostream>

#include "util.h"

void hexdump (unsigned char *data, unsigned int amount) {
    unsigned int    dp, p;  /* data pointer */
    const char      trans[] =
    "................................ !\"#$%&'()*+,-./0123456789"
    ":;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklm"
    "nopqrstuvwxyz{|}~...................................."
    "....................................................."
    "........................................";
    
    
    for (dp = 1; dp <= amount; dp++) {
        fprintf (stdout, "%02x ", data[dp-1]);
        if ((dp % 8) == 0)
            fprintf (stdout, " ");
        if ((dp % 16) == 0) {
            fprintf (stdout, "| ");
            p = dp;
            for (dp -= 16; dp < p; dp++)
                fprintf (stdout, "%c", trans[data[dp]]);
            fflush (stdout);
            fprintf (stdout, "\n");
        }
        fflush (stdout);
    }
    // tail
    if ((amount % 16) != 0) {
        p = dp = 16 - (amount % 16);
        for (dp = p; dp > 0; dp--) {
            fprintf (stdout, "   ");
            if (((dp % 8) == 0) && (p != 8))
                fprintf (stdout, " ");
            fflush (stdout);
        }
        fprintf (stdout, " | ");
        for (dp = (amount - (16 - p)); dp < amount; dp++)
            fprintf (stdout, "%c", trans[data[dp]]);
        fflush (stdout);
    }
    fprintf (stdout, "\n");
    
    return;
}

void qmilog(const char* fmt, ...) {
    FILE *fd = fopen("/var/wireless/Library/Logs/libInterCC.log", "a+");
    va_list args;
    va_start(args, fmt);
    vfprintf(fd, fmt, args);
    vprintf(fmt, args);
    va_end(args);
    fflush(stdout);
    fflush(fd);
    fclose(fd);
}

#endif /* defined(__dloadtool__util__) */
