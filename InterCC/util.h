//
//  util.h
//  usblogger
//
//  Created by Joshua Hill on 1/29/13.
//
//

#ifndef usblogger_util_h
#define usblogger_util_h

#include <stdio.h>
#include <Foundation/Foundation.h>

#include "colors.h"

#define CONSOLE_OUTPUT

#ifdef CONSOLE_OUTPUT
#define DEBUG_LOG                   qmilog("INTER: %s: %s\n", get_time(), __func__);
#define DEBUG_LOG_COLOR(color)      qmilog("%sINTER: %s: %s%s\n", color, get_time(), __func__, FGNRM);
#define DEBUG_LOG_RED               DEBUG_LOG_COLOR(FGRED)
#define DEBUG_LOG_BLUE              DEBUG_LOG_COLOR(FGBLU)
#define ENABLE_COLOR(color)         qmilog("%s", color);
#define DISABLE_COLOR               qmilog("%s%s", FGNRM, BGNRM);
#else
#define DEBUG_LOG                   qmilog("INTER: %s\n", __func__);
#define DEBUG_LOG_COLOR(color)      DEBUG_LOG
#define DEBUG_LOG_RED               DEBUG_LOG
#define DEBUG_LOG_BLUE              DEBUG_LOG
#define ENABLE_COLOR(color)
#define DISABLE_COLOR
#endif

extern dispatch_queue_t log_queue;

#define DEBUG_LOG_SYNC(...) dispatch_sync(log_queue, ^{ __VA_ARGS__ });

void init_utils();

void fhexdump(FILE *fd, uint8_t *data, size_t amount);

void hexdump(uint8_t *data, size_t amount);

void hexdumpcc(uint8_t *data, size_t amount, const char *color);

//void hexdumpc(uint8_t *data, size_t amount);

void hexdumpct(uint8_t *data, size_t amount);

void qmilog(const char* fmt, ...);

char *get_time();

#endif
