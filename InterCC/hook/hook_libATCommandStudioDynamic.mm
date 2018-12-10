//
//  hook_libATCommandStudioDynamic.mm
//  InterCC
//
//  Created by Danylo Kostyshyn on 1/8/19.
//  Copyright © 2019 Danylo Kostyshyn. All rights reserved.
//

#include "hook_libATCommandStudioDynamic.h"

#include "util.h"
#include <substrate.h>

#include "qmi.h"
#include <memory>
#include <string>

typedef struct xpc_connection_s * xpc_connection_t;

#define qmi_Client_create _ZN3qmi6Client6createERKNSt3__112basic_stringIcNS1_11char_traitsIcEENS1_9allocatorIcEEEENS_11ServiceTypeEP16dispatch_queue_sS9_P17_xpc_connection_s
extern "C" unsigned int qmi_Client_create(void *a1, std::string const &a2, QmiService a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6);
static unsigned int (*orig_qmi_Client_create)(void *a1, std::string const &a2, QmiService a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6);
unsigned int _qmi_Client_create(void *a1, std::string const &a2, QmiService a3, dispatch_queue_t a4, std::string const &a5, xpc_connection_t a6) {
    DEBUG_LOG_RED
    qmilog("\t-> qmi::Client::create %p\n", a1);
    qmilog("\t-> a2: %s, a3: 0x%02x (%d), a5: %s\n", a2.c_str(), a3, a3, a5.c_str());
    return orig_qmi_Client_create(a1, a2, a3, a4, a5, a6);
} //DYLD_INTERPOSE(_qmi_Client_create, qmi_Client_create)

typedef struct QMux QMux;
typedef unsigned int QMIClientCallback;

#define QMIClient_requestClient _ZN9QMIClient13requestClientERKNSt3__112basic_stringIcNS0_11char_traitsIcEENS0_9allocatorIcEEEEN3qmi11ServiceTypeERK4QMuxP17QMIClientCallbackbb
extern "C" unsigned int QMIClient_requestClient(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7);
static unsigned int (*orig_QMIClient_requestClient)(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7);
unsigned int _QMIClient_requestClient(void *a1, std::string const &a2, QmiService a3, QMux const &a4, QMIClientCallback *a5, bool a6, bool a7) {
    DEBUG_LOG_RED
    qmilog("\t-> QMIClient::requestClient %p\n", a1);
    return orig_QMIClient_requestClient(a1, a2, a3, a4, a5, a6, a7);
} //DYLD_INTERPOSE(_QMIClient_requestClient, QMIClient_requestClient)

class ATCSIPCDriver { };

class ATCSResetInvoker { };

#define QMux_QMux _ZN4QMuxC1EP13ATCSIPCDriverPvRKNSt3__112basic_stringIcNS3_11char_traitsIcEENS3_9allocatorIcEEEEP16ATCSResetInvokerbb
extern "C" unsigned int QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7);
static unsigned int (*orig_QMux_QMux)(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7);
unsigned int _QMux_QMux(void *a1, ATCSIPCDriver *a2, void *a3, std::string const &a4, ATCSResetInvoker *a5, bool a6, bool a7) {
    DEBUG_LOG_RED
    return orig_QMux_QMux(a1, a2, a3, a4, a5, a6, a7);
} //DYLD_INTERPOSE(_QMux_QMux, QMux_QMux)

#define qmi_Client_Client _ZN3qmi6ClientC1ERKNSt3__18weak_ptrINS0_5StateEEE
typedef unsigned int qmi_Client_State;
extern "C" unsigned int qmi_Client_Client(void *a1, qmi_Client_State a2);
static unsigned int (*orig_qmi_Client_Client)(void *a1, qmi_Client_State a2);
unsigned int _qmi_Client_Client(void *a1, qmi_Client_State a2) {
    DEBUG_LOG_RED
    qmilog("\t-> qmi::Client::Client() %p\n", a1);
    return orig_qmi_Client_Client(a1, a2);
} //DYLD_INTERPOSE(_qmi_Client_Client, qmi_Client_Client)

#define qmi_Client_dealloc _ZN3qmi6ClientD1Ev
extern "C" unsigned int qmi_Client_dealloc(void *a1);
static unsigned int (*orig_qmi_Client_dealloc)(void *a1);
unsigned int _qmi_Client_dealloc(void *a1) {
    DEBUG_LOG_RED
    qmilog("\t-> qmi::Client::~Client() %p\n", a1);
    return orig_qmi_Client_dealloc(a1);
} //DYLD_INTERPOSE(_qmi_Client_dealloc, qmi_Client_dealloc)

// set int

//#define qmi_Client_set_int _ZN3qmi6Client3setEPKci
//extern "C" unsigned int qmi_Client_set_int(void *a1, char const *a2, int a3);
//unsigned int _qmi_Client_set_int(void *a1, char const *a2, int a3) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::set_int %p\n", a1);
//    return qmi_Client_set_int(a1, a2 ,a3);
//} DYLD_INTERPOSE(_qmi_Client_set_int, qmi_Client_set_int)

// set uint

//#define qmi_Client_set_uint _ZN3qmi6Client3setEPKcj
//extern "C" unsigned int qmi_Client_set_uint(void *a1, char const *a2, unsigned int a3);
//unsigned int _qmi_Client_set_uint(void *a1, char const *a2, unsigned int a3) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::set_uint %p\n", a1);
//    return qmi_Client_set_uint(a1, a2 ,a3);
//} DYLD_INTERPOSE(_qmi_Client_set_uint, qmi_Client_set_uint)

// start

//#define qmi_Client_start _ZNK3qmi6Client5startEv
//extern "C" unsigned int qmi_Client_start(void *a1);
//unsigned int _qmi_Client_start(void *a1) {
//    DEBUG_LOG
//    qmilog("\t-> qmi::Client::start %p\n", a1);
//    return qmi_Client_start(a1);
//} DYLD_INTERPOSE(_qmi_Client_start, qmi_Client_start)

// stop

// #define qmi_Client_stop _ZNK3qmi6Client4stopEv
// extern "C" unsigned int qmi_Client_stop(void *a1);
// unsigned int _qmi_Client_stop(void *a1) {
//     DEBUG_LOG
//     qmilog("\t-> qmi::Client::stop %p\n", a1);
//     return qmi_Client_stop(a1);
// } DYLD_INTERPOSE(_qmi_Client_stop, qmi_Client_stop)

// getName

// #define qmi_Client_getName _ZNK3qmi6Client7getNameEv
// extern "C" void * qmi_Client_getName(void *a1);
// void * _qmi_Client_getName(void *a1) {
//     DEBUG_LOG
//     qmilog("\t-> qmi::Client::getName %p\n", a1);
//     return qmi_Client_getName(a1);
// } DYLD_INTERPOSE(_qmi_Client_getName, qmi_Client_getName)

// getSvcType

//#define qmi_Client_getSvcType _ZNK3qmi6Client10getSvcTypeEv
//extern "C" unsigned int qmi_Client_getSvcType(void *a1);
//unsigned int _qmi_Client_getSvcType(void *a1) {
//    DEBUG_LOG
//    unsigned int result = qmi_Client_getSvcType(a1);
//    qmilog("\t-> qmi::Client::getSvcType %p 0x%02x (%d)\n", a1, result, result);
//    return result;
//} DYLD_INTERPOSE(_qmi_Client_getSvcType, qmi_Client_getSvcType)

//#define qmi_Client_send _ZNK3qmi6Client4sendERNS0_9SendProxyE
//extern "C" unsigned int qmi_Client_send(void *a1, void *a2);
//unsigned int _qmi_Client_send(void *a1, void *a2) {
//    DEBUG_LOG
//    return qmi_Client_send(a1, a2);
//} DYLD_INTERPOSE(_qmi_Client_send, qmi_Client_send)

//#define QMux_State_getWriteData _ZN4QMux5State12getWriteDataEPhj
//extern "C" unsigned int QMux_State_getWriteData(void *a1, void *a2, unsigned a3);
//static unsigned int (*orig_QMux_State_getWriteData)(void *a1, void *a2, unsigned a3);
//unsigned int _QMux_State_getWriteData(void *a1, void *a2, unsigned a3) {
//    DEBUG_LOG_RED
//    if (a2 != NULL) {
//        qmilog("\t-> a2: %p %d\n", a2, a3);
////        hexdumpct((uint8_t *)a2, a3);
//    }
//    return orig_QMux_State_getWriteData(a1, a2, a3);
//} //DYLD_INTERPOSE(_func_name, func_name)

//#define QMux_State_getWriteData_sync _ZN4QMux5State17getWriteData_syncEPhj
//extern "C" unsigned int QMux_State_getWriteData_sync(void *a1, void *a2, unsigned a3);
//static unsigned int (*orig_QMux_State_getWriteData_sync)(void *a1, void *a2, unsigned a3);
//unsigned int _QMux_State_getWriteData_sync(void *a1, void *a2, unsigned a3) {
//    DEBUG_LOG_RED
//    if (a2 != NULL) {
//        qmilog("\t-> a2: %p %d\n", a2, a3);
////        hexdumpct((uint8_t *)a2, a3);
//    }
//    return orig_QMux_State_getWriteData_sync(a1, a2, a3);
//} //DYLD_INTERPOSE(_func_name, func_name)

//_text:31DC69B4 ; QMux::send(std::__1::shared_ptr<qmi::QMuxClientIface>, unsigned short, QMIServiceMsg const&)
//__text:31DC69B4                 EXPORT __ZN4QMux4sendENSt3__110shared_ptrIN3qmi15QMuxClientIfaceEEEtRK13QMIServiceMsg
//__text:31DC69B4 __ZN4QMux4sendENSt3__110shared_ptrIN3qmi15QMuxClientIfaceEEEtRK13QMIServiceMsg
//__text:31DC69B4                                         ; CODE XREF: qmi::TransactionQueue::State::sendNow_sync(void)+E8↑p
//__text:31DC69B4                                         ; sub_31DDF63C+CA↓p

//#define QMux_send _ZN4QMux4sendENSt3__110shared_ptrIN3qmi15QMuxClientIfaceEEEtRK13QMIServiceMsg
//extern "C" unsigned int QMux_send(void *a1, void *a2, unsigned short a3, void *a4);
//static unsigned int (*orig_QMux_send)(void *a1, void *a2, unsigned short a3, void *a4);
//unsigned int _QMux_send(void *a1, void *a2, unsigned short a3, void *a4) {
//    DEBUG_LOG_RED
//    qmilog("\t-> a3: %d\n", a3);
//    hexdumpct((uint8_t *)a4, a3);
//    return orig_QMux_send(a1, a2, a3, a4);
//} //DYLD_INTERPOSE(_func_name, func_name)

#pragma mark - 

void hook_libATCommandStudioDynamic() {
//    MSHookFunction((void *)&qmi_Client_create, (void *)&_qmi_Client_create, (void **)&orig_qmi_Client_create);
//    MSHookFunction((void *)&QMIClient_requestClient, (void *)&_QMIClient_requestClient, (void **)&orig_QMIClient_requestClient);
//    MSHookFunction((void *)&QMux_QMux, (void *)&_QMux_QMux, (void **)&orig_QMux_QMux);
//    MSHookFunction((void *)&qmi_Client_Client, (void *)&_qmi_Client_Client, (void **)&orig_qmi_Client_Client);
//    MSHookFunction((void *)&qmi_Client_dealloc, (void *)&_qmi_Client_dealloc, (void **)&orig_qmi_Client_dealloc);
    
//    MSHookFunction((void *)&QMux_State_getWriteData, (void *)&_QMux_State_getWriteData, (void **)&orig_QMux_State_getWriteData);
//    MSHookFunction((void *)&QMux_State_getWriteData_sync, (void *)&_QMux_State_getWriteData_sync, (void **)&orig_QMux_State_getWriteData_sync);

//    MSHookFunction((void *)&QMux_send, (void *)&_QMux_send, (void **)&orig_QMux_send);
}
