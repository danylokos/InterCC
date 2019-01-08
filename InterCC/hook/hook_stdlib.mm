//
//  hook_stdlib.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_stdlib.h"

#include "util.h"
#include <substrate.h>

#include <stdlib.h>

static FILE * (*orig_fopen)(const char *filename, const char *mode);
FILE *_fopen(const char *filename, const char *mode) {
    ENABLE_COLOR(FGBLU)
    FILE *fh = orig_fopen(filename, mode);
    qmilog("%s(%s, %s) -> %p\n", __func__, filename, mode, fh);
    DISABLE_COLOR
    return fh;
}; //DYLD_INTERPOSE(_fopen, fopen)

static int (*orig_fclose)(FILE *file);
int _fclose(FILE *file) {
    ENABLE_COLOR(FGBLU)
    qmilog("%s(%p)\n", __func__, file);
    DISABLE_COLOR
    return orig_fclose(file);
} //DYLD_INTERPOSE(_fclose, fclose)

#pragma mark - stdlib

void hook_stdlib() {
    MSHookFunction((void *)&fopen, (void *)&_fopen, (void **)&orig_fopen);
    MSHookFunction((void *)&fclose, (void *)&_fclose, (void **)&orig_fclose);
}
