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

//FILE *_fopen(const char *filename, const char *mode) {
//    qmilog("MSHookFunction\n");
//    ENABLE_COLOR(FGBLU)
//    FILE *file = fopen(filename, mode);
//    qmilog("%s(%s, %s) -> %p\n", __func__, filename, mode, file);
//    DISABLE_COLOR
//    return file;
//}; DYLD_INTERPOSE(_fopen, fopen)
//
//int _fclose(FILE *file) {
//    ENABLE_COLOR(FGBLU)
//    qmilog("%s(%p)\n", __func__, file);
//    DISABLE_COLOR
//    return fclose(file);
//} DYLD_INTERPOSE(_fclose, fclose)

#pragma mark - stdlib

void hook_stdlib() {
//    MSHookFunction((void *)&fopen, (void *)&_fopen, (void **)&orig_fopen);
}
