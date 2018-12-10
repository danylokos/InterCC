//
//  hook_XPC.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_XPC.h"

#include "util.h"
#include <substrate.h>

//#include <xpc/xpc.h>

//extern "C" xpc_connection_t _xpc_connection_create(const char *name, dispatch_queue_t targetq) {
//    DEBUG_LOG
//    qmilog("\t-> xpc_connection_create name: %s\n", name);
//    return xpc_connection_create(name, targetq);
//} DYLD_INTERPOSE(_xpc_connection_create, xpc_connection_create)

// crashing
//extern "C" xpc_endpoint_t _xpc_endpoint_create(xpc_connection_t connection) {
//    DEBUG_LOG_RED
//    return xpc_endpoint_create(connection);
//} DYLD_INTERPOSE(_xpc_endpoint_create, xpc_endpoint_create)

#pragma mark -

void hook_XPC() {

}
