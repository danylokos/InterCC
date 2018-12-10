//
//  hook_libBasebandManager.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_libBasebandManager.h"

#include "util.h"
#include <substrate.h>

//extern "C" unsigned int ETLDLOADCommandSend(void *a1);
//unsigned int _ETLDLOADCommandSend(void *a1) {
//    DEBUG_LOG_RED
//    return ETLDLOADCommandSend(a1);
//} DYLD_INTERPOSE(_ETLDLOADCommandSend, ETLDLOADCommandSend)

#pragma mark -

void hook_libBasebandManager() {
    
}
