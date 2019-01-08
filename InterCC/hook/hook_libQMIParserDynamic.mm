//
//  hook_libQMIParserDynamic.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_libQMIParserDynamic.h"

#include "util.h"
#include <substrate.h>

#define qmi_MessageBase_MessageBase _ZN3qmi11MessageBaseC2EPKvm
extern "C" MSReturn qmi_MessageBase_MessageBase(void *a1, void *a2, unsigned int a3);
static MSReturn (*orig_qmi_MessageBase_MessageBase)(void *a1, void *a2, unsigned int a3);
MSReturn _qmi_MessageBase_MessageBase(void *a1, void *a2, unsigned int a3) {
    DEBUG_LOG_SYNC(
        DEBUG_LOG_COLOR(FGGRN)
        qmilog("\t\t a1: %p, a2: %p, a3: %d\n", a1, a2, a3);
        hexdump((uint8_t *)a2, a3);
    )
    return orig_qmi_MessageBase_MessageBase(a1, a2, a3);
} //DYLD_INTERPOSE(_qmi_MessageBase_MessageBase, qmi_MessageBase_MessageBase)

#define qmi_ResponseBase_ResponseBase _ZN3qmi12ResponseBaseC2EPKvm
extern "C" MSReturn qmi_ResponseBase_ResponseBase(void *a1, void *a2, unsigned int a3);
static MSReturn (*orig_qmi_ResponseBase_ResponseBase)(void *a1, void *a2, unsigned int a3);
MSReturn _qmi_ResponseBase_ResponseBase(void *a1, void *a2, unsigned int a3) {
    DEBUG_LOG_SYNC(
        DEBUG_LOG_COLOR(FGGRN)
        qmilog("\t\t a1: %p, a2: %p, a3: %d\n", a1, a2, a3);
        hexdump((uint8_t *)a2, a3);
    )
    return orig_qmi_ResponseBase_ResponseBase(a1, a2, a3);
} //DYLD_INTERPOSE(_qmi_ResponseBase_ResponseBase2, qmi_ResponseBase_ResponseBase2)

//#define qmi_createRequest _ZN3qmi13createRequestEhhttU13block_pointerFvPhmE
//extern "C" unsigned int qmi_createRequest(void *a1, void *a2, void *a3, void *a4, void *a5, void *a6);
//static unsigned int (*orig_qmi_createRequest)(void *a1, void *a2, void *a3, void *a4, void *a5, void *a6);
//unsigned int _qmi_createRequest(void *a1, void *a2, void *a3, void *a4, void *a5, void *a6) {
//    DEBUG_LOG_RED
//    qmilog("\t-> self:%p, a2:0x%02x, a3:0x%02x, a4:0x%02x, a5:0x%02x\n", a1, a2, a3, a4, a5);
//    return orig_qmi_createRequest(a1, a2, a3, a4, a5, a6);
//} //DYLD_INTERPOSE(_func_name, func_name)

#pragma mark -

void hook_libQMIParserDynamic() {
    MSHookFunction((void *)&qmi_MessageBase_MessageBase, (void *)&_qmi_MessageBase_MessageBase, (void **)&orig_qmi_MessageBase_MessageBase);
//    MSHookFunction((void *)&qmi_ResponseBase_ResponseBase, (void *)&_qmi_ResponseBase_ResponseBase, (void **)&orig_qmi_ResponseBase_ResponseBase);
//    MSHookFunction((void *)&qmi_createRequest, (void *)&_qmi_createRequest, (void **)&orig_qmi_createRequest);
};
