//
//  main.m
//  InterCC
//
//  Created by Danylo Kostyshyn on 11/30/18.
//  Copyright © 2018 Danylo Kostyshyn. All rights reserved.
//

// libInter

//  launchctl unload /System/Library/LaunchDaemons/com.apple.CommCenter.plist
//  export DYLD_INSERT_LIBRARIES=/var/root/libInterCC.dylib
//  /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter

//  to interpose methods inside system dylib
//  extract it using jtool from dyld_shared_cache_armXXX
//  and link to the project

/*
 mv /Library/MobileSubstrate/DynamicLibraries/libInterCC.plist.dis \
 /Library/MobileSubstrate/DynamicLibraries/libInterCC.plist
 
 DYLD_INSERT_LIBRARIES=/var/root/libInterCC.dylib \
 /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter
 
 DYLD_INSERT_LIBRARIES=/Library/MobileSubstrate/MobileSubstrate.dylib \
 /System/Library/Frameworks/CoreTelephony.framework/Support/CommCenter
*/
 
#include "dyld-interposing.h"

#include "util.h"

#include "hook_stdlib.h"
#include "hook_iokit.h"
#include "hook_libBasebandUSB.h"
#include "hook_libATCommandStudioDynamic.h"
#include "hook_libQMIParserDynamic.h"
#include "hook_libBasebandManager.h"
#include "hook_XPC.h"

#pragma mark -

__attribute__((constructor)) void lib_main() {
    init_utils();
    qmilog("%slibInter injected%s\n", BGRED, BGNRM);

    hook_stdlib();
//    hook_iokit();
//    hook_libBasebandUSB();
//    hook_libATCommandStudioDynamic();
//    hook_libQMIParserDynamic();
//    hook_libBasebandManager();
//    hook_XPC();
}
