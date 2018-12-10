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
#include <sys/time.h>
#include <iostream>

#include "util.h"

#include <Foundation/Foundation.h>

#define LOG_FILE_PATH "/var/tmp/libInterCC.log"

void fhexdump(FILE *fd, uint8_t *data, size_t amount) {
    size_t    dp, p;  /* data pointer */
    const char      trans[] =
    "................................ !\"#$%&'()*+,-./0123456789"
    ":;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklm"
    "nopqrstuvwxyz{|}~...................................."
    "....................................................."
    "........................................";
    
    
    for (dp = 1; dp <= amount; dp++) {
        fprintf(fd, "%02x ", data[dp-1]);
        if ((dp % 8) == 0)
            fprintf(fd, " ");
        if ((dp % 16) == 0) {
            fprintf(fd, "| ");
            p = dp;
            for (dp -= 16; dp < p; dp++)
                fprintf(fd, "%c", trans[data[dp]]);
            fflush(fd);
            fprintf(fd, "\n");
        }
        fflush (fd);
    }
    // tail
    if ((amount % 16) != 0) {
        p = dp = 16 - (amount % 16);
        for (dp = p; dp > 0; dp--) {
            fprintf(fd, "   ");
            if (((dp % 8) == 0) && (p != 8))
                fprintf(fd, " ");
            fflush (fd);
        }
        fprintf(fd, " | ");
        for (dp = (amount - (16 - p)); dp < amount; dp++)
            fprintf(fd, "%c", trans[data[dp]]);
        fflush(fd);
    }
    fprintf(fd, "\n");
    return;
}

ssize_t format_timeval(struct timeval *tv, char *buf, size_t sz) {
    ssize_t written = -1;
    struct tm *gm = gmtime(&tv->tv_sec);
    
    if (gm) {
        written = (ssize_t)strftime(buf, sz, "%Y-%m-%d %H:%M:%S", gm);
        if ((written > 0) && ((size_t)written < sz)) {
            int w = snprintf(buf+written, sz-(size_t)written, ".%6d", tv->tv_usec);
            written = (w > 0) ? written + w : -1;
        }
    }
    return written;
}

char *get_time() {
    size_t len = 28;
    struct timeval tv;
    char *buf = (char *)malloc(sizeof(char) * len);
    if (gettimeofday(&tv, NULL) != 0) {
//        printf("gettimeofday");
        return NULL;
    }
    if (format_timeval(&tv, buf, len) > 0) {
        return buf;
    }
    return NULL;
}

dispatch_queue_t log_queue;
static pthread_mutex_t mtx;
static FILE *fd;

void init_utils() {
    log_queue = dispatch_queue_create("org.kostyshyn.log.queue", DISPATCH_QUEUE_SERIAL);
    if (pthread_mutex_init(&mtx, NULL) != 0) {
        fprintf(stdout, "Mutex init error");
    }
    fd = fopen(LOG_FILE_PATH, "a+");
}

void hexdump(uint8_t *data, size_t amount) {
    pthread_mutex_lock(&mtx);
//    FILE *fd = fopen(LOG_FILE_PATH, "a+");
    fhexdump(fd, data, amount);
    fflush(fd);
//    fclose(fd);
    fhexdump(stdout, data, amount);
    fflush(stdout);
    pthread_mutex_unlock(&mtx);
}

void qmilog(const char* fmt, ...) {
    pthread_mutex_lock(&mtx);
//    FILE *fd = fopen(LOG_FILE_PATH, "a+");
    va_list args;
    va_start(args, fmt);
    vfprintf(fd, fmt, args);
//    vprintf(fmt, args);
    va_end(args);
//    fflush(stdout);
    fflush(fd);
//    fclose(fd);
    pthread_mutex_unlock(&mtx);
}

#pragma mark -

void hexdumpcc(uint8_t *data, size_t amount, const char *color) {
    ENABLE_COLOR(color)
    hexdump(data, amount);
    DISABLE_COLOR
}

void hexdumpc(uint8_t *data, size_t amount) {
    hexdumpcc(data, amount, FGCYN);
}

void hexdumpct(uint8_t *data, size_t amount) {
//#ifdef CONSOLE_OUTPUT
//    size_t limit = 128;
//    if (amount <= limit) {
//        hexdumpc(data, amount);
//    } else {
//        qmilog("\t-> > %d bytes, truncating\n", limit);
//        qmilog("\t-> first %d bytes\n", limit);
//        hexdumpc(data, MIN(amount, limit));
//        qmilog("\t-> last %d bytes\n", limit);
//        hexdumpc(data+amount-limit, limit);
//    }
//#else
    hexdumpc(data, amount);
//#endif
}

#endif /* defined(__dloadtool__util__) */
